import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'pro_state.dart';

const proProductId = 'lighthouse_pro';

class IapState {
  const IapState({this.available = false, this.products = const {}, this.busy = false, this.error});
  final bool available;
  final Map<String, ProductDetails> products;
  final bool busy;
  final String? error;

  ProductDetails? get pro => products[proProductId];

  IapState copyWith({
    bool? available,
    Map<String, ProductDetails>? products,
    bool? busy,
    String? error,
    bool clearError = false,
  }) => IapState(
    available: available ?? this.available,
    products: products ?? this.products,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Compra única do Lighthouse Pro (não consumível). Não há outros produtos.
/// Ouve `purchaseStream` desde o início do app, conclui pendências e grava o direito localmente.
class IapNotifier extends Notifier<IapState> {
  StreamSubscription<List<PurchaseDetails>>? _sub;
  InAppPurchase? _iap;

  @override
  IapState build() {
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(_init);
    return const IapState();
  }

  Future<void> _init() async {
    try {
      _iap = InAppPurchase.instance;
      _sub = _iap!.purchaseStream.listen(_onPurchases, onError: (_) {});
      final ok = await _iap!.isAvailable();
      if (!ok) return;
      final resp = await _iap!.queryProductDetails({proProductId});
      state = state.copyWith(available: true, products: {for (final p in resp.productDetails) p.id: p});
      // revalida o direito na abertura
      await _iap!.restorePurchases();
    } catch (_) {
      // plataforma sem loja (desktop/teste): o app segue grátis
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list) {
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (p.productID == proProductId) await ref.read(isProProvider.notifier).set(true);
          state = state.copyWith(busy: false, clearError: true);
        case PurchaseStatus.error:
          state = state.copyWith(busy: false, error: p.error?.message);
        case PurchaseStatus.canceled:
          state = state.copyWith(busy: false);
        case PurchaseStatus.pending:
          state = state.copyWith(busy: true);
      }
      if (p.pendingCompletePurchase) await _iap?.completePurchase(p);
    }
  }

  Future<void> buyPro() async {
    final product = state.pro;
    if (product == null || _iap == null) return;
    state = state.copyWith(busy: true, clearError: true);
    try {
      await _iap!.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
    } catch (e) {
      state = state.copyWith(busy: false, error: '$e');
    }
  }

  Future<void> restore() async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      await _iap?.restorePurchases();
    } catch (e) {
      state = state.copyWith(error: '$e');
    }
    state = state.copyWith(busy: false);
  }
}

final iapProvider = NotifierProvider<IapNotifier, IapState>(IapNotifier.new);
