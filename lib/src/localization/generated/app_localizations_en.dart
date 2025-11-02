// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Alcoolize';

  @override
  String get alcoolizeSe => 'GET ALCOOLIZED';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Português';

  @override
  String get spanish => 'Español';

  @override
  String get players => 'Players';

  @override
  String get playerCount => 'Number of Players';

  @override
  String playerName(Object number) {
    return 'Player $number';
  }

  @override
  String get start => 'START';

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get adjustProbabilities => 'Adjust Probabilities';

  @override
  String get editQuestions => 'Edit Questions/Words';

  @override
  String get canRepeat => 'Can Repeat Games';

  @override
  String get neverHaveIEver => 'NEVER HAVE I EVER';

  @override
  String get roulette => 'ROULETTE';

  @override
  String get paranoia => 'PARANOIA';

  @override
  String get mostLikelyTo => 'MOST LIKELY TO';

  @override
  String get forbiddenWord => 'FORBIDDEN WORD';

  @override
  String get medusa => 'MEDUSA';

  @override
  String get cards => 'CARDS';

  @override
  String get truthOrDare => 'TRUTH OR DARE';

  @override
  String get back => 'Back';

  @override
  String get next => 'NEXT';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get playersQuestion => 'How many players?';

  @override
  String victimPlaceholder(Object number) {
    return '$number° victim';
  }

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get startGame => 'Start Game';

  @override
  String get activateDeactivateGames => 'Enable/Disable Games';

  @override
  String get noGamesAvailable => 'No games available.';

  @override
  String get repeatContinuouslyOn => 'Repeat Continuously ON';

  @override
  String get repeatContinuouslyOff => 'Repeat Continuously OFF';

  @override
  String get gameInformation => 'Game Information';

  @override
  String get close => 'Close';

  @override
  String get configureProbabilities => 'Configure Probabilities';

  @override
  String totalWeight(Object weight) {
    return 'Total Weight: $weight%';
  }

  @override
  String get mustBe100Percent => 'Must be 100%';

  @override
  String get weightExceedError => 'Total weight cannot exceed 100%';

  @override
  String saveWeightsError(Object error) {
    return 'Error saving weights: $error';
  }

  @override
  String get probabilitiesReset => 'Probabilities reset to default settings!';

  @override
  String editGameName(Object gameName) {
    return 'Edit $gameName';
  }

  @override
  String get totalItems => 'Total Items';

  @override
  String typeItemHere(Object itemLabel) {
    return 'Type the $itemLabel here';
  }

  @override
  String get typeQuestionHere => 'Type the question here';

  @override
  String get personal => 'Personal';

  @override
  String get general => 'General';

  @override
  String get restoreDefault => 'Restore Default';

  @override
  String get restoreConfirmation =>
      'Are you sure you want to restore all questions to the original default? This action cannot be undone.';

  @override
  String get restore => 'Restore';

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Do you want to exit without saving?';

  @override
  String get exitWithoutSaving => 'Exit Without Saving';

  @override
  String get changesSavedSuccess => 'Changes saved successfully!';

  @override
  String get saveChangesError => 'Error saving changes.';

  @override
  String get questionsRestoredDefault =>
      'Questions restored to original default.';

  @override
  String get restoreQuestionsError => 'Error restoring questions.';

  @override
  String get editWords => 'Edit words';

  @override
  String get editQuestionsSubtitle => 'Edit questions';

  @override
  String currentPlayer(Object player) {
    return 'Current player: $player';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get cardsGameInfo =>
      'In this game, a card with a challenge will be revealed. If the challenge is individual, the current player must complete it.';

  @override
  String newForbiddenWord(Object word) {
    return 'New forbidden word: $word';
  }

  @override
  String get forbiddenWordGameInfo =>
      'To play Forbidden Word, draw a word. Whoever says the forbidden word during the round must drink a shot. Words are removed from the list until the end of the game.';

  @override
  String get medusaGameInfo =>
      'In the Medusa game, all players must lower their heads and, on signal, raise them. If you make eye contact with another player, both must drink a shot.';

  @override
  String get medusaGameText => 'Lower your head and get ready!';

  @override
  String get neverHaveIEverGameInfo =>
      'To play Never Have I Ever, the host must read the statement. Whoever has done the action must drink a shot.';

  @override
  String get revealQuestion => 'Reveal Question';

  @override
  String get paranoiaGameInfo =>
      'To play Paranoia, the player must read the revealed question and point to who they think is the answer. If the person pointed at wants to know the question, they must drink two shots. If the person refuses to answer, they must drink three shots.';

  @override
  String get spinRoulette => 'Spin the roulette';

  @override
  String get drinkOneShot => 'Drink one shot';

  @override
  String get drinkWithFriend => 'Drink with a friend';

  @override
  String get passTurn => 'Pass the turn';

  @override
  String get drinkAndSpinAgain => 'Drink and spin again';

  @override
  String get drinkDouble => 'Drink double';

  @override
  String get chooseSomeoneToDrink => 'Choose someone to drink';

  @override
  String get rouletteGameInfo =>
      'Spin the roulette and see what fate awaits you.';

  @override
  String get revealVerb => 'Reveal Verb';

  @override
  String get mostLikelyTitle => 'MOST LIKELY';

  @override
  String get mostLikelyGameInfo =>
      'To play Most Likely, the host must read the question and everyone must point to who they think is the right answer, the most pointed person drinks a shot, in case of a tie, both drink.';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get word => 'word';

  @override
  String get question => 'question';

  @override
  String get restoreDefaultTooltip => 'Restore Default';

  @override
  String languageChanging(Object language) {
    return 'Switching to $language...';
  }

  @override
  String get restartRequired =>
      'Please restart the app to apply language changes';

  @override
  String get truth => 'TRUTH';

  @override
  String get dare => 'DARE';

  @override
  String get nextPlayer => 'NEXT PLAYER';

  @override
  String get truthOrDareChoosePrompt => 'Choose your challenge:';

  @override
  String get truthOrDareGameInfo =>
      'In Truth or Dare, the current player must choose between answering a personal truth question or performing a fun dare challenge. If the person refuses to answer the truth or complete the dare, they must drink a shot.';

  @override
  String get drunkTrivia => 'DRUNK TRIVIA';

  @override
  String get revealAnswer => 'REVEAL ANSWER';

  @override
  String get hideAnswer => 'HIDE ANSWER';

  @override
  String get correctAnswer => 'Correct Answer';

  @override
  String get drunkTriviaGameInfo =>
      'In Drunk Trivia, the host reads a question and four options (A, B, C, D). Players must answer, then the host reveals the correct answer. Whoever gets it wrong must drink a shot.';

  @override
  String get scratchCard => 'SCRATCH CARD';

  @override
  String get scratchCardChoosePrompt =>
      'Choose a card and scratch it to reveal your fate!';

  @override
  String get scratchCardReset => 'NEW CARDS';

  @override
  String get scratchCardGameInfo =>
      'In Scratch Card, the current player chooses one of 4 cards and scratches it by sliding their finger to reveal a challenge. Only the first card scratched counts, but you can scratch others for fun.';

  @override
  String get managePacks => 'Manage Content Packs';

  @override
  String get enabled => 'Enabled';

  @override
  String get total => 'Total';

  @override
  String get noPacksAvailable => 'No packs available';

  @override
  String get items => 'items';

  @override
  String get version => 'Version';

  @override
  String get spiceLevel => 'Spice Level';

  @override
  String get gamesIncluded => 'Games Included:';

  @override
  String get contentPacks => 'Content Packs';

  @override
  String get contentPacksDescription =>
      'Content packs allow you to customize your experience with different sets of questions and challenges.';

  @override
  String get spiceLevels => 'Spice Levels:';

  @override
  String get spiceLevelsDescription =>
      '• Mild: Family-friendly content\n• Medium: Party atmosphere\n• Spicy: Bolder content\n• Hot: Adults only';

  @override
  String get enablePacksInfo =>
      'Enable the packs you want to use in your games.';

  @override
  String get understood => 'Got it';

  @override
  String get retry => 'Retry';

  @override
  String failedToLoadPacks(Object error) {
    return 'Failed to load packs: $error';
  }

  @override
  String errorLoadingData(Object error) {
    return 'Error loading data: $error';
  }
}
