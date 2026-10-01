// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Lighthouse Life';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Volver';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get skip => 'Omitir';

  @override
  String get save => 'Guardar';

  @override
  String get clear => 'Limpiar';

  @override
  String get undo => 'Deshacer';

  @override
  String get delete => 'Borrar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get retry => 'Reintentar';

  @override
  String get turnBadge => 'TURNO';

  @override
  String get yourTurnBadge => 'TU TURNO';

  @override
  String get eliminatedBadge => 'ELIMINADO';

  @override
  String get lethalBadge => 'LETAL';

  @override
  String get reviveAction => 'Revivir';

  @override
  String semLifeOf(String name, int life) {
    return '$name, $life de vida';
  }

  @override
  String semGainLife(String name) {
    return '$name, ganar 1 de vida';
  }

  @override
  String semLoseLife(String name) {
    return '$name, perder 1 de vida';
  }

  @override
  String semGainFive(String name) {
    return '$name, ganar 5 de vida';
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
  String get semPassTurn => 'Pasar el turno';

  @override
  String get semEnterLife => 'Escribir vida exacta';

  @override
  String get cmdShort => 'CMD';

  @override
  String winnerPrompt(String names) {
    return '¿Ganó $names?';
  }

  @override
  String get seeResult => 'Ver resultado';

  @override
  String get matchMenu => 'Menú de la partida';

  @override
  String get pass => 'Pasar';

  @override
  String get pauseTimer => 'Pausar temporizador';

  @override
  String get tools => 'Herramientas';

  @override
  String roundN(int n) {
    return 'Ronda $n';
  }

  @override
  String roundShort(int n) {
    return 'R$n';
  }

  @override
  String get flipDialog => 'Girar al otro lado';

  @override
  String get quickSettings => 'Ajustes';

  @override
  String get holdRestart => 'Mantén para reiniciar';

  @override
  String get holdEnd => 'Mantén para terminar';

  @override
  String get holdLeave => 'Mantén para salir';

  @override
  String get resume => 'Volver a la partida';

  @override
  String get tabCounters => 'Contadores';

  @override
  String get tabCommander => 'Comandante';

  @override
  String get tabHistory => 'Historial';

  @override
  String get counterPoison => 'Veneno';

  @override
  String get counterEnergy => 'Energía';

  @override
  String get counterExperience => 'Experiencia';

  @override
  String get counterRadiation => 'Radiación';

  @override
  String get counterMonarch => 'Monarca';

  @override
  String get counterInitiative => 'Iniciativa';

  @override
  String get counterDayNight => 'Día/Noche';

  @override
  String get counterRing => 'Anillo';

  @override
  String get noCountersEnabled => 'Ningún contador activado. Actívalos en Configurar partida.';

  @override
  String get day => 'Día';

  @override
  String get night => 'Noche';

  @override
  String cmdFrom(String name) {
    return 'Daño de $name';
  }

  @override
  String partnerOf(String name) {
    return 'Compañero de $name';
  }

  @override
  String get addPartner => '+ compañero';

  @override
  String commanderTax(int n) {
    return 'Impuesto de comandante (+$n)';
  }

  @override
  String get historyEmpty => 'Nada registrado todavía.';

  @override
  String get life => 'Vida';

  @override
  String get toolDice => 'Dados';

  @override
  String get toolCoin => 'Moneda';

  @override
  String get toolPlanar => 'Planar';

  @override
  String get toolPicker => 'Sorteo';

  @override
  String get toolTimer => 'Temporizador';

  @override
  String get diceCount => 'dado(s)';

  @override
  String get roll => 'Lanzar';

  @override
  String get heads => 'CARA';

  @override
  String get tails => 'CRUZ';

  @override
  String get flip => 'Lanzar la moneda';

  @override
  String get planarChaos => 'CAOS';

  @override
  String get planarWalk => 'PLANAR';

  @override
  String get planarBlank => 'VACÍO';

  @override
  String get pickPlayer => 'Sortear jugador';

  @override
  String get start => 'Iniciar';

  @override
  String get newMatch => 'Nueva partida';

  @override
  String get playersLabel => 'Jugadores';

  @override
  String playersCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n jugadores', one: '1 jugador');
    return '$_temp0';
  }

  @override
  String get formatLabel => 'Formato';

  @override
  String get formatCustom => 'Libre';

  @override
  String get startingLife => 'Vida inicial';

  @override
  String get tapToType => 'Toca el número para escribir';

  @override
  String lifeTotal(int n) {
    return '$n de vida';
  }

  @override
  String get whoPlays => 'Quién juega';

  @override
  String get playTeams => 'Jugar en equipos';

  @override
  String get countersLabel => 'Contadores en la partida';

  @override
  String get turnTimer => 'Temporizador de turno';

  @override
  String get noTimer => 'Sin';

  @override
  String get layoutLabel => 'Disposición';

  @override
  String get layoutSides => 'Columnas laterales';

  @override
  String get layoutTopFlipped => 'Fila superior girada';

  @override
  String get whoStarts => 'Quién empieza';

  @override
  String get starterRandom => 'Sortear';

  @override
  String get starterChoose => 'Elegir';

  @override
  String get startMatch => 'Empezar';

  @override
  String playerDefault(int n) {
    return 'Jugador $n';
  }

  @override
  String get editPlayer => 'Editar jugador';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get deckLabel => 'Mazo (opcional)';

  @override
  String get noDeck => 'Sin mazo';

  @override
  String deckIs(String deck) {
    return 'Mazo: $deck';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get lastConfig => 'Última configuración';

  @override
  String get configureOther => 'Configurar otra partida';

  @override
  String get continueMatch => 'Continuar partida';

  @override
  String get toolsSub => 'dados, moneda, temporizador';

  @override
  String get cards => 'Cartas';

  @override
  String get cardsSub => 'búsqueda y legalidad';

  @override
  String get manaBase => 'Base de maná';

  @override
  String get manaSub => 'tierras por color';

  @override
  String get history => 'Historial';

  @override
  String historySub(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n partidas', one: '1 partida');
    return '$_temp0';
  }

  @override
  String get removeAds => 'Quitar';

  @override
  String get wins => 'ganó';

  @override
  String get matchOver => 'Fin de la partida';

  @override
  String get duration => 'duración';

  @override
  String get rounds => 'rondas';

  @override
  String get rematch => 'Revancha';

  @override
  String get changeConfig => 'Cambiar configuración';

  @override
  String get home => 'Inicio';

  @override
  String get reasonLife => 'Sin vida';

  @override
  String get reasonPoison => 'Veneno';

  @override
  String get reasonCommander => 'Daño de comandante';

  @override
  String get onb1Title => 'Contador de vida para la mesa';

  @override
  String get onb1Body =>
      'Números enormes, toques grandes y nada en el camino. Hecho para la mesa, con el móvil en el centro.';

  @override
  String get onb2Title => 'De 1 a 4 jugadores';

  @override
  String get onb2Body => 'Cada panel gira hacia quien se sienta allí. Commander, Brawl, Two-Headed Giant y más.';

  @override
  String get onb3Title => 'Todo a mano';

  @override
  String get onb3Body => 'Dados, moneda, temporizador, daño de comandante, búsqueda de cartas y base de maná.';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Empezar';

  @override
  String get sectionMatch => 'Partida';

  @override
  String get keepAwake => 'Mantener la pantalla encendida';

  @override
  String get haptics => 'Vibración';

  @override
  String get sounds => 'Sonidos';

  @override
  String get lockOrientation => 'Bloquear en vertical';

  @override
  String get defaultTimer => 'Temporizador de turno predeterminado';

  @override
  String get sectionLook => 'Apariencia';

  @override
  String get colorBlind => 'Modo daltónico';

  @override
  String get colorBlindSub => 'Borde con trazo propio por jugador';

  @override
  String get followsSystem => 'El movimiento y el tamaño del texto siguen al sistema.';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionPurchases => 'Compras y privacidad';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get nothingToRestore => 'No hay compras para restaurar.';

  @override
  String get adsAndTracking => 'Anuncios y seguimiento';

  @override
  String get consentUnknown => 'Aún sin elegir';

  @override
  String get consentPersonalized => 'Anuncios personalizados';

  @override
  String get consentNonPersonalized => 'Anuncios no personalizados';

  @override
  String get consentTitle => 'Anuncios en la app gratuita';

  @override
  String get consentBody =>
      'La app es gratuita y muestra anuncios fuera de la partida. Tú eliges si pueden ser personalizados. Puedes cambiarlo luego en Ajustes.';

  @override
  String get attPreTitle => 'Anuncios y privacidad';

  @override
  String get attPreBody =>
      'Pediremos permiso para personalizar los anuncios. Si lo niegas, la app funciona igual, con anuncios menos relevantes.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get terms => 'Términos de uso';

  @override
  String get about => 'Acerca de';

  @override
  String versionN(String v) {
    return 'Versión $v';
  }

  @override
  String get legalNotice =>
      'App no oficial, no afiliada ni respaldada por Wizards of the Coast. Magic: The Gathering es una marca registrada de Wizards of the Coast LLC.';

  @override
  String get aboutContact => 'Contacto e información';

  @override
  String get sendSuggestion => 'Enviar sugerencia';

  @override
  String get rateApp => 'Calificar la app';

  @override
  String get licenses => 'Licencias de código abierto';

  @override
  String get credits => 'Créditos';

  @override
  String get creditsBody =>
      'Datos e imágenes de cartas: Scryfall. Fuentes: Big Shoulders Display e Instrument Sans (SIL OFL). Iconos: Font Awesome.';

  @override
  String get proName => 'Lighthouse Pro';

  @override
  String get proTagline => 'Sin anuncios e historial completo. Compra única.';

  @override
  String get proFreeAds => 'Anuncios fuera de la partida';

  @override
  String get proPaidNoAds => 'Ningún anuncio';

  @override
  String proFreeHistory(int n) {
    return 'Historial de las últimas $n';
  }

  @override
  String get proPaidHistory => 'Historial ilimitado';

  @override
  String buyPro(String price) {
    return 'Comprar por $price';
  }

  @override
  String get oneTimeNote => 'Compra única. No es una suscripción.';

  @override
  String get proOwned => 'Ya tienes Pro. ¡Gracias!';

  @override
  String get storeUnavailable => 'Tienda no disponible ahora';

  @override
  String get historyNone => 'Aún no hay partidas';

  @override
  String get historyNoneSub => 'Las partidas terminadas aparecen aquí, solo en este dispositivo.';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get clearHistoryAsk => '¿Borrar todas las partidas registradas?';

  @override
  String get statMatches => 'partidas';

  @override
  String get statAvg => 'duración media';

  @override
  String get statTopFormat => 'formato más jugado';

  @override
  String get byFormat => 'Por formato';

  @override
  String get byPlayer => 'Victorias por jugador';

  @override
  String get recentMatches => 'Últimas partidas';

  @override
  String historyFreeLimit(int n) {
    return 'La versión gratuita guarda las últimas $n partidas.';
  }

  @override
  String get manaTotalLands => 'Total de tierras';

  @override
  String get manaHint60 => '60 cartas: 24';

  @override
  String get manaHintCommander => 'Commander: 37';

  @override
  String get manaSymbols => 'Símbolos de maná en el mazo';

  @override
  String get manaResult => 'Tierras por color';

  @override
  String get manaEmpty =>
      'Cuenta los símbolos de maná de todo el mazo e introdúcelos arriba. El resultado aparece aquí.';

  @override
  String get searchCardHint => 'Buscar carta por nombre';

  @override
  String get typeCreature => 'Criatura';

  @override
  String get typeInstant => 'Instantáneo';

  @override
  String get typeSorcery => 'Conjuro';

  @override
  String get typeArtifact => 'Artefacto';

  @override
  String get typeEnchantment => 'Encantamiento';

  @override
  String get typeLand => 'Tierra';

  @override
  String get typePlaneswalker => 'Planeswalker';

  @override
  String get manaValueAny => 'Coste: cualquiera';

  @override
  String manaValueMax(int n) {
    return 'Coste ≤ $n';
  }

  @override
  String get scryfallCredit => 'Datos e imágenes: Scryfall';

  @override
  String get cardsIdleTitle => 'Consulta una carta';

  @override
  String get cardsIdleSub => 'Escribe al menos 2 letras o usa los filtros de color, tipo y coste.';

  @override
  String get networkErrorTitle => 'Sin conexión';

  @override
  String get networkErrorSub => 'La búsqueda necesita internet. El resto de la app funciona sin conexión.';

  @override
  String get noResults => 'No se encontraron cartas';

  @override
  String get noResultsSub => 'Revisa la ortografía o prueba una sugerencia.';

  @override
  String resultsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n cartas', one: '1 carta');
    return '$_temp0';
  }

  @override
  String get flipCard => 'Girar la carta';

  @override
  String get legality => 'Legalidad';

  @override
  String get legal => 'legal';

  @override
  String get notLegal => 'no legal';

  @override
  String get restricted => 'restringida';

  @override
  String get banned => 'prohibida';

  @override
  String get viewOnScryfall => 'Ver en Scryfall';
}
