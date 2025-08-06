// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Alcoolize';

  @override
  String get alcoolizeSe => 'ALCOOLÍZATE';

  @override
  String get settings => 'Configuraciones';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Português';

  @override
  String get spanish => 'Español';

  @override
  String get players => 'Jugadores';

  @override
  String get playerCount => 'Número de Jugadores';

  @override
  String playerName(Object number) {
    return 'Jugador $number';
  }

  @override
  String get start => 'EMPEZAR';

  @override
  String get gameSettings => 'Configuraciones de Juegos';

  @override
  String get adjustProbabilities => 'Ajustar Probabilidades';

  @override
  String get editQuestions => 'Editar Preguntas/Palabras';

  @override
  String get canRepeat => 'Puede Repetir Juegos';

  @override
  String get mysteryVerb => 'VERBO MISTERIOSO';

  @override
  String get neverHaveIEver => 'YO NUNCA';

  @override
  String get roulette => 'RULETA';

  @override
  String get paranoia => 'PARANOIA';

  @override
  String get mostLikelyTo => 'MÁS PROBABLE';

  @override
  String get forbiddenWord => 'PALABRA PROHIBIDA';

  @override
  String get medusa => 'MEDUSA';

  @override
  String get cards => 'CARTAS';

  @override
  String get truthOrDare => 'VERDAD O RETO';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'SIGUIENTE';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get playersQuestion => '¿Cuántos Jugadores?';

  @override
  String victimPlaceholder(Object number) {
    return '$number° víctima';
  }

  @override
  String get pleaseEnterName => 'Por favor, ingresa un nombre';

  @override
  String get startGame => 'Comenzar el Juego';

  @override
  String get activateDeactivateGames => 'Activar/Desactivar juegos';

  @override
  String get noGamesAvailable => 'No hay juegos disponibles.';

  @override
  String get repeatContinuouslyOn => 'Repetir Continuamente ON';

  @override
  String get repeatContinuouslyOff => 'Repetir Continuamente OFF';

  @override
  String get gameInformation => 'Información de los Juegos';

  @override
  String get close => 'Cerrar';

  @override
  String get configureProbabilities => 'Configurar Probabilidades';

  @override
  String totalWeight(Object weight) {
    return 'Peso Total: $weight%';
  }

  @override
  String get mustBe100Percent => 'Debe ser 100%';

  @override
  String get weightExceedError => 'El peso total no puede exceder el 100%';

  @override
  String saveWeightsError(Object error) {
    return 'Error al guardar pesos: $error';
  }

  @override
  String get probabilitiesReset =>
      '¡Probabilidades restablecidas a la configuración predeterminada!';

  @override
  String editGameName(Object gameName) {
    return 'Editar $gameName';
  }

  @override
  String totalItems(Object count, Object itemLabel) {
    return 'Total: $count ${itemLabel}s';
  }

  @override
  String typeItemHere(Object itemLabel) {
    return 'Escribe la $itemLabel aquí';
  }

  @override
  String get typeQuestionHere => 'Escribe la pregunta aquí';

  @override
  String get personal => 'Personal';

  @override
  String get general => 'General';

  @override
  String get restoreDefault => 'Restaurar predeterminado';

  @override
  String get restoreConfirmation =>
      '¿Estás seguro de que quieres restaurar todas las preguntas al predeterminado original? Esta acción no se puede deshacer.';

  @override
  String get restore => 'Restaurar';

  @override
  String get unsavedChanges => 'Cambios no guardados';

  @override
  String get unsavedChangesMessage =>
      'Tienes cambios no guardados. ¿Quieres salir sin guardar?';

  @override
  String get exitWithoutSaving => 'Salir sin guardar';

  @override
  String get changesSavedSuccess => '¡Cambios guardados exitosamente!';

  @override
  String get saveChangesError => 'Error al guardar cambios.';

  @override
  String get questionsRestoredDefault =>
      'Preguntas restauradas al predeterminado original.';

  @override
  String get restoreQuestionsError => 'Error al restaurar preguntas.';

  @override
  String get editWords => 'Editar palabras';

  @override
  String get editQuestionsSubtitle => 'Editar preguntas';

  @override
  String currentPlayer(Object player) {
    return 'Jugador actual: $player';
  }

  @override
  String get loading => 'Cargando...';

  @override
  String get cardsGameInfo =>
      'En este juego, se revelará una carta con un desafío. Si el desafío es individual, el jugador actual debe completarlo.';

  @override
  String newForbiddenWord(Object word) {
    return 'Nueva palabra prohibida: $word';
  }

  @override
  String get forbiddenWordGameInfo =>
      'Para jugar Palabra Prohibida, sortea una palabra. Quien diga la palabra prohibida durante la ronda debe beber un trago. Las palabras se eliminan de la lista hasta el final del juego.';

  @override
  String get medusaGameInfo =>
      'En el juego Medusa, todos los jugadores deben bajar la cabeza y, a la señal, levantarla. Si haces contacto visual con otro jugador, ambos deben beber un trago.';

  @override
  String get medusaGameText => '¡Baja la cabeza y prepárate!';

  @override
  String get neverHaveIEverGameInfo =>
      'Para jugar Yo Nunca, el anfitrión debe leer la declaración. Quien haya hecho la acción debe beber un trago.';

  @override
  String get revealQuestion => 'Revelar Pregunta';

  @override
  String get paranoiaGameInfo =>
      'Para jugar Paranoia, el jugador debe leer la pregunta revelada y señalar a quien cree que es la respuesta. Si la persona señalada quiere saber la pregunta, debe beber dos tragos. Si la persona se niega a responder, debe beber tres tragos.';

  @override
  String get spinRoulette => 'Girar la ruleta';

  @override
  String get drinkOneShot => 'Bebe un trago';

  @override
  String get drinkWithFriend => 'Bebe con un amigo';

  @override
  String get passTurn => 'Pasa el turno';

  @override
  String get drinkAndSpinAgain => 'Bebe y gira de nuevo';

  @override
  String get drinkDouble => 'Bebe doble';

  @override
  String get chooseSomeoneToDrink => 'Elige a alguien para beber';

  @override
  String get rouletteGameInfo =>
      'Gira la ruleta y ve lo que el destino te depara.';

  @override
  String get revealVerb => 'Revelar Verbo';

  @override
  String get mysteryVerbGameInfo =>
      'El grupo debe hacer preguntas al jugador sobre el verbo usando \"verbo misterioso\" para reemplazarlo. Ejemplo: \"¿Es fácil hacer el verbo misterioso?\", \"¿Dónde se hace el verbo misterioso con frecuencia?\". Revela el verbo oculto al final. El grupo tiene 3 oportunidades para adivinar el verbo, cada uno que se equivoque bebe un trago, si alguien acierta, el jugador actual debe beber 1 trago.';

  @override
  String get mostLikelyTitle => 'MÁS PROBABLE';

  @override
  String get mostLikelyGameInfo =>
      'Para jugar Más Probable, el anfitrión debe leer la pregunta y todos deben señalar a quien creen que es la respuesta correcta, la persona más señalada bebe un trago, en caso de empate, ambos beben.';

  @override
  String get systemTheme => 'Tema del Sistema';

  @override
  String get lightTheme => 'Tema Claro';

  @override
  String get darkTheme => 'Tema Oscuro';

  @override
  String get word => 'palabra';

  @override
  String get question => 'pregunta';

  @override
  String get restoreDefaultTooltip => 'Restaurar predeterminado';

  @override
  String languageChanging(Object language) {
    return 'Cambiando a $language...';
  }

  @override
  String get restartRequired =>
      'Por favor reinicia la aplicación para aplicar los cambios de idioma';

  @override
  String get truth => 'VERDAD';

  @override
  String get dare => 'RETO';

  @override
  String get nextPlayer => 'SIGUIENTE JUGADOR';

  @override
  String get truthOrDareChoosePrompt => 'Elige tu desafío:';

  @override
  String get truthOrDareGameInfo =>
      'En Verdad o Reto, el jugador actual debe elegir entre responder una pregunta personal o realizar un desafío divertido. Si la persona se niega a responder la verdad o completar el reto, debe beber un trago.';
}
