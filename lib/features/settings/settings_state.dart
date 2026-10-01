import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';

/// Consentimento de anúncios e rastreamento (Unity Ads).
enum AdsConsent { unknown, personalized, nonPersonalized }

class AppSettings {
  const AppSettings({
    this.localeCode,
    this.useSystemTheme = false,
    this.keepAwake = true,
    this.haptics = true,
    this.sounds = false,
    this.lockOrientation = false,
    this.shakeUndo = false,
    this.colorBlind = false,
    this.defaultTimerSeconds = 0,
    this.onboardingDone = false,
    this.adsConsent = AdsConsent.unknown,
    this.matchesFinished = 0,
    this.sessions = 0,
    this.lastInterstitialAt,
    this.matchesSinceInterstitial = 0,
    this.attPromptShown = false,
  });

  /// null = idioma do sistema.
  final String? localeCode;

  /// Tema claro é da v1.1; por enquanto "sistema" também resulta no escuro.
  final bool useSystemTheme;
  final bool keepAwake;
  final bool haptics;
  final bool sounds;
  final bool lockOrientation;
  final bool shakeUndo;
  final bool colorBlind;
  final int defaultTimerSeconds;
  final bool onboardingDone;
  final AdsConsent adsConsent;
  final int matchesFinished;
  final int sessions;
  final DateTime? lastInterstitialAt;
  final int matchesSinceInterstitial;
  final bool attPromptShown;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);

  AppSettings copyWith({
    String? localeCode,
    bool clearLocale = false,
    bool? useSystemTheme,
    bool? keepAwake,
    bool? haptics,
    bool? sounds,
    bool? lockOrientation,
    bool? shakeUndo,
    bool? colorBlind,
    int? defaultTimerSeconds,
    bool? onboardingDone,
    AdsConsent? adsConsent,
    int? matchesFinished,
    int? sessions,
    DateTime? lastInterstitialAt,
    int? matchesSinceInterstitial,
    bool? attPromptShown,
  }) => AppSettings(
    localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
    useSystemTheme: useSystemTheme ?? this.useSystemTheme,
    keepAwake: keepAwake ?? this.keepAwake,
    haptics: haptics ?? this.haptics,
    sounds: sounds ?? this.sounds,
    lockOrientation: lockOrientation ?? this.lockOrientation,
    shakeUndo: shakeUndo ?? this.shakeUndo,
    colorBlind: colorBlind ?? this.colorBlind,
    defaultTimerSeconds: defaultTimerSeconds ?? this.defaultTimerSeconds,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    adsConsent: adsConsent ?? this.adsConsent,
    matchesFinished: matchesFinished ?? this.matchesFinished,
    sessions: sessions ?? this.sessions,
    lastInterstitialAt: lastInterstitialAt ?? this.lastInterstitialAt,
    matchesSinceInterstitial: matchesSinceInterstitial ?? this.matchesSinceInterstitial,
    attPromptShown: attPromptShown ?? this.attPromptShown,
  );
}

class _K {
  static const locale = 'locale';
  static const systemTheme = 'system_theme';
  static const keepAwake = 'keep_awake';
  static const haptics = 'haptics';
  static const sounds = 'sounds';
  static const lockOrientation = 'lock_orientation';
  static const shakeUndo = 'shake_undo';
  static const colorBlind = 'color_blind';
  static const timer = 'default_timer';
  static const onboarding = 'onboarding_done';
  static const consent = 'ads_consent';
  static const matchesFinished = 'matches_finished';
  static const sessions = 'sessions';
  static const lastInterstitial = 'last_interstitial';
  static const sinceInterstitial = 'since_interstitial';
  static const att = 'att_prompt_shown';
}

class SettingsNotifier extends Notifier<AppSettings> {
  late SharedPreferences _p;

