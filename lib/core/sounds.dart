import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/settings_state.dart';

enum Sfx {
  tap('sounds/btn.mp3'),
  dice('sounds/dice_shake.mp3'),
  tick('sounds/ticking_countdown.mp3'),
  restart('sounds/restart.mp3'),
  eliminated('sounds/explode.mp3');

  const Sfx(this.path);
  final String path;
}

/// Sons de efeito, desligados por padrão. Falha de plugin nunca derruba a tela.
class SoundService {
  SoundService(this._enabled);
  final bool Function() _enabled;
  final Map<Sfx, AudioPlayer> _players = {};

  Future<void> play(Sfx sfx) async {
    if (!_enabled()) return;
    try {
      final p = _players.putIfAbsent(sfx, () => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
      await p.stop();
      await p.play(AssetSource(sfx.path));
    } catch (_) {}
  }

  Future<void> stop(Sfx sfx) async {
    try {
      await _players[sfx]?.stop();
    } catch (_) {}
  }

  void dispose() {
    for (final p in _players.values) {
      p.dispose();
    }
  }
}

final soundProvider = Provider<SoundService>((ref) {
  final s = SoundService(() => ref.read(settingsProvider).sounds);
  ref.onDispose(s.dispose);
  return s;
});
