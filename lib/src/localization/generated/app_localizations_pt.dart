// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Alcoolize';

  @override
  String get alcoolizeSe => 'ALCOOLIZE-SE';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'English';

  @override
  String get portuguese => 'Português';

  @override
  String get spanish => 'Español';

  @override
  String get players => 'Jogadores';

  @override
  String get playerCount => 'Número de Jogadores';

  @override
  String playerName(Object number) {
    return 'Jogador $number';
  }

  @override
  String get start => 'COMEÇAR';

  @override
  String get gameSettings => 'Configurações dos Jogos';

  @override
  String get adjustProbabilities => 'Ajustar Probabilidades';

  @override
  String get editQuestions => 'Editar Perguntas/Palavras';

  @override
  String get canRepeat => 'Pode Repetir Jogos';

  @override
  String get mysteryVerb => 'TIBITAR';

  @override
  String get neverHaveIEver => 'EU NUNCA';

  @override
  String get roulette => 'ROLETINHA';

  @override
  String get paranoia => 'PARANOIA';

  @override
  String get mostLikelyTo => 'QUEM É MAIS PROVÁVEL';

  @override
  String get forbiddenWord => 'PALAVRA PROIBIDA';

  @override
  String get medusa => 'MEDUSA';

  @override
  String get cards => 'CARTAS';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'PRÓXIMO';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get playersQuestion => 'Quantos Jogadores?';

  @override
  String victimPlaceholder(Object number) {
    return '$number° vítima';
  }

  @override
  String get pleaseEnterName => 'Por favor, insira um nome';

  @override
  String get startGame => 'Começar o Jogo';

  @override
  String get activateDeactivateGames => 'Ativar/Desativar jogos';

  @override
  String get noGamesAvailable => 'Nenhum jogo disponível.';

  @override
  String get repeatContinuouslyOn => 'Repetir Seguidamente ON';

  @override
  String get repeatContinuouslyOff => 'Repetir Seguidamente OFF';

  @override
  String get gameInformation => 'Informações dos Jogos';

  @override
  String get close => 'Fechar';

  @override
  String get configureProbabilities => 'Configurar Probabilidades';

  @override
  String totalWeight(Object weight) {
    return 'Peso Total: $weight%';
  }

  @override
  String get mustBe100Percent => 'Deve ser 100%';

  @override
  String get weightExceedError => 'O peso total não pode exceder 100%';

  @override
  String saveWeightsError(Object error) {
    return 'Erro ao salvar pesos: $error';
  }

  @override
  String get probabilitiesReset =>
      'Probabilidades resetadas para as configurações padrão!';

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
    return 'Digite a $itemLabel aqui';
  }

  @override
  String get typeQuestionHere => 'Digite a pergunta aqui';

  @override
  String get personal => 'Pessoal';

  @override
  String get general => 'Geral';

  @override
  String get restoreDefault => 'Restaurar padrão';

  @override
  String get restoreConfirmation =>
      'Tem certeza que deseja restaurar todas as perguntas para o padrão original? Esta ação não pode ser desfeita.';

  @override
  String get restore => 'Restaurar';

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get unsavedChangesMessage =>
      'Você tem alterações não salvas. Deseja sair sem salvar?';

  @override
  String get exitWithoutSaving => 'Sair sem salvar';

  @override
  String get changesSavedSuccess => 'Alterações salvas com sucesso!';

  @override
  String get saveChangesError => 'Erro ao salvar alterações.';

  @override
  String get questionsRestoredDefault =>
      'Perguntas restauradas para o padrão original.';

  @override
  String get restoreQuestionsError => 'Erro ao restaurar perguntas.';

  @override
  String get editWords => 'Editar palavras';

  @override
  String get editQuestionsSubtitle => 'Editar perguntas';

  @override
  String currentPlayer(Object player) {
    return 'Jogador da vez: $player';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get cardsGameInfo =>
      'Neste jogo, uma carta com um desafio será revelada. Se o desafio for individual, o jogador da vez deve realizá-lo.';

  @override
  String newForbiddenWord(Object word) {
    return 'Nova palavra proibida: $word';
  }

  @override
  String get forbiddenWordGameInfo =>
      'Para jogar Palavra Proibida, sorteie uma palavra. Quem falar a palavra proibida durante a rodada, deve beber uma dose. As palavras são removidas da lista até o fim do jogo.';

  @override
  String get medusaGameInfo =>
      'No jogo Medusa, todos os jogadores devem abaixar a cabeça e, ao sinal, levantar. Se você fizer contato visual com outro jogador, ambos devem beber uma dose.';

  @override
  String get medusaGameText => 'Abaixe a cabeça e prepare-se!';

  @override
  String get neverHaveIEverGameInfo =>
      'Para jogar Eu Nunca, o host deve ler a afirmação. Quem já fez a ação deve beber uma dose.';

  @override
  String get revealQuestion => 'Revelar Pergunta';

  @override
  String get paranoiaGameInfo =>
      'Para jogar Paranoia, o jogador deve ler a pergunta revelada e apontar para quem acha que é a resposta. Se a pessoa apontada quiser saber a pergunta, ela deve beber duas doses. Caso a pessoa se recuse a responder, ela deve beber três doses.';

  @override
  String get spinRoulette => 'Girar a roleta';

  @override
  String get drinkOneShot => 'Beba uma dose';

  @override
  String get drinkWithFriend => 'Beba com um amigo';

  @override
  String get passTurn => 'Passe a vez';

  @override
  String get drinkAndSpinAgain => 'Beba e gire de novo';

  @override
  String get drinkDouble => 'Beba em dobro';

  @override
  String get chooseSomeoneToDrink => 'Escolha alguém para beber';

  @override
  String get rouletteGameInfo =>
      'Rode a roleta e veja o que o destino te aguarda.';

  @override
  String get revealVerb => 'Revelar Verbo';

  @override
  String get mysteryVerbGameInfo =>
      'A roda deve fazer perguntas para o jogador sobre o verbo usando \"tibitar\" para substituí-lo. Exemplo: \"É fácil tibitar?\", \"Onde se tibita com frequência?\". Revele o verbo escondido ao final. A roda tem 3 chances de adivinhar o verbo, cada um que errar bebe uma dose, caso alguem acerte, o jogador da vez deve beber 1 dose.';

  @override
  String get mostLikelyTitle => 'MAIS PROVÁVEL';

  @override
  String get mostLikelyGameInfo =>
      'Para jogar Mais Provável, o host deve ler a pergunta e, todos apontarem para quem eles acham que é a resposta certa, a pessoa mais apontada bebe uma dose, em caso de empate, ambos bebem.';

  @override
  String get systemTheme => 'Tema do Sistema';

  @override
  String get lightTheme => 'Tema Claro';

  @override
  String get darkTheme => 'Tema Escuro';

  @override
  String get word => 'palavra';

  @override
  String get question => 'pergunta';

  @override
  String get restoreDefaultTooltip => 'Restaurar padrão';

  @override
  String languageChanging(Object language) {
    return 'Mudando para $language...';
  }

  @override
  String get restartRequired =>
      'Por favor reinicie o aplicativo para aplicar as mudanças de idioma';
}