  @override
  AppSettings build() {
    _p = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      localeCode: _p.getString(_K.locale),
      useSystemTheme: _p.getBool(_K.systemTheme) ?? false,
      keepAwake: _p.getBool(_K.keepAwake) ?? true,
      haptics: _p.getBool(_K.haptics) ?? true,
      sounds: _p.getBool(_K.sounds) ?? false,
      lockOrientation: _p.getBool(_K.lockOrientation) ?? false,
      shakeUndo: _p.getBool(_K.shakeUndo) ?? false,
      colorBlind: _p.getBool(_K.colorBlind) ?? false,
      defaultTimerSeconds: _p.getInt(_K.timer) ?? 0,
      onboardingDone: _p.getBool(_K.onboarding) ?? false,
      adsConsent: AdsConsent.values.byName(_p.getString(_K.consent) ?? 'unknown'),
      matchesFinished: _p.getInt(_K.matchesFinished) ?? 0,
      sessions: _p.getInt(_K.sessions) ?? 0,
      lastInterstitialAt: _p.getInt(_K.lastInterstitial) == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(_p.getInt(_K.lastInterstitial)!),
      matchesSinceInterstitial: _p.getInt(_K.sinceInterstitial) ?? 0,
      attPromptShown: _p.getBool(_K.att) ?? false,
    );
  }

  void _set(AppSettings next, Future<void> Function() write) {
    state = next;
    write();
  }

  void setLocale(String? code) => _set(
    state.copyWith(localeCode: code, clearLocale: code == null),
    () => code == null ? _p.remove(_K.locale) : _p.setString(_K.locale, code),
  );
  void setUseSystemTheme(bool v) => _set(state.copyWith(useSystemTheme: v), () => _p.setBool(_K.systemTheme, v));
  void setKeepAwake(bool v) => _set(state.copyWith(keepAwake: v), () => _p.setBool(_K.keepAwake, v));
  void setHaptics(bool v) => _set(state.copyWith(haptics: v), () => _p.setBool(_K.haptics, v));
  void setSounds(bool v) => _set(state.copyWith(sounds: v), () => _p.setBool(_K.sounds, v));
  void setLockOrientation(bool v) => _set(state.copyWith(lockOrientation: v), () => _p.setBool(_K.lockOrientation, v));
  void setShakeUndo(bool v) => _set(state.copyWith(shakeUndo: v), () => _p.setBool(_K.shakeUndo, v));
  void setColorBlind(bool v) => _set(state.copyWith(colorBlind: v), () => _p.setBool(_K.colorBlind, v));
  void setDefaultTimer(int seconds) =>
      _set(state.copyWith(defaultTimerSeconds: seconds), () => _p.setInt(_K.timer, seconds));
  void setOnboardingDone() => _set(state.copyWith(onboardingDone: true), () => _p.setBool(_K.onboarding, true));
  void setAdsConsent(AdsConsent c) => _set(state.copyWith(adsConsent: c), () => _p.setString(_K.consent, c.name));
  void setAttPromptShown() => _set(state.copyWith(attPromptShown: true), () => _p.setBool(_K.att, true));
  void bumpSessions() =>
      _set(state.copyWith(sessions: state.sessions + 1), () => _p.setInt(_K.sessions, state.sessions));

  /// Conta uma partida terminada para as regras de frequência do intersticial.
  void recordFinishedMatch() => _set(
    state.copyWith(
      matchesFinished: state.matchesFinished + 1,
      matchesSinceInterstitial: state.matchesSinceInterstitial + 1,
    ),
    () async {
      await _p.setInt(_K.matchesFinished, state.matchesFinished);
      await _p.setInt(_K.sinceInterstitial, state.matchesSinceInterstitial);
    },
  );

  void recordInterstitialShown(DateTime now) =>
      _set(state.copyWith(lastInterstitialAt: now, matchesSinceInterstitial: 0), () async {
        await _p.setInt(_K.lastInterstitial, now.millisecondsSinceEpoch);
        await _p.setInt(_K.sinceInterstitial, 0);
      });
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
