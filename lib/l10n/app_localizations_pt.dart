// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppL10nPt extends AppL10n {
  AppL10nPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Lighthouse Life';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get skip => 'Pular';

  @override
  String get save => 'Salvar';

  @override
  String get clear => 'Limpar';

  @override
  String get undo => 'Desfazer';

  @override
  String get delete => 'Apagar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get turnBadge => 'TURNO';

  @override
  String get yourTurnBadge => 'SEU TURNO';

  @override
  String get eliminatedBadge => 'ELIMINADO';

  @override
  String get lethalBadge => 'LETAL';

  @override
  String get reviveAction => 'Reviver';

  @override
  String semLifeOf(String name, int life) {
    return '$name, $life de vida';
  }

  @override
  String semGainLife(String name) {
    return '$name, ganhar 1 de vida';
  }

  @override
  String semLoseLife(String name) {
    return '$name, perder 1 de vida';
  }

  @override
  String semGainFive(String name) {
    return '$name, ganhar 5 de vida';
  }

  @override
  String semLoseFive(String name) {
    return '$name, perder 5 de vida';
  }

  @override
  String semOpenDrawer(String name) {
    return 'Abrir contadores de $name';
  }

  @override
  String get semPassTurn => 'Passar o turno';

  @override
  String get semEnterLife => 'Digitar vida exata';

  @override
  String get cmdShort => 'CMD';

  @override
  String winnerPrompt(String names) {
    return '$names venceu?';
  }

  @override
  String get seeResult => 'Ver resultado';

  @override
  String get matchMenu => 'Menu da partida';

  @override
  String get pass => 'Passar';

  @override
  String get pauseTimer => 'Pausar timer';

  @override
  String get tools => 'Ferramentas';

  @override
  String roundN(int n) {
    return 'Rodada $n';
  }

  @override
  String roundShort(int n) {
    return 'R$n';
  }

  @override
  String get flipDialog => 'Girar para o outro lado';

  @override
  String get quickSettings => 'Ajustes';

  @override
  String get holdRestart => 'Segure para reiniciar';

  @override
  String get holdEnd => 'Segure para encerrar';

  @override
  String get holdLeave => 'Segure para sair';

  @override
  String get resume => 'Voltar à partida';

  @override
  String get tabCounters => 'Contadores';

  @override
  String get tabCommander => 'Comandante';

  @override
  String get tabHistory => 'Histórico';

  @override
  String get counterPoison => 'Veneno';

  @override
  String get counterEnergy => 'Energia';

  @override
  String get counterExperience => 'Experiência';

  @override
  String get counterRadiation => 'Radiação';

  @override
  String get counterMonarch => 'Monarca';

  @override
  String get counterInitiative => 'Iniciativa';

  @override
  String get counterDayNight => 'Dia/Noite';

  @override
  String get counterRing => 'Anel';

  @override
  String get noCountersEnabled => 'Nenhum contador ligado. Ligue em Configurar partida.';

  @override
  String get day => 'Dia';

  @override
  String get night => 'Noite';

  @override
  String cmdFrom(String name) {
    return 'Dano de $name';
  }

  @override
  String partnerOf(String name) {
    return 'Parceiro de $name';
  }

  @override
  String get addPartner => '+ parceiro';

  @override
  String commanderTax(int n) {
    return 'Taxa de comandante (+$n)';
  }

  @override
  String get historyEmpty => 'Nada registrado ainda.';

  @override
  String get life => 'Vida';

  @override
  String get toolDice => 'Dados';

  @override
  String get toolCoin => 'Moeda';

  @override
  String get toolPlanar => 'Planar';

  @override
  String get toolPicker => 'Sorteio';

  @override
  String get toolTimer => 'Timer';

  @override
  String get diceCount => 'dado(s)';

  @override
  String get roll => 'Rolar';

  @override
  String get heads => 'CARA';

  @override
  String get tails => 'COROA';

  @override
  String get flip => 'Jogar a moeda';

  @override
  String get planarChaos => 'CAOS';

  @override
  String get planarWalk => 'PLANAR';

  @override
  String get planarBlank => 'VAZIO';

  @override
  String get pickPlayer => 'Sortear jogador';

  @override
  String get start => 'Iniciar';

  @override
  String get newMatch => 'Nova partida';

  @override
  String get playersLabel => 'Jogadores';

  @override
  String playersCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n jogadores', one: '1 jogador');
    return '$_temp0';
  }

  @override
  String get formatLabel => 'Formato';

  @override
  String get formatCustom => 'Livre';

  @override
  String get startingLife => 'Vida inicial';

  @override
  String get tapToType => 'Toque no número para digitar';

  @override
  String lifeTotal(int n) {
    return '$n de vida';
  }

  @override
  String get whoPlays => 'Quem joga';

  @override
  String get playTeams => 'Jogar em times';

  @override
  String get countersLabel => 'Contadores na partida';

  @override
  String get turnTimer => 'Timer de turno';

  @override
  String get noTimer => 'Sem';

  @override
  String get layoutLabel => 'Disposição';

  @override
  String get layoutSides => 'Colunas laterais';

  @override
  String get layoutTopFlipped => 'Fileira de cima virada';

  @override
  String get whoStarts => 'Quem começa';

  @override
  String get starterRandom => 'Sortear';

  @override
  String get starterChoose => 'Escolher';

  @override
  String get startMatch => 'Começar';

  @override
  String playerDefault(int n) {
    return 'Jogador $n';
  }

  @override
  String get editPlayer => 'Editar jogador';

  @override
  String get nameLabel => 'Nome';

  @override
  String get deckLabel => 'Deck (opcional)';

  @override
  String get noDeck => 'Sem deck';

  @override
  String deckIs(String deck) {
    return 'Deck: $deck';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get lastConfig => 'Última configuração';

  @override
  String get configureOther => 'Configurar outra partida';

  @override
  String get continueMatch => 'Continuar partida';

  @override
  String get toolsSub => 'dados, moeda, timer';

  @override
  String get cards => 'Cartas';

  @override
  String get cardsSub => 'busca e legalidade';

  @override
  String get manaBase => 'Base de mana';

  @override
  String get manaSub => 'terrenos por cor';

  @override
  String get history => 'Histórico';

  @override
  String historySub(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n partidas', one: '1 partida');
    return '$_temp0';
  }

  @override
  String get removeAds => 'Remover';

  @override
  String get wins => 'venceu';

  @override
  String get matchOver => 'Fim da partida';

  @override
  String get duration => 'duração';

  @override
  String get rounds => 'rodadas';

  @override
  String get rematch => 'Revanche';

  @override
  String get changeConfig => 'Mudar configuração';

  @override
  String get home => 'Início';

  @override
  String get reasonLife => 'Vida em zero';

  @override
  String get reasonPoison => 'Veneno';

  @override
  String get reasonCommander => 'Dano de comandante';

  @override
  String get onb1Title => 'Contador de vida para a mesa';

  @override
  String get onb1Body =>
      'Números enormes, toques grandes e nada no caminho. Feito para jogar em pé, com o celular no meio da mesa.';

  @override
  String get onb2Title => 'De 1 a 4 jogadores';

  @override
  String get onb2Body => 'Cada painel gira para quem está sentado ali. Commander, Brawl, Two-Headed Giant e mais.';

  @override
  String get onb3Title => 'Tudo à mão';

  @override
  String get onb3Body => 'Dados, moeda, timer de turno, dano de comandante, busca de cartas e base de mana.';

  @override
  String get next => 'Próximo';

  @override
  String get getStarted => 'Começar';

  @override
  String get sectionMatch => 'Partida';

  @override
  String get keepAwake => 'Manter a tela ligada';

  @override
  String get haptics => 'Vibração';

  @override
  String get sounds => 'Sons';

  @override
  String get lockOrientation => 'Travar em retrato';

  @override
  String get defaultTimer => 'Timer de turno padrão';

  @override
  String get sectionLook => 'Aparência';

  @override
  String get colorBlind => 'Modo daltônico';

  @override
  String get colorBlindSub => 'Borda com traço próprio por jogador';

  @override
  String get followsSystem => 'Movimento e tamanho do texto seguem o sistema.';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionPurchases => 'Compras e privacidade';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get nothingToRestore => 'Nenhuma compra para restaurar.';

  @override
  String get adsAndTracking => 'Anúncios e rastreamento';

  @override
  String get consentUnknown => 'Ainda não escolhido';

  @override
  String get consentPersonalized => 'Anúncios personalizados';

  @override
  String get consentNonPersonalized => 'Anúncios não personalizados';

  @override
  String get consentTitle => 'Anúncios no app grátis';

  @override
  String get consentBody =>
      'O app é grátis e mostra anúncios fora da partida. Você escolhe se eles podem ser personalizados. Dá para mudar depois em Ajustes.';

  @override
  String get attPreTitle => 'Anúncios e privacidade';

  @override
  String get attPreBody =>
      'Vamos pedir permissão para personalizar os anúncios. Se você negar, o app continua igual, com anúncios menos relevantes.';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get terms => 'Termos de uso';

  @override
  String get about => 'Sobre';

  @override
  String versionN(String v) {
    return 'Versão $v';
  }

  @override
  String get legalNotice =>
      'App não oficial, não afiliado nem endossado pela Wizards of the Coast. Magic: The Gathering é marca registrada da Wizards of the Coast LLC.';

  @override
  String get aboutContact => 'Contato e informações';

  @override
  String get sendSuggestion => 'Enviar sugestão';

  @override
  String get rateApp => 'Avaliar o app';

  @override
  String get licenses => 'Licenças de código aberto';

  @override
  String get credits => 'Créditos';

  @override
  String get creditsBody =>
      'Dados e imagens de cartas e símbolos de mana: Scryfall. Fontes: Big Shoulders Display e Instrument Sans (SIL OFL). Ícones: Font Awesome.';

  @override
  String get proName => 'Lighthouse Pro';

  @override
  String get proTagline => 'Sem anúncios e histórico completo. Compra única.';

  @override
  String get proFreeAds => 'Anúncios fora da partida';

  @override
  String get proPaidNoAds => 'Nenhum anúncio';

  @override
  String proFreeHistory(int n) {
    return 'Histórico das últimas $n';
  }

  @override
  String get proPaidHistory => 'Histórico ilimitado';

  @override
  String buyPro(String price) {
    return 'Comprar por $price';
  }

  @override
  String get oneTimeNote => 'Compra única. Não é assinatura.';

  @override
  String get proOwned => 'Você já tem o Pro. Obrigado!';

  @override
  String get storeUnavailable => 'Loja indisponível agora';

  @override
  String get historyNone => 'Nenhuma partida ainda';

  @override
  String get historyNoneSub => 'As partidas terminadas aparecem aqui, só neste aparelho.';

  @override
  String get clearHistory => 'Apagar histórico';

  @override
  String get clearHistoryAsk => 'Apagar todas as partidas registradas?';

  @override
  String get statMatches => 'partidas';

  @override
  String get statAvg => 'duração média';

  @override
  String get statTopFormat => 'formato mais jogado';

  @override
  String get byFormat => 'Por formato';

  @override
  String get byPlayer => 'Vitórias por jogador';

  @override
  String get recentMatches => 'Últimas partidas';

  @override
  String historyFreeLimit(int n) {
    return 'A versão grátis guarda as últimas $n partidas.';
  }

  @override
  String get manaTotalLands => 'Total de terrenos';

  @override
  String get manaHint60 => '60 cartas: 24';

  @override
  String get manaHintCommander => 'Commander: 37';

  @override
  String get manaSymbols => 'Símbolos de mana no deck';

  @override
  String get manaResult => 'Terrenos por cor';

  @override
  String get manaEmpty =>
      'Conte os símbolos de mana de todas as cartas do deck e informe acima. O resultado aparece aqui.';

  @override
  String get searchCardHint => 'Buscar carta pelo nome';

  @override
  String get typeCreature => 'Criatura';

  @override
  String get typeInstant => 'Mágica instantânea';

  @override
  String get typeSorcery => 'Feitiço';

  @override
  String get typeArtifact => 'Artefato';

  @override
  String get typeEnchantment => 'Encantamento';

  @override
  String get typeLand => 'Terreno';

  @override
  String get typePlaneswalker => 'Planeswalker';

  @override
  String get manaValueAny => 'Custo: qualquer';

  @override
  String manaValueMax(int n) {
    return 'Custo ≤ $n';
  }

  @override
  String get scryfallCredit => 'Dados e imagens: Scryfall';

  @override
  String get cardsIdleTitle => 'Consulte uma carta';

  @override
  String get cardsIdleSub => 'Digite pelo menos 2 letras ou use os filtros de cor, tipo e custo.';

  @override
  String get networkErrorTitle => 'Sem conexão';

  @override
  String get networkErrorSub => 'A busca precisa de internet. O resto do app funciona offline.';

  @override
  String get noResults => 'Nenhuma carta encontrada';

  @override
  String get noResultsSub => 'Confira a grafia ou tente uma sugestão.';

  @override
  String resultsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n cartas', one: '1 carta');
    return '$_temp0';
  }

  @override
  String get flipCard => 'Virar a carta';

  @override
  String get legality => 'Legalidade';

  @override
  String get legal => 'legal';

  @override
  String get notLegal => 'não legal';

  @override
  String get restricted => 'restrita';

  @override
  String get banned => 'banida';

  @override
  String get viewOnScryfall => 'Ver no Scryfall';
}
