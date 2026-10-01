import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/match/domain/models.dart';
import '../../l10n/app_localizations.dart';
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

extension CounterTypeLabel on CounterType {
  String label(AppL10n l) => switch (this) {
    CounterType.poison => l.counterPoison,
    CounterType.energy => l.counterEnergy,
    CounterType.experience => l.counterExperience,
    CounterType.radiation => l.counterRadiation,
    CounterType.commander => l.tabCommander,
    CounterType.monarch => l.counterMonarch,
    CounterType.initiative => l.counterInitiative,
    CounterType.ring => l.counterRing,
    CounterType.dayNight => l.counterDayNight,
  };
}

extension ManaColorLabel on ManaColor {
  String localized(AppL10n l) => switch (this) {
    ManaColor.white => l.manaWhite,
    ManaColor.blue => l.manaBlue,
    ManaColor.black => l.manaBlack,
    ManaColor.red => l.manaRed,
    ManaColor.green => l.manaGreen,
    ManaColor.colorless => l.manaColorless,
  };
}
