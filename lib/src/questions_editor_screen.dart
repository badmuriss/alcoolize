import 'package:flutter/material.dart';
import 'questions_manager.dart';

class QuestionsEditorScreen extends StatefulWidget {
  final String gameName;
  
  const QuestionsEditorScreen({
    super.key,
    required this.gameName,
  });

  @override
  _QuestionsEditorScreenState createState() => _QuestionsEditorScreenState();
}

class _QuestionsEditorScreenState extends State<QuestionsEditorScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  List<String> questions = [];
  // Para o jogo CARTAS, armazenamos separadamente a pergunta e o tipo
  List<Map<String, dynamic>> cardsQuestions = [];
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
      if (widget.gameName == 'CARTAS') {
        // Para CARTAS, parseamos o formato especial
        cardsQuestions = loadedQuestions.map((q) {
          final parts = q.split(',');
          final questionText = parts[0];
          final isPersonal = parts.length > 1 ? parts[1].trim() == 'true' : false;
          return {
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
      if (widget.gameName == 'CARTAS') {
        cardsQuestions.add({
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
        if (widget.gameName == 'CARTAS') {
          if (index < cardsQuestions.length) {
            cardsQuestions[index]['text'] = newText;
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
        cardsQuestions[index]['isPersonal'] = isPersonal;
        hasChanges = true;
      });
    }
  }
  
  void _removeQuestion(int index) {
    setState(() {
      if (widget.gameName == 'CARTAS') {
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
    
    if (widget.gameName == 'CARTAS') {
      // Converte de volta para o formato "pergunta,boolean"
      questionsToSave = cardsQuestions
          .where((q) => q['text'].trim().isNotEmpty)
          .map((q) => "${q['text']},${q['isPersonal']}")
          .toList();
    } else {
      // Filtra perguntas vazias
      questionsToSave = questions.where((q) => q.trim().isNotEmpty).toList();
    }
    
    final success = await QuestionsManager.saveQuestions(widget.gameName, questionsToSave);
    
    setState(() {
      isLoading = false;
      hasChanges = !success;
      
      if (success && widget.gameName != 'CARTAS') {
        questions = questionsToSave;
      }
    });
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alterações salvas com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar alterações.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        ),
      );
    }
  }
  
  Future<void> _resetToDefault() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar padrão'),
        content: const Text('Tem certeza que deseja restaurar todas as perguntas para o padrão original? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restaurar'),
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perguntas restauradas para o padrão original.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao restaurar perguntas.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final String itemLabel = widget.gameName == 'TIBITAR' || widget.gameName == 'PALAVRA PROIBIDA' 
        ? 'palavra' 
        : 'pergunta';
    
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: Text('Editar ${widget.gameName}', style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (hasChanges) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Alterações não salvas'),
                  content: const Text('Você tem alterações não salvas. Deseja sair sem salvar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Sair sem salvar'),
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
            tooltip: 'Restaurar padrão',
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
                widget.gameName == 'CARTAS'
                    ? 'Total: ${cardsQuestions.length} ${itemLabel}s'
                    : 'Total: ${questions.length} ${itemLabel}s',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Expanded(
              child: widget.gameName == 'CARTAS'
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
            // Botão para adicionar nova pergunta
            FloatingActionButton(
              heroTag: 'add',
              onPressed: _addNewQuestion,
              backgroundColor: Colors.white,
              foregroundColor: settingsColor,
              child: const Icon(Icons.add),
            ),
            // Botão para salvar alterações
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
        ? 'palavra' 
        : 'pergunta';
        
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Número da pergunta
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                // Campo de texto para editar a pergunta
                Expanded(
                  child: TextFormField(
                    initialValue: questions[index],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Digite a $itemLabel aqui',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value) => _updateQuestion(index, value),
                  ),
                ),
                // Botão para remover a pergunta
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
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Número da pergunta
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Campo de texto para editar a pergunta
                    Expanded(
                      child: TextFormField(
                        initialValue: cardsQuestions[index]['text'] as String,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite a pergunta aqui',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        onChanged: (value) => _updateQuestion(index, value),
                      ),
                    ),
                    // Botão para remover a pergunta
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white70),
                      onPressed: () => _removeQuestion(index),
                    ),
                  ],
                ),
                // Switch para alternar entre pergunta pessoal e geral
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
                        isPersonal ? 'Pessoal' : 'Geral',
                        style: TextStyle(
                          color: isPersonal ? Colors.orange : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: isPersonal,
                        activeColor: Colors.orange,
                        inactiveThumbColor: Colors.blue,
                        activeTrackColor: Colors.orange.withOpacity(0.5),
                        inactiveTrackColor: Colors.blue.withOpacity(0.5),
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