import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/match/domain/models.dart';
import 'app_tokens.dart';

extension PlayerGlyphIcon on PlayerGlyph {
  FaIconData get icon => switch (this) {
    PlayerGlyph.flame => FontAwesomeIcons.fire,
    PlayerGlyph.drop => FontAwesomeIcons.droplet,
    PlayerGlyph.gem => FontAwesomeIcons.gem,
    PlayerGlyph.leaf => FontAwesomeIcons.leaf,
    PlayerGlyph.star => FontAwesomeIcons.star,
    PlayerGlyph.shield => FontAwesomeIcons.shieldHalved,
  };
}

extension CounterTypeVisual on CounterType {
  FaIconData get icon => switch (this) {
    CounterType.poison => FontAwesomeIcons.skull,
    CounterType.energy => FontAwesomeIcons.bolt,
    CounterType.experience => FontAwesomeIcons.star,
    CounterType.radiation => FontAwesomeIcons.radiation,
    CounterType.commander => FontAwesomeIcons.shieldHalved,
    CounterType.monarch => FontAwesomeIcons.crown,
    CounterType.initiative => FontAwesomeIcons.dungeon,
    CounterType.ring => FontAwesomeIcons.ring,
    CounterType.dayNight => FontAwesomeIcons.sun,
  };

  Color get color => switch (this) {
    CounterType.poison => AppColors.poison,
    CounterType.energy => AppColors.energy,
    CounterType.experience => AppColors.experience,
    CounterType.radiation => AppColors.radiation,
    CounterType.commander => AppColors.commander,
    _ => AppColors.accent,
  };
}
