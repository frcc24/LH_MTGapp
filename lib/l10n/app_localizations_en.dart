// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lighthouse Life';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get continueLabel => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get save => 'Save';

  @override
  String get clear => 'Clear';

  @override
  String get undo => 'Undo';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get retry => 'Try again';

  @override
  String get turnBadge => 'TURN';

  @override
  String get yourTurnBadge => 'YOUR TURN';

  @override
  String get eliminatedBadge => 'ELIMINATED';

  @override
  String get lethalBadge => 'LETHAL';

  @override
  String get reviveAction => 'Revive';

  @override
  String semLifeOf(String name, int life) {
    return '$name, $life life';
  }

  @override
  String semGainLife(String name) {
    return '$name, gain 1 life';
  }

  @override
  String semLoseLife(String name) {
    return '$name, lose 1 life';
  }

  @override
  String semGainFive(String name) {
    return '$name, gain 5 life';
  }

  @override
  String semLoseFive(String name) {
    return '$name, lose 5 life';
  }

  @override
  String semOpenDrawer(String name) {
    return 'Open counters for $name';
  }

  @override
  String get semPassTurn => 'Pass the turn';

  @override
  String get semEnterLife => 'Enter exact life';

  @override
  String get cmdShort => 'CMD';

  @override
  String winnerPrompt(String names) {
    return '$names won?';
  }

  @override
  String get seeResult => 'See result';

  @override
  String get matchMenu => 'Match menu';

  @override
  String get pass => 'Pass';

  @override
  String get pauseTimer => 'Pause timer';

  @override
  String get tools => 'Tools';

  @override
  String roundN(int n) {
    return 'Round $n';
  }

  @override
  String roundShort(int n) {
    return 'R$n';
  }

  @override
  String get flipDialog => 'Flip to the other side';

  @override
  String get quickSettings => 'Settings';

  @override
  String get holdRestart => 'Hold to restart';

  @override
  String get holdEnd => 'Hold to end match';

  @override
  String get holdLeave => 'Hold to leave';

  @override
  String get resume => 'Back to the match';

  @override
  String get tabCounters => 'Counters';

  @override
  String get tabCommander => 'Commander';

  @override
  String get tabHistory => 'History';

  @override
  String get counterPoison => 'Poison';

  @override
  String get counterEnergy => 'Energy';

  @override
  String get counterExperience => 'Experience';

  @override
  String get counterRadiation => 'Radiation';

  @override
  String get counterMonarch => 'Monarch';

  @override
  String get counterInitiative => 'Initiative';

  @override
  String get counterDayNight => 'Day/Night';

  @override
  String get counterRing => 'Ring';

  @override
  String get noCountersEnabled => 'No counters enabled. Turn them on in Match setup.';

  @override
  String get day => 'Day';

  @override
  String get night => 'Night';

  @override
  String cmdFrom(String name) {
    return 'Damage from $name';
  }

  @override
  String partnerOf(String name) {
    return 'Partner of $name';
  }

  @override
  String get addPartner => '+ partner';

  @override
  String commanderTax(int n) {
    return 'Commander tax (+$n)';
  }

  @override
  String get historyEmpty => 'Nothing recorded yet.';

  @override
  String get life => 'Life';

  @override
  String get toolDice => 'Dice';

  @override
  String get toolCoin => 'Coin';

  @override
  String get toolPlanar => 'Planar';

  @override
  String get toolPicker => 'Pick';

  @override
  String get toolTimer => 'Timer';

  @override
  String get diceCount => 'dice';

  @override
  String get roll => 'Roll';

  @override
  String get heads => 'HEADS';

  @override
  String get tails => 'TAILS';

  @override
  String get flip => 'Flip the coin';

  @override
  String get planarChaos => 'CHAOS';

  @override
  String get planarWalk => 'PLANESWALK';

  @override
  String get planarBlank => 'BLANK';

  @override
  String get pickPlayer => 'Pick a player';

  @override
  String get start => 'Start';

  @override
  String get newMatch => 'New match';

  @override
  String get playersLabel => 'Players';

  @override
  String playersCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n players', one: '1 player');
    return '$_temp0';
  }

  @override
  String get formatLabel => 'Format';

  @override
  String get formatCustom => 'Custom';

  @override
  String get startingLife => 'Starting life';

  @override
  String get tapToType => 'Tap the number to type';

  @override
  String lifeTotal(int n) {
    return '$n life';
  }

  @override
  String get whoPlays => 'Who plays';

  @override
  String get playTeams => 'Play in teams';

  @override
  String get countersLabel => 'Counters in the match';

  @override
  String get turnTimer => 'Turn timer';

  @override
  String get noTimer => 'Off';

  @override
  String get layoutLabel => 'Layout';

  @override
  String get layoutSides => 'Side columns';

  @override
  String get layoutTopFlipped => 'Top row flipped';

  @override
  String get whoStarts => 'Who starts';

  @override
  String get starterRandom => 'Random';

  @override
  String get starterChoose => 'Choose';

  @override
  String get startMatch => 'Start';

  @override
  String playerDefault(int n) {
    return 'Player $n';
  }

  @override
  String get editPlayer => 'Edit player';

  @override
  String get nameLabel => 'Name';

  @override
  String get deckLabel => 'Deck (optional)';

  @override
  String get noDeck => 'No deck';

  @override
  String deckIs(String deck) {
    return 'Deck: $deck';
  }

  @override
  String get settings => 'Settings';

  @override
  String get lastConfig => 'Last setup';

  @override
  String get configureOther => 'Set up another match';

  @override
  String get continueMatch => 'Resume match';

  @override
  String get toolsSub => 'dice, coin, timer';

  @override
  String get cards => 'Cards';

  @override
  String get cardsSub => 'search and legality';

  @override
  String get manaBase => 'Mana base';

  @override
  String get manaSub => 'lands per color';

  @override
  String get history => 'History';

  @override
  String historySub(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n matches', one: '1 match');
    return '$_temp0';
  }

  @override
  String get removeAds => 'Remove';

  @override
  String get wins => 'wins';

  @override
  String get matchOver => 'Match over';

  @override
  String get duration => 'duration';

  @override
  String get rounds => 'rounds';

  @override
  String get rematch => 'Rematch';

  @override
  String get changeConfig => 'Change setup';

  @override
  String get home => 'Home';

  @override
  String get reasonLife => 'Out of life';

  @override
  String get reasonPoison => 'Poison';

  @override
  String get reasonCommander => 'Commander damage';

  @override
  String get onb1Title => 'Life counter for the table';

  @override
  String get onb1Body =>
      'Huge numbers, big targets and nothing in the way. Built for the table, phone lying in the middle.';

  @override
  String get onb2Title => 'From 1 to 4 players';

  @override
  String get onb2Body => 'Each panel turns toward whoever sits there. Commander, Brawl, Two-Headed Giant and more.';

  @override
  String get onb3Title => 'Everything at hand';

  @override
  String get onb3Body => 'Dice, coin, turn timer, commander damage, card search and mana base.';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get sectionMatch => 'Match';

  @override
  String get keepAwake => 'Keep screen on';

  @override
  String get haptics => 'Haptics';

  @override
  String get sounds => 'Sounds';

  @override
  String get lockOrientation => 'Lock portrait';

  @override
  String get defaultTimer => 'Default turn timer';

  @override
  String get sectionLook => 'Appearance';

  @override
  String get colorBlind => 'Color-blind mode';

  @override
  String get colorBlindSub => 'Distinct border pattern per player';

  @override
  String get followsSystem => 'Motion and text size follow the system.';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get langSystem => 'System';

  @override
  String get sectionPurchases => 'Purchases and privacy';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get nothingToRestore => 'No purchases to restore.';

  @override
  String get adsAndTracking => 'Ads and tracking';

  @override
  String get consentUnknown => 'Not chosen yet';

  @override
  String get consentPersonalized => 'Personalized ads';

  @override
  String get consentNonPersonalized => 'Non-personalized ads';

  @override
  String get consentTitle => 'Ads in the free app';

  @override
  String get consentBody =>
      'The app is free and shows ads outside of matches. You choose whether they can be personalized. You can change this later in Settings.';

  @override
  String get attPreTitle => 'Ads and privacy';

  @override
  String get attPreBody =>
      'We will ask permission to personalize ads. If you decline, the app works the same, with less relevant ads.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms of use';

  @override
  String get about => 'About';

  @override
  String versionN(String v) {
    return 'Version $v';
  }

  @override
  String get legalNotice =>
      'Unofficial app, not affiliated with or endorsed by Wizards of the Coast. Magic: The Gathering is a trademark of Wizards of the Coast LLC.';

  @override
  String get aboutContact => 'Contact and info';

  @override
  String get sendSuggestion => 'Send feedback';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get credits => 'Credits';

  @override
  String get creditsBody =>
      'Card data, images and mana symbols: Scryfall. Fonts: Big Shoulders Display and Instrument Sans (SIL OFL). Icons: Font Awesome.';

  @override
  String get proName => 'Lighthouse Pro';

  @override
  String get proTagline => 'No ads and full history. One-time purchase.';

  @override
  String get proFreeAds => 'Ads outside matches';

  @override
  String get proPaidNoAds => 'No ads at all';

  @override
  String proFreeHistory(int n) {
    return 'History of the last $n';
  }

  @override
  String get proPaidHistory => 'Unlimited history';

  @override
  String buyPro(String price) {
    return 'Buy for $price';
  }

  @override
  String get oneTimeNote => 'One-time purchase. Not a subscription.';

  @override
  String get proOwned => 'You already have Pro. Thank you!';

  @override
  String get storeUnavailable => 'Store unavailable right now';

  @override
  String get historyNone => 'No matches yet';

  @override
  String get historyNoneSub => 'Finished matches show up here, on this device only.';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryAsk => 'Delete all recorded matches?';

  @override
  String get statMatches => 'matches';

  @override
  String get statAvg => 'average length';

  @override
  String get statTopFormat => 'most played format';

  @override
  String get byFormat => 'By format';

  @override
  String get byPlayer => 'Wins per player';

  @override
  String get recentMatches => 'Recent matches';

  @override
  String historyFreeLimit(int n) {
    return 'The free version keeps the last $n matches.';
  }

  @override
  String get manaTotalLands => 'Total lands';

  @override
  String get manaHint60 => '60 cards: 24';

  @override
  String get manaHintCommander => 'Commander: 37';

  @override
  String get manaSymbols => 'Mana symbols in the deck';

  @override
  String get manaResult => 'Lands per color';

  @override
  String get manaEmpty => 'Count the mana symbols across your deck and enter them above. The result shows up here.';

  @override
  String get searchCardHint => 'Search card by name';

  @override
  String get typeCreature => 'Creature';

  @override
  String get typeInstant => 'Instant';

  @override
  String get typeSorcery => 'Sorcery';

  @override
  String get typeArtifact => 'Artifact';

  @override
  String get typeEnchantment => 'Enchantment';

  @override
  String get typeLand => 'Land';

  @override
  String get typePlaneswalker => 'Planeswalker';

  @override
  String get manaValueAny => 'Cost: any';

  @override
  String manaValueMax(int n) {
    return 'Cost ≤ $n';
  }

  @override
  String get scryfallCredit => 'Data and images: Scryfall';

  @override
  String get cardsIdleTitle => 'Look up a card';

  @override
  String get cardsIdleSub => 'Type at least 2 letters or use the color, type and cost filters.';

  @override
  String get networkErrorTitle => 'No connection';

  @override
  String get networkErrorSub => 'Search needs internet. The rest of the app works offline.';

  @override
  String get noResults => 'No cards found';

  @override
  String get noResultsSub => 'Check the spelling or try a suggestion.';

  @override
  String resultsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n cards', one: '1 card');
    return '$_temp0';
  }

  @override
  String get flipCard => 'Flip card';

  @override
  String get legality => 'Legality';

  @override
  String get legal => 'legal';

  @override
  String get notLegal => 'not legal';

  @override
  String get restricted => 'restricted';

  @override
  String get banned => 'banned';

  @override
  String get viewOnScryfall => 'View on Scryfall';
}
