import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

const _key = 'pro_entitlement';

/// Direito local do Lighthouse Pro. O `IapService` grava aqui depois de validar a compra.
class ProNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
  }
}

final isProProvider = NotifierProvider<ProNotifier, bool>(ProNotifier.new);

/// Limites do plano grátis (o Pro remove todos).
abstract final class FreeLimits {
  static const history = 20;
  static const savedPlayers = 6;
}
