import 'package:flutter/material.dart';
import '../utils/questions_manager.dart';
import '../utils/game_handler.dart';
import '../localization/generated/app_localizations.dart';

class QuestionsEditorScreen extends StatefulWidget {
  final String gameName;
  
  const QuestionsEditorScreen({
    super.key,
    required this.gameName,
  });

  @override
  QuestionsEditorScreenState createState() => QuestionsEditorScreenState();
}

class QuestionsEditorScreenState extends State<QuestionsEditorScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  List<String> questions = [];
  // For CARDS game, we store the question and type separately
  List<Map<String, Object>> cardsQuestions = [];
  bool isLoading = true;
  bool hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }
  
  Future<void> _loadQuestions() async {
    setState(() {
      isLoading = true;
    });
    
    final loadedQuestions = await QuestionsManager.loadQuestions(widget.gameName);
    
    setState(() {
      if (widget.gameName == 'CARDS') {
        // For CARDS, we parse the special format
        cardsQuestions = loadedQuestions.map<Map<String, Object>>((q) {
          final parts = q.split(',');
          final questionText = parts[0];
          final isPersonal = parts.length > 1 ? parts[1].trim() == 'true' : false;
          return <String, Object>{
            'text': questionText,
            'isPersonal': isPersonal,
          };
        }).toList();
      } else {
        questions = loadedQuestions;
      }
      isLoading = false;
    });
  }
  
  void _addNewQuestion() {
    setState(() {
      if (widget.gameName == 'CARDS') {
        cardsQuestions.add(<String, Object>{
          'text': '',
          'isPersonal': false,
        });
      } else {
        questions.add('');
      }
      hasChanges = true;
    });
  }
  
  void _updateQuestion(int index, String newText) {
    if (index >= 0) {
      setState(() {
        if (widget.gameName == 'CARDS') {
          if (index < cardsQuestions.length) {
            cardsQuestions[index] = <String, Object>{
              'text': newText,
              'isPersonal': cardsQuestions[index]['isPersonal'] as bool,
            };
          }
        } else {
          if (index < questions.length) {
            questions[index] = newText;
          }
        }
        hasChanges = true;
      });
    }
  }
  
  void _updateCardQuestionType(int index, bool isPersonal) {
    if (index >= 0 && index < cardsQuestions.length) {
      setState(() {
        cardsQuestions[index] = <String, Object>{
          'text': cardsQuestions[index]['text'] as String,
          'isPersonal': isPersonal,
        };
        hasChanges = true;
      });
    }
  }
  
  void _removeQuestion(int index) {
    setState(() {
      if (widget.gameName == 'CARDS') {
        if (index >= 0 && index < cardsQuestions.length) {
          cardsQuestions.removeAt(index);
        }
      } else {
        if (index >= 0 && index < questions.length) {
          questions.removeAt(index);
        }
      }
      hasChanges = true;
    });
  }
  
  Future<void> _saveQuestions() async {
    setState(() {
      isLoading = true;
    });
    
    List<String> questionsToSave;
    
    if (widget.gameName == 'CARDS') {
      // Convert back to "question,boolean" format
      questionsToSave = cardsQuestions
          .where((q) => (q['text'] as String).trim().isNotEmpty)
          .map((q) => "${q['text'] as String},${q['isPersonal'] as bool}")
          .toList();
    } else {
      // Filter empty questions
      questionsToSave = questions.where((q) => q.trim().isNotEmpty).toList();
    }
    
    final success = await QuestionsManager.saveQuestions(widget.gameName, questionsToSave);
    
    setState(() {
      isLoading = false;
      hasChanges = !success;
      
      if (success && widget.gameName != 'CARDS') {
        questions = questionsToSave;
      }
    });
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.changesSavedSuccess),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.saveChangesError),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        ),
      );
      }
    }
  }
  
  Future<void> _resetToDefault() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.restoreDefault),
        content: Text(AppLocalizations.of(context)!.restoreConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.restore),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      setState(() {
        isLoading = true;
      });
      
      final success = await QuestionsManager.resetToDefault(widget.gameName);
      
      if (success) {
        await _loadQuestions();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.questionsRestoredDefault),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.restoreQuestionsError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final String itemLabel = widget.gameName == 'TIBITAR' || widget.gameName == 'PALAVRA PROIBIDA' 
        ? AppLocalizations.of(context)!.word 
        : AppLocalizations.of(context)!.question;
    
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: Text(AppLocalizations.of(context)!.editGameName(GameHandler.getGameName(context, widget.gameName)), style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (hasChanges) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.unsavedChanges),
                  content: Text(AppLocalizations.of(context)!.unsavedChangesMessage, style: const TextStyle(color: Color.fromARGB(255, 49, 49, 49), fontSize: 16),),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.exitWithoutSaving),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore, color: Colors.white),
            tooltip: AppLocalizations.of(context)!.restoreDefaultTooltip,
            onPressed: _resetToDefault,
          ),
        ],
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.gameName == 'CARDS'
                    ? AppLocalizations.of(context)!.totalItems(cardsQuestions.length, itemLabel)
                    : AppLocalizations.of(context)!.totalItems(questions.length, itemLabel),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Expanded(
              child: widget.gameName == 'CARDS'
                  ? _buildCardsQuestionsList()
                  : _buildRegularQuestionsList(),
            ),
            const SizedBox(height: 120),
          ],
        ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 10.0, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Button to add new question
            FloatingActionButton(
              heroTag: 'add',
              onPressed: _addNewQuestion,
              backgroundColor: Colors.white,
              foregroundColor: settingsColor,
              child: const Icon(Icons.add),
            ),
            // Button to save changes
            FloatingActionButton(
              heroTag: 'save',
              onPressed: hasChanges ? _saveQuestions : null,
              backgroundColor: hasChanges ? Colors.white : Colors.grey,
              foregroundColor: settingsColor,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRegularQuestionsList() {
    final String itemLabel = widget.gameName == 'TIBITAR' || widget.gameName == 'PALAVRA PROIBIDA' 
        ? AppLocalizations.of(context)!.word 
        : AppLocalizations.of(context)!.question;
        
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white.withValues(alpha: 0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Question number
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 15),
                // Text field to edit the question
                Expanded(
                  child: TextFormField(
                    initialValue: questions[index],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.typeItemHere(itemLabel),
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value) => _updateQuestion(index, value),
                  ),
                ),
                // Button to remove the question
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white70),
                  onPressed: () => _removeQuestion(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCardsQuestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: cardsQuestions.length,
      itemBuilder: (context, index) {
        final isPersonal = cardsQuestions[index]['isPersonal'] as bool;
        
        return Card(
          color: Colors.white.withValues(alpha: 0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Question number
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Text field to edit the question
                    Expanded(
                      child: TextFormField(
                        initialValue: cardsQuestions[index]['text'] as String,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.typeQuestionHere,
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        onChanged: (value) => _updateQuestion(index, value),
                      ),
                    ),
                    // Button to remove the question
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white70),
                      onPressed: () => _removeQuestion(index),
                    ),
                  ],
                ),
                // Switch to toggle between personal and general question
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        isPersonal ? Icons.person : Icons.groups,
                        color: isPersonal ? Colors.orange : Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPersonal ? AppLocalizations.of(context)!.personal : AppLocalizations.of(context)!.general,
                        style: TextStyle(
                          color: isPersonal ? Colors.orange : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: isPersonal,
                        activeColor: Colors.orange,
                        inactiveThumbColor: Colors.blue,
                        activeTrackColor: Colors.orange.withValues(alpha: 0.5),
                        inactiveTrackColor: Colors.blue.withValues(alpha: 0.5),
                        onChanged: (value) => _updateCardQuestionType(index, value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}