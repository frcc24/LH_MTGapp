import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es'), Locale('pt')];

  /// No description provided for @appName.
  ///
  /// In pt, this message translates to:
  /// **'Lighthouse Life'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @continueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueLabel;

  /// No description provided for @skip.
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get skip;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @undo.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get undo;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Apagar'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get retry;

  /// No description provided for @turnBadge.
  ///
  /// In pt, this message translates to:
  /// **'TURNO'**
  String get turnBadge;

  /// No description provided for @yourTurnBadge.
  ///
  /// In pt, this message translates to:
  /// **'SEU TURNO'**
  String get yourTurnBadge;

  /// No description provided for @eliminatedBadge.
  ///
  /// In pt, this message translates to:
  /// **'ELIMINADO'**
  String get eliminatedBadge;

  /// No description provided for @lethalBadge.
  ///
  /// In pt, this message translates to:
  /// **'LETAL'**
  String get lethalBadge;

  /// No description provided for @reviveAction.
  ///
  /// In pt, this message translates to:
  /// **'Reviver'**
  String get reviveAction;

  /// No description provided for @semLifeOf.
  ///
  /// In pt, this message translates to:
  /// **'{name}, {life} de vida'**
  String semLifeOf(String name, int life);

  /// No description provided for @semGainLife.
  ///
  /// In pt, this message translates to:
  /// **'{name}, ganhar 1 de vida'**
  String semGainLife(String name);

  /// No description provided for @semLoseLife.
  ///
  /// In pt, this message translates to:
  /// **'{name}, perder 1 de vida'**
  String semLoseLife(String name);

  /// No description provided for @semGainFive.
  ///
  /// In pt, this message translates to:
  /// **'{name}, ganhar 5 de vida'**
  String semGainFive(String name);

  /// No description provided for @semLoseFive.
  ///
  /// In pt, this message translates to:
  /// **'{name}, perder 5 de vida'**
  String semLoseFive(String name);

  /// No description provided for @semOpenDrawer.
  ///
  /// In pt, this message translates to:
  /// **'Abrir contadores de {name}'**
  String semOpenDrawer(String name);

  /// No description provided for @semPassTurn.
  ///
  /// In pt, this message translates to:
  /// **'Passar o turno'**
  String get semPassTurn;

  /// No description provided for @semEnterLife.
  ///
  /// In pt, this message translates to:
  /// **'Digitar vida exata'**
  String get semEnterLife;

  /// No description provided for @cmdShort.
  ///
  /// In pt, this message translates to:
  /// **'CMD'**
  String get cmdShort;

  /// No description provided for @winnerPrompt.
  ///
  /// In pt, this message translates to:
  /// **'{names} venceu?'**
  String winnerPrompt(String names);

  /// No description provided for @seeResult.
  ///
  /// In pt, this message translates to:
  /// **'Ver resultado'**
  String get seeResult;

  /// No description provided for @matchMenu.
  ///
  /// In pt, this message translates to:
  /// **'Menu da partida'**
  String get matchMenu;

  /// No description provided for @pass.
  ///
  /// In pt, this message translates to:
  /// **'Passar'**
  String get pass;

  /// No description provided for @pauseTimer.
  ///
  /// In pt, this message translates to:
  /// **'Pausar timer'**
  String get pauseTimer;

  /// No description provided for @tools.
  ///
  /// In pt, this message translates to:
  /// **'Ferramentas'**
  String get tools;

  /// No description provided for @roundN.
  ///
  /// In pt, this message translates to:
  /// **'Rodada {n}'**
  String roundN(int n);

  /// No description provided for @roundShort.
  ///
  /// In pt, this message translates to:
  /// **'R{n}'**
  String roundShort(int n);

  /// No description provided for @flipDialog.
  ///
  /// In pt, this message translates to:
  /// **'Girar para o outro lado'**
  String get flipDialog;

  /// No description provided for @quickSettings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get quickSettings;

  /// No description provided for @holdRestart.
  ///
  /// In pt, this message translates to:
  /// **'Segure para reiniciar'**
  String get holdRestart;

  /// No description provided for @holdEnd.
  ///
  /// In pt, this message translates to:
  /// **'Segure para encerrar'**
  String get holdEnd;

  /// No description provided for @holdLeave.
  ///
  /// In pt, this message translates to:
  /// **'Segure para sair'**
  String get holdLeave;

  /// No description provided for @resume.
  ///
  /// In pt, this message translates to:
  /// **'Voltar à partida'**
  String get resume;

  /// No description provided for @tabCounters.
  ///
  /// In pt, this message translates to:
  /// **'Contadores'**
  String get tabCounters;

  /// No description provided for @tabCommander.
  ///
  /// In pt, this message translates to:
  /// **'Comandante'**
  String get tabCommander;

  /// No description provided for @tabHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get tabHistory;

  /// No description provided for @counterPoison.
  ///
  /// In pt, this message translates to:
  /// **'Veneno'**
  String get counterPoison;

  /// No description provided for @counterEnergy.
  ///
  /// In pt, this message translates to:
  /// **'Energia'**
  String get counterEnergy;

  /// No description provided for @counterExperience.
  ///
  /// In pt, this message translates to:
  /// **'Experiência'**
  String get counterExperience;

  /// No description provided for @counterRadiation.
  ///
  /// In pt, this message translates to:
  /// **'Radiação'**
  String get counterRadiation;

  /// No description provided for @counterMonarch.
  ///
  /// In pt, this message translates to:
  /// **'Monarca'**
  String get counterMonarch;

  /// No description provided for @counterInitiative.
  ///
  /// In pt, this message translates to:
  /// **'Iniciativa'**
  String get counterInitiative;

  /// No description provided for @counterDayNight.
  ///
  /// In pt, this message translates to:
  /// **'Dia/Noite'**
  String get counterDayNight;

  /// No description provided for @counterRing.
  ///
  /// In pt, this message translates to:
  /// **'Anel'**
  String get counterRing;

  /// No description provided for @noCountersEnabled.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum contador ligado. Ligue abaixo.'**
  String get noCountersEnabled;

  /// No description provided for @day.
  ///
  /// In pt, this message translates to:
  /// **'Dia'**
  String get day;

  /// No description provided for @night.
  ///
  /// In pt, this message translates to:
  /// **'Noite'**
  String get night;

  /// No description provided for @cmdFrom.
  ///
  /// In pt, this message translates to:
  /// **'Dano de {name}'**
  String cmdFrom(String name);

  /// No description provided for @partnerOf.
  ///
  /// In pt, this message translates to:
  /// **'Parceiro de {name}'**
  String partnerOf(String name);

  /// No description provided for @addPartner.
  ///
  /// In pt, this message translates to:
  /// **'+ parceiro'**
  String get addPartner;

  /// No description provided for @commanderTax.
  ///
  /// In pt, this message translates to:
  /// **'Taxa de comandante (+{n})'**
  String commanderTax(int n);

  /// No description provided for @historyEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nada registrado ainda.'**
  String get historyEmpty;

  /// No description provided for @life.
  ///
  /// In pt, this message translates to:
  /// **'Vida'**
  String get life;

  /// No description provided for @toolDice.
  ///
  /// In pt, this message translates to:
  /// **'Dados'**
  String get toolDice;

  /// No description provided for @toolCoin.
  ///
  /// In pt, this message translates to:
  /// **'Moeda'**
  String get toolCoin;

  /// No description provided for @toolPlanar.
  ///
  /// In pt, this message translates to:
  /// **'Planar'**
  String get toolPlanar;

  /// No description provided for @toolPicker.
  ///
  /// In pt, this message translates to:
  /// **'Sorteio'**
  String get toolPicker;

  /// No description provided for @toolTimer.
  ///
  /// In pt, this message translates to:
  /// **'Timer'**
  String get toolTimer;

  /// No description provided for @diceCount.
  ///
  /// In pt, this message translates to:
  /// **'dado(s)'**
  String get diceCount;

  /// No description provided for @roll.
  ///
  /// In pt, this message translates to:
  /// **'Rolar'**
  String get roll;

  /// No description provided for @heads.
  ///
  /// In pt, this message translates to:
  /// **'CARA'**
  String get heads;

  /// No description provided for @tails.
  ///
  /// In pt, this message translates to:
  /// **'COROA'**
  String get tails;

  /// No description provided for @flip.
  ///
  /// In pt, this message translates to:
  /// **'Jogar a moeda'**
  String get flip;

  /// No description provided for @planarChaos.
  ///
  /// In pt, this message translates to:
  /// **'CAOS'**
  String get planarChaos;

  /// No description provided for @planarWalk.
  ///
  /// In pt, this message translates to:
  /// **'PLANAR'**
  String get planarWalk;

  /// No description provided for @planarBlank.
  ///
  /// In pt, this message translates to:
  /// **'VAZIO'**
  String get planarBlank;

  /// No description provided for @pickPlayer.
  ///
  /// In pt, this message translates to:
  /// **'Sortear jogador'**
  String get pickPlayer;

  /// No description provided for @start.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar'**
  String get start;

  /// No description provided for @newMatch.
  ///
  /// In pt, this message translates to:
  /// **'Nova partida'**
  String get newMatch;

  /// No description provided for @playersLabel.
  ///
  /// In pt, this message translates to:
  /// **'Jogadores'**
  String get playersLabel;

  /// No description provided for @playersCount.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =1{1 jogador} other{{n} jogadores}}'**
  String playersCount(int n);

  /// No description provided for @formatLabel.
  ///
  /// In pt, this message translates to:
  /// **'Formato'**
  String get formatLabel;

  /// No description provided for @formatCustom.
  ///
  /// In pt, this message translates to:
  /// **'Livre'**
  String get formatCustom;

  /// No description provided for @startingLife.
  ///
  /// In pt, this message translates to:
  /// **'Vida inicial'**
  String get startingLife;

  /// No description provided for @tapToType.
  ///
  /// In pt, this message translates to:
  /// **'Toque no número para digitar'**
  String get tapToType;

  /// No description provided for @lifeTotal.
  ///
  /// In pt, this message translates to:
  /// **'{n} de vida'**
  String lifeTotal(int n);

  /// No description provided for @whoPlays.
  ///
  /// In pt, this message translates to:
  /// **'Quem joga'**
  String get whoPlays;

  /// No description provided for @playTeams.
  ///
  /// In pt, this message translates to:
  /// **'Jogar em times'**
  String get playTeams;

  /// No description provided for @countersLabel.
  ///
  /// In pt, this message translates to:
  /// **'Contadores na partida'**
  String get countersLabel;

  /// No description provided for @turnTimer.
  ///
  /// In pt, this message translates to:
  /// **'Timer de turno'**
  String get turnTimer;

  /// No description provided for @noTimer.
  ///
  /// In pt, this message translates to:
  /// **'Sem'**
  String get noTimer;

  /// No description provided for @layoutLabel.
  ///
  /// In pt, this message translates to:
  /// **'Disposição'**
  String get layoutLabel;

  /// No description provided for @layoutSides.
  ///
  /// In pt, this message translates to:
  /// **'Colunas laterais'**
  String get layoutSides;

  /// No description provided for @layoutTopFlipped.
  ///
  /// In pt, this message translates to:
  /// **'Fileira de cima virada'**
  String get layoutTopFlipped;

  /// No description provided for @whoStarts.
  ///
  /// In pt, this message translates to:
  /// **'Quem começa'**
  String get whoStarts;

  /// No description provided for @starterRandom.
  ///
  /// In pt, this message translates to:
  /// **'Sortear'**
  String get starterRandom;

  /// No description provided for @starterChoose.
  ///
  /// In pt, this message translates to:
  /// **'Escolher'**
  String get starterChoose;

  /// No description provided for @startMatch.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get startMatch;

  /// No description provided for @playerDefault.
  ///
  /// In pt, this message translates to:
  /// **'Jogador {n}'**
  String playerDefault(int n);

  /// No description provided for @editPlayer.
  ///
  /// In pt, this message translates to:
  /// **'Editar jogador'**
  String get editPlayer;

  /// No description provided for @nameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get nameLabel;

  /// No description provided for @deckLabel.
  ///
  /// In pt, this message translates to:
  /// **'Deck (opcional)'**
  String get deckLabel;

  /// No description provided for @noDeck.
  ///
  /// In pt, this message translates to:
  /// **'Sem deck'**
  String get noDeck;

  /// No description provided for @deckIs.
  ///
  /// In pt, this message translates to:
  /// **'Deck: {deck}'**
  String deckIs(String deck);

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @lastConfig.
  ///
  /// In pt, this message translates to:
  /// **'Última configuração'**
  String get lastConfig;

  /// No description provided for @configureOther.
  ///
  /// In pt, this message translates to:
  /// **'Configurar outra partida'**
  String get configureOther;

  /// No description provided for @continueMatch.
  ///
  /// In pt, this message translates to:
  /// **'Continuar partida'**
  String get continueMatch;

  /// No description provided for @toolsSub.
  ///
  /// In pt, this message translates to:
  /// **'dados, moeda, timer'**
  String get toolsSub;

  /// No description provided for @cards.
  ///
  /// In pt, this message translates to:
  /// **'Cartas'**
  String get cards;

  /// No description provided for @cardsSub.
  ///
  /// In pt, this message translates to:
  /// **'busca e legalidade'**
  String get cardsSub;

  /// No description provided for @manaBase.
  ///
  /// In pt, this message translates to:
  /// **'Base de mana'**
  String get manaBase;

  /// No description provided for @manaSub.
  ///
  /// In pt, this message translates to:
  /// **'terrenos por cor'**
  String get manaSub;

  /// No description provided for @history.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get history;

  /// No description provided for @historySub.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =1{1 partida} other{{n} partidas}}'**
  String historySub(int n);

  /// No description provided for @removeAds.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get removeAds;

  /// No description provided for @wins.
  ///
  /// In pt, this message translates to:
  /// **'venceu'**
  String get wins;

  /// No description provided for @matchOver.
  ///
  /// In pt, this message translates to:
  /// **'Fim da partida'**
  String get matchOver;

  /// No description provided for @duration.
  ///
  /// In pt, this message translates to:
  /// **'duração'**
  String get duration;

  /// No description provided for @rounds.
  ///
  /// In pt, this message translates to:
  /// **'rodadas'**
  String get rounds;

  /// No description provided for @rematch.
  ///
  /// In pt, this message translates to:
  /// **'Revanche'**
  String get rematch;

  /// No description provided for @changeConfig.
  ///
  /// In pt, this message translates to:
  /// **'Mudar configuração'**
  String get changeConfig;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get home;

  /// No description provided for @reasonLife.
  ///
  /// In pt, this message translates to:
  /// **'Vida em zero'**
  String get reasonLife;

  /// No description provided for @reasonPoison.
  ///
  /// In pt, this message translates to:
  /// **'Veneno'**
  String get reasonPoison;

  /// No description provided for @reasonCommander.
  ///
  /// In pt, this message translates to:
  /// **'Dano de comandante'**
  String get reasonCommander;

  /// No description provided for @soloLabel.
  ///
  /// In pt, this message translates to:
  /// **'Solo'**
  String get soloLabel;

  /// No description provided for @turnTitle.
  ///
  /// In pt, this message translates to:
  /// **'TURNO {n}'**
  String turnTitle(int n);

  /// No description provided for @lifePerTurn.
  ///
  /// In pt, this message translates to:
  /// **'Vida por turno'**
  String get lifePerTurn;

  /// No description provided for @lifeStartNow.
  ///
  /// In pt, this message translates to:
  /// **'início {start} · atual {now}'**
  String lifeStartNow(int start, int now);

  /// No description provided for @nextTurn.
  ///
  /// In pt, this message translates to:
  /// **'Próximo turno'**
  String get nextTurn;

  /// No description provided for @typeValue.
  ///
  /// In pt, this message translates to:
  /// **'Digitar'**
  String get typeValue;

  /// No description provided for @cmdAffectsLife.
  ///
  /// In pt, this message translates to:
  /// **'Dano de comandante também tira vida'**
  String get cmdAffectsLife;

  /// No description provided for @countersInMatch.
  ///
  /// In pt, this message translates to:
  /// **'Contadores nesta partida'**
  String get countersInMatch;

  /// No description provided for @resumeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Continuar de onde parou?'**
  String get resumeTitle;

  /// No description provided for @resumeDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar'**
  String get resumeDiscard;

  /// No description provided for @manaWhite.
  ///
  /// In pt, this message translates to:
  /// **'Branco'**
  String get manaWhite;

  /// No description provided for @manaBlue.
  ///
  /// In pt, this message translates to:
  /// **'Azul'**
  String get manaBlue;

  /// No description provided for @manaBlack.
  ///
  /// In pt, this message translates to:
  /// **'Preto'**
  String get manaBlack;

  /// No description provided for @manaRed.
  ///
  /// In pt, this message translates to:
  /// **'Vermelho'**
  String get manaRed;

  /// No description provided for @manaGreen.
  ///
  /// In pt, this message translates to:
  /// **'Verde'**
  String get manaGreen;

  /// No description provided for @manaColorless.
  ///
  /// In pt, this message translates to:
  /// **'Incolor'**
  String get manaColorless;

  /// No description provided for @onb1Title.
  ///
  /// In pt, this message translates to:
  /// **'Contador de vida para a mesa'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In pt, this message translates to:
  /// **'Números enormes, toques grandes e nada no caminho. Feito para jogar em pé, com o celular no meio da mesa.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In pt, this message translates to:
  /// **'De 1 a 4 jogadores'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In pt, this message translates to:
  /// **'Cada painel gira para quem está sentado ali. Commander, Brawl, Two-Headed Giant e mais.'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In pt, this message translates to:
  /// **'Tudo à mão'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In pt, this message translates to:
  /// **'Dados, moeda, timer de turno, dano de comandante, busca de cartas e base de mana.'**
  String get onb3Body;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get getStarted;

  /// No description provided for @sectionMatch.
  ///
  /// In pt, this message translates to:
  /// **'Partida'**
  String get sectionMatch;

  /// No description provided for @keepAwake.
  ///
  /// In pt, this message translates to:
  /// **'Manter a tela ligada'**
  String get keepAwake;

  /// No description provided for @haptics.
  ///
  /// In pt, this message translates to:
  /// **'Vibração'**
  String get haptics;

  /// No description provided for @sounds.
  ///
  /// In pt, this message translates to:
  /// **'Sons'**
  String get sounds;

  /// No description provided for @lockOrientation.
  ///
  /// In pt, this message translates to:
  /// **'Travar em retrato'**
  String get lockOrientation;

  /// No description provided for @defaultTimer.
  ///
  /// In pt, this message translates to:
  /// **'Timer de turno padrão'**
  String get defaultTimer;

  /// No description provided for @sectionLook.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get sectionLook;

  /// No description provided for @colorBlind.
  ///
  /// In pt, this message translates to:
  /// **'Modo daltônico'**
  String get colorBlind;

  /// No description provided for @colorBlindSub.
  ///
  /// In pt, this message translates to:
  /// **'Borda com traço próprio por jogador'**
  String get colorBlindSub;

  /// No description provided for @followsSystem.
  ///
  /// In pt, this message translates to:
  /// **'Movimento e tamanho do texto seguem o sistema.'**
  String get followsSystem;

  /// No description provided for @sectionLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get sectionLanguage;

  /// No description provided for @langSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get langSystem;

  /// No description provided for @sectionPurchases.
  ///
  /// In pt, this message translates to:
  /// **'Compras e privacidade'**
  String get sectionPurchases;

  /// No description provided for @restorePurchases.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar compras'**
  String get restorePurchases;

  /// No description provided for @nothingToRestore.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma compra para restaurar.'**
  String get nothingToRestore;

  /// No description provided for @adsAndTracking.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios e rastreamento'**
  String get adsAndTracking;

  /// No description provided for @consentUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não escolhido'**
  String get consentUnknown;

  /// No description provided for @consentPersonalized.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios personalizados'**
  String get consentPersonalized;

  /// No description provided for @consentNonPersonalized.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios não personalizados'**
  String get consentNonPersonalized;

  /// No description provided for @consentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios no app grátis'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In pt, this message translates to:
  /// **'O app é grátis e mostra anúncios fora da partida. Você escolhe se eles podem ser personalizados. Dá para mudar depois em Ajustes.'**
  String get consentBody;

  /// No description provided for @attPreTitle.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios e privacidade'**
  String get attPreTitle;

  /// No description provided for @attPreBody.
  ///
  /// In pt, this message translates to:
  /// **'Vamos pedir permissão para personalizar os anúncios. Se você negar, o app continua igual, com anúncios menos relevantes.'**
  String get attPreBody;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de privacidade'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In pt, this message translates to:
  /// **'Termos de uso'**
  String get terms;

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @versionN.
  ///
  /// In pt, this message translates to:
  /// **'Versão {v}'**
  String versionN(String v);

  /// No description provided for @legalNotice.
  ///
  /// In pt, this message translates to:
  /// **'App não oficial, não afiliado nem endossado pela Wizards of the Coast. Magic: The Gathering é marca registrada da Wizards of the Coast LLC.'**
  String get legalNotice;

  /// No description provided for @aboutContact.
  ///
  /// In pt, this message translates to:
  /// **'Contato e informações'**
  String get aboutContact;

  /// No description provided for @sendSuggestion.
  ///
  /// In pt, this message translates to:
  /// **'Enviar sugestão'**
  String get sendSuggestion;

  /// No description provided for @rateApp.
  ///
  /// In pt, this message translates to:
  /// **'Avaliar o app'**
  String get rateApp;

  /// No description provided for @licenses.
  ///
  /// In pt, this message translates to:
  /// **'Licenças de código aberto'**
  String get licenses;

  /// No description provided for @credits.
  ///
  /// In pt, this message translates to:
  /// **'Créditos'**
  String get credits;

  /// No description provided for @creditsBody.
  ///
  /// In pt, this message translates to:
  /// **'Dados e imagens de cartas e símbolos de mana: Scryfall. Fontes: Big Shoulders Display e Instrument Sans (SIL OFL). Ícones: Font Awesome.'**
  String get creditsBody;

  /// No description provided for @proName.
  ///
  /// In pt, this message translates to:
  /// **'Lighthouse Pro'**
  String get proName;

  /// No description provided for @proTagline.
  ///
  /// In pt, this message translates to:
  /// **'Sem anúncios e histórico completo. Compra única.'**
  String get proTagline;

  /// No description provided for @proFreeAds.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios fora da partida'**
  String get proFreeAds;

  /// No description provided for @proPaidNoAds.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum anúncio'**
  String get proPaidNoAds;

  /// No description provided for @proFreeHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico das últimas {n}'**
  String proFreeHistory(int n);

  /// No description provided for @proPaidHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico ilimitado'**
  String get proPaidHistory;

  /// No description provided for @buyPro.
  ///
  /// In pt, this message translates to:
  /// **'Comprar por {price}'**
  String buyPro(String price);

  /// No description provided for @oneTimeNote.
  ///
  /// In pt, this message translates to:
  /// **'Compra única. Não é assinatura.'**
  String get oneTimeNote;

  /// No description provided for @proOwned.
  ///
  /// In pt, this message translates to:
  /// **'Você já tem o Pro. Obrigado!'**
  String get proOwned;

  /// No description provided for @storeUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Loja indisponível agora'**
  String get storeUnavailable;

  /// No description provided for @historyNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma partida ainda'**
  String get historyNone;

  /// No description provided for @historyNoneSub.
  ///
  /// In pt, this message translates to:
  /// **'As partidas terminadas aparecem aqui, só neste aparelho.'**
  String get historyNoneSub;

  /// No description provided for @clearHistory.
  ///
  /// In pt, this message translates to:
  /// **'Apagar histórico'**
  String get clearHistory;

  /// No description provided for @clearHistoryAsk.
  ///
  /// In pt, this message translates to:
  /// **'Apagar todas as partidas registradas?'**
  String get clearHistoryAsk;

  /// No description provided for @statMatches.
  ///
  /// In pt, this message translates to:
  /// **'partidas'**
  String get statMatches;

  /// No description provided for @statAvg.
  ///
  /// In pt, this message translates to:
  /// **'duração média'**
  String get statAvg;

  /// No description provided for @statTopFormat.
  ///
  /// In pt, this message translates to:
  /// **'formato mais jogado'**
  String get statTopFormat;

  /// No description provided for @byFormat.
  ///
  /// In pt, this message translates to:
  /// **'Por formato'**
  String get byFormat;

  /// No description provided for @byPlayer.
  ///
  /// In pt, this message translates to:
  /// **'Vitórias por jogador'**
  String get byPlayer;

  /// No description provided for @recentMatches.
  ///
  /// In pt, this message translates to:
  /// **'Últimas partidas'**
  String get recentMatches;

  /// No description provided for @historyFreeLimit.
  ///
  /// In pt, this message translates to:
  /// **'A versão grátis guarda as últimas {n} partidas.'**
  String historyFreeLimit(int n);

  /// No description provided for @manaTotalLands.
  ///
  /// In pt, this message translates to:
  /// **'Total de terrenos'**
  String get manaTotalLands;

  /// No description provided for @manaHint60.
  ///
  /// In pt, this message translates to:
  /// **'60 cartas: 24'**
  String get manaHint60;

  /// No description provided for @manaHintCommander.
  ///
  /// In pt, this message translates to:
  /// **'Commander: 37'**
  String get manaHintCommander;

  /// No description provided for @manaSymbols.
  ///
  /// In pt, this message translates to:
  /// **'Símbolos de mana no deck'**
  String get manaSymbols;

  /// No description provided for @manaResult.
  ///
  /// In pt, this message translates to:
  /// **'Terrenos por cor'**
  String get manaResult;

  /// No description provided for @manaEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Conte os símbolos de mana de todas as cartas do deck e informe acima. O resultado aparece aqui.'**
  String get manaEmpty;

  /// No description provided for @searchCardHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar carta pelo nome'**
  String get searchCardHint;

  /// No description provided for @typeCreature.
  ///
  /// In pt, this message translates to:
  /// **'Criatura'**
  String get typeCreature;

  /// No description provided for @typeInstant.
  ///
  /// In pt, this message translates to:
  /// **'Mágica instantânea'**
  String get typeInstant;

  /// No description provided for @typeSorcery.
  ///
  /// In pt, this message translates to:
  /// **'Feitiço'**
  String get typeSorcery;

  /// No description provided for @typeArtifact.
  ///
  /// In pt, this message translates to:
  /// **'Artefato'**
  String get typeArtifact;

  /// No description provided for @typeEnchantment.
  ///
  /// In pt, this message translates to:
  /// **'Encantamento'**
  String get typeEnchantment;

  /// No description provided for @typeLand.
  ///
  /// In pt, this message translates to:
  /// **'Terreno'**
  String get typeLand;

  /// No description provided for @typePlaneswalker.
  ///
  /// In pt, this message translates to:
  /// **'Planeswalker'**
  String get typePlaneswalker;

  /// No description provided for @manaValueAny.
  ///
  /// In pt, this message translates to:
  /// **'Custo: qualquer'**
  String get manaValueAny;

  /// No description provided for @manaValueMax.
  ///
  /// In pt, this message translates to:
  /// **'Custo ≤ {n}'**
  String manaValueMax(int n);

  /// No description provided for @scryfallCredit.
  ///
  /// In pt, this message translates to:
  /// **'Dados e imagens: Scryfall'**
  String get scryfallCredit;

  /// No description provided for @cardsIdleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Consulte uma carta'**
  String get cardsIdleTitle;

  /// No description provided for @cardsIdleSub.
  ///
  /// In pt, this message translates to:
  /// **'Digite pelo menos 2 letras ou use os filtros de cor, tipo e custo.'**
  String get cardsIdleSub;

  /// No description provided for @networkErrorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão'**
  String get networkErrorTitle;

  /// No description provided for @networkErrorSub.
  ///
  /// In pt, this message translates to:
  /// **'A busca precisa de internet. O resto do app funciona offline.'**
  String get networkErrorSub;

  /// No description provided for @noResults.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma carta encontrada'**
  String get noResults;

  /// No description provided for @noResultsSub.
  ///
  /// In pt, this message translates to:
  /// **'Confira a grafia ou tente uma sugestão.'**
  String get noResultsSub;

  /// No description provided for @resultsCount.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =1{1 carta} other{{n} cartas}}'**
  String resultsCount(int n);

  /// No description provided for @flipCard.
  ///
  /// In pt, this message translates to:
  /// **'Virar a carta'**
  String get flipCard;

  /// No description provided for @legality.
  ///
  /// In pt, this message translates to:
  /// **'Legalidade'**
  String get legality;

  /// No description provided for @legal.
  ///
  /// In pt, this message translates to:
  /// **'legal'**
  String get legal;

  /// No description provided for @notLegal.
  ///
  /// In pt, this message translates to:
  /// **'não legal'**
  String get notLegal;

  /// No description provided for @restricted.
  ///
  /// In pt, this message translates to:
  /// **'restrita'**
  String get restricted;

  /// No description provided for @banned.
  ///
  /// In pt, this message translates to:
  /// **'banida'**
  String get banned;

  /// No description provided for @viewOnScryfall.
  ///
  /// In pt, this message translates to:
  /// **'Ver no Scryfall'**
  String get viewOnScryfall;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
    case 'pt':
      return AppL10nPt();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
