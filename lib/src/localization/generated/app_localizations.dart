import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Alcoolize'**
  String get appTitle;

  /// No description provided for @alcoolizeSe.
  ///
  /// In en, this message translates to:
  /// **'GET ALCOOLIZED'**
  String get alcoolizeSe;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @playerCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Players'**
  String get playerCount;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player {number}'**
  String playerName(Object number);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @gameSettings.
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get gameSettings;

  /// No description provided for @adjustProbabilities.
  ///
  /// In en, this message translates to:
  /// **'Adjust Probabilities'**
  String get adjustProbabilities;

  /// No description provided for @editQuestions.
  ///
  /// In en, this message translates to:
  /// **'Edit Questions/Words'**
  String get editQuestions;

  /// No description provided for @canRepeat.
  ///
  /// In en, this message translates to:
  /// **'Can Repeat Games'**
  String get canRepeat;

  /// No description provided for @neverHaveIEver.
  ///
  /// In en, this message translates to:
  /// **'NEVER HAVE I EVER'**
  String get neverHaveIEver;

  /// No description provided for @roulette.
  ///
  /// In en, this message translates to:
  /// **'ROULETTE'**
  String get roulette;

  /// No description provided for @paranoia.
  ///
  /// In en, this message translates to:
  /// **'PARANOIA'**
  String get paranoia;

  /// No description provided for @mostLikelyTo.
  ///
  /// In en, this message translates to:
  /// **'MOST LIKELY TO'**
  String get mostLikelyTo;

  /// No description provided for @forbiddenWord.
  ///
  /// In en, this message translates to:
  /// **'FORBIDDEN WORD'**
  String get forbiddenWord;

  /// No description provided for @medusa.
  ///
  /// In en, this message translates to:
  /// **'MEDUSA'**
  String get medusa;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'CARDS'**
  String get cards;

  /// No description provided for @truthOrDare.
  ///
  /// In en, this message translates to:
  /// **'TRUTH OR DARE'**
  String get truthOrDare;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @playersQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many players?'**
  String get playersQuestion;

  /// No description provided for @victimPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'{number}° victim'**
  String victimPlaceholder(Object number);

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @activateDeactivateGames.
  ///
  /// In en, this message translates to:
  /// **'Enable/Disable Games'**
  String get activateDeactivateGames;

  /// No description provided for @noGamesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No games available.'**
  String get noGamesAvailable;

  /// No description provided for @repeatContinuouslyOn.
  ///
  /// In en, this message translates to:
  /// **'Repeat Continuously ON'**
  String get repeatContinuouslyOn;

  /// No description provided for @repeatContinuouslyOff.
  ///
  /// In en, this message translates to:
  /// **'Repeat Continuously OFF'**
  String get repeatContinuouslyOff;

  /// No description provided for @gameInformation.
  ///
  /// In en, this message translates to:
  /// **'Game Information'**
  String get gameInformation;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @configureProbabilities.
  ///
  /// In en, this message translates to:
  /// **'Configure Probabilities'**
  String get configureProbabilities;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight: {weight}%'**
  String totalWeight(Object weight);

  /// No description provided for @mustBe100Percent.
  ///
  /// In en, this message translates to:
  /// **'Must be 100%'**
  String get mustBe100Percent;

  /// No description provided for @weightExceedError.
  ///
  /// In en, this message translates to:
  /// **'Total weight cannot exceed 100%'**
  String get weightExceedError;

  /// No description provided for @saveWeightsError.
  ///
  /// In en, this message translates to:
  /// **'Error saving weights: {error}'**
  String saveWeightsError(Object error);

  /// No description provided for @probabilitiesReset.
  ///
  /// In en, this message translates to:
  /// **'Probabilities reset to default settings!'**
  String get probabilitiesReset;

  /// No description provided for @editGameName.
  ///
  /// In en, this message translates to:
  /// **'Edit {gameName}'**
  String editGameName(Object gameName);

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @typeItemHere.
  ///
  /// In en, this message translates to:
  /// **'Type the {itemLabel} here'**
  String typeItemHere(Object itemLabel);

  /// No description provided for @typeQuestionHere.
  ///
  /// In en, this message translates to:
  /// **'Type the question here'**
  String get typeQuestionHere;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @restoreDefault.
  ///
  /// In en, this message translates to:
  /// **'Restore Default'**
  String get restoreDefault;

  /// No description provided for @restoreConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore all questions to the original default? This action cannot be undone.'**
  String get restoreConfirmation;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to exit without saving?'**
  String get unsavedChangesMessage;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get exitWithoutSaving;

  /// No description provided for @changesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changesSavedSuccess;

  /// No description provided for @saveChangesError.
  ///
  /// In en, this message translates to:
  /// **'Error saving changes.'**
  String get saveChangesError;

  /// No description provided for @questionsRestoredDefault.
  ///
  /// In en, this message translates to:
  /// **'Questions restored to original default.'**
  String get questionsRestoredDefault;

  /// No description provided for @restoreQuestionsError.
  ///
  /// In en, this message translates to:
  /// **'Error restoring questions.'**
  String get restoreQuestionsError;

  /// No description provided for @editWords.
  ///
  /// In en, this message translates to:
  /// **'Edit words'**
  String get editWords;

  /// No description provided for @editQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit questions'**
  String get editQuestionsSubtitle;

  /// No description provided for @currentPlayer.
  ///
  /// In en, this message translates to:
  /// **'Current player: {player}'**
  String currentPlayer(Object player);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @cardsGameInfo.
  ///
  /// In en, this message translates to:
  /// **'In this game, a card with a challenge will be revealed. If the challenge is individual, the current player must complete it.'**
  String get cardsGameInfo;

  /// No description provided for @newForbiddenWord.
  ///
  /// In en, this message translates to:
  /// **'New forbidden word: {word}'**
  String newForbiddenWord(Object word);

  /// No description provided for @forbiddenWordGameInfo.
  ///
  /// In en, this message translates to:
  /// **'To play Forbidden Word, draw a word. Whoever says the forbidden word during the round must drink a shot. Words are removed from the list until the end of the game.'**
  String get forbiddenWordGameInfo;

  /// No description provided for @medusaGameInfo.
  ///
  /// In en, this message translates to:
  /// **'In the Medusa game, all players must lower their heads and, on signal, raise them. If you make eye contact with another player, both must drink a shot.'**
  String get medusaGameInfo;

  /// No description provided for @medusaGameText.
  ///
  /// In en, this message translates to:
  /// **'Lower your head and get ready!'**
  String get medusaGameText;

  /// No description provided for @neverHaveIEverGameInfo.
  ///
  /// In en, this message translates to:
  /// **'To play Never Have I Ever, the host must read the statement. Whoever has done the action must drink a shot.'**
  String get neverHaveIEverGameInfo;

  /// No description provided for @revealQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reveal Question'**
  String get revealQuestion;

  /// No description provided for @paranoiaGameInfo.
  ///
  /// In en, this message translates to:
  /// **'To play Paranoia, the player must read the revealed question and point to who they think is the answer. If the person pointed at wants to know the question, they must drink two shots. If the person refuses to answer, they must drink three shots.'**
  String get paranoiaGameInfo;

  /// No description provided for @spinRoulette.
  ///
  /// In en, this message translates to:
  /// **'Spin the roulette'**
  String get spinRoulette;

  /// No description provided for @drinkOneShot.
  ///
  /// In en, this message translates to:
  /// **'Drink one shot'**
  String get drinkOneShot;

  /// No description provided for @drinkWithFriend.
  ///
  /// In en, this message translates to:
  /// **'Drink with a friend'**
  String get drinkWithFriend;

  /// No description provided for @passTurn.
  ///
  /// In en, this message translates to:
  /// **'Pass the turn'**
  String get passTurn;

  /// No description provided for @drinkAndSpinAgain.
  ///
  /// In en, this message translates to:
  /// **'Drink and spin again'**
  String get drinkAndSpinAgain;

  /// No description provided for @drinkDouble.
  ///
  /// In en, this message translates to:
  /// **'Drink double'**
  String get drinkDouble;

  /// No description provided for @chooseSomeoneToDrink.
  ///
  /// In en, this message translates to:
  /// **'Choose someone to drink'**
  String get chooseSomeoneToDrink;

  /// No description provided for @rouletteGameInfo.
  ///
  /// In en, this message translates to:
  /// **'Spin the roulette and see what fate awaits you.'**
  String get rouletteGameInfo;

  /// No description provided for @revealVerb.
  ///
  /// In en, this message translates to:
  /// **'Reveal Verb'**
  String get revealVerb;

  /// No description provided for @mostLikelyTitle.
  ///
  /// In en, this message translates to:
  /// **'MOST LIKELY'**
  String get mostLikelyTitle;

  /// No description provided for @mostLikelyGameInfo.
  ///
  /// In en, this message translates to:
  /// **'To play Most Likely, the host must read the question and everyone must point to who they think is the right answer, the most pointed person drinks a shot, in case of a tie, both drink.'**
  String get mostLikelyGameInfo;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get word;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get question;

  /// No description provided for @restoreDefaultTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore Default'**
  String get restoreDefaultTooltip;

  /// No description provided for @languageChanging.
  ///
  /// In en, this message translates to:
  /// **'Switching to {language}...'**
  String languageChanging(Object language);

  /// No description provided for @restartRequired.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app to apply language changes'**
  String get restartRequired;

  /// No description provided for @truth.
  ///
  /// In en, this message translates to:
  /// **'TRUTH'**
  String get truth;

  /// No description provided for @dare.
  ///
  /// In en, this message translates to:
  /// **'DARE'**
  String get dare;

  /// No description provided for @nextPlayer.
  ///
  /// In en, this message translates to:
  /// **'NEXT PLAYER'**
  String get nextPlayer;

  /// No description provided for @truthOrDareChoosePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose your challenge:'**
  String get truthOrDareChoosePrompt;

  /// No description provided for @truthOrDareGameInfo.
  ///
  /// In en, this message translates to:
  /// **'In Truth or Dare, the current player must choose between answering a personal truth question or performing a fun dare challenge. If the person refuses to answer the truth or complete the dare, they must drink a shot.'**
  String get truthOrDareGameInfo;

  /// No description provided for @drunkTrivia.
  ///
  /// In en, this message translates to:
  /// **'DRUNK TRIVIA'**
  String get drunkTrivia;

  /// No description provided for @revealAnswer.
  ///
  /// In en, this message translates to:
  /// **'REVEAL ANSWER'**
  String get revealAnswer;

  /// No description provided for @hideAnswer.
  ///
  /// In en, this message translates to:
  /// **'HIDE ANSWER'**
  String get hideAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @drunkTriviaGameInfo.
  ///
  /// In en, this message translates to:
  /// **'In Drunk Trivia, the host reads a question and four options (A, B, C, D). Players must answer, then the host reveals the correct answer. Whoever gets it wrong must drink a shot.'**
  String get drunkTriviaGameInfo;

  /// No description provided for @scratchCard.
  ///
  /// In en, this message translates to:
  /// **'SCRATCH CARD'**
  String get scratchCard;

  /// No description provided for @scratchCardChoosePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a card and scratch it to reveal your fate!'**
  String get scratchCardChoosePrompt;

  /// No description provided for @scratchCardReset.
  ///
  /// In en, this message translates to:
  /// **'NEW CARDS'**
  String get scratchCardReset;

  /// No description provided for @scratchCardGameInfo.
  ///
  /// In en, this message translates to:
  /// **'In Scratch Card, the current player chooses one of 4 cards and scratches it by sliding their finger to reveal a challenge. Only the first card scratched counts, but you can scratch others for fun.'**
  String get scratchCardGameInfo;

  /// No description provided for @managePacks.
  ///
  /// In en, this message translates to:
  /// **'Manage Content Packs'**
  String get managePacks;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noPacksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packs available'**
  String get noPacksAvailable;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @spiceLevel.
  ///
  /// In en, this message translates to:
  /// **'Spice Level'**
  String get spiceLevel;

  /// No description provided for @gamesIncluded.
  ///
  /// In en, this message translates to:
  /// **'Games Included:'**
  String get gamesIncluded;

  /// No description provided for @contentPacks.
  ///
  /// In en, this message translates to:
  /// **'Content Packs'**
  String get contentPacks;

  /// No description provided for @contentPacksDescription.
  ///
  /// In en, this message translates to:
  /// **'Content packs allow you to customize your experience with different sets of questions and challenges.'**
  String get contentPacksDescription;

  /// No description provided for @spiceLevels.
  ///
  /// In en, this message translates to:
  /// **'Spice Levels:'**
  String get spiceLevels;

  /// No description provided for @spiceLevelsDescription.
  ///
  /// In en, this message translates to:
  /// **'• Mild: Family-friendly content\n• Medium: Party atmosphere\n• Spicy: Bolder content\n• Hot: Adults only'**
  String get spiceLevelsDescription;

  /// No description provided for @enablePacksInfo.
  ///
  /// In en, this message translates to:
  /// **'Enable the packs you want to use in your games.'**
  String get enablePacksInfo;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get understood;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @failedToLoadPacks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load packs: {error}'**
  String failedToLoadPacks(Object error);

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
