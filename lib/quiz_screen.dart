import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';
 
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
 
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}
 
class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await ApiService().fetchQuestions();
    setState(() {
      _questions = questions;
      _currentQuestionIndex = 0;
      _score = 0;
      _answered = false;
      _selectedAnswer = null;
    });
  }

  void _onAnswerTapped(String answer) {
    if (_answered) return;
    final correct = _questions[_currentQuestionIndex].correctAnswer == answer;
    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (correct) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      _showResultDialog();
    }
  }
  
  void _showResultDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Complete 🎉'),
        content: Text('$_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadQuestions();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Color _buttonColor(String answer) {
    if (!_answered) return Theme.of(context).colorScheme.primaryContainer;
    final correct = _questions[_currentQuestionIndex].correctAnswer;
    if (answer == correct) return Colors.green.shade400;
    if (answer == _selectedAnswer) return Colors.red.shade400;
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Quiz'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Score: $_score')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${_currentQuestionIndex + 1} / ${_questions.length}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(q.question,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 24),
            ...q.allAnswers.map(
              (answer) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _buttonColor(answer),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _onAnswerTapped(answer),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Text(answer,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: _answered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: FilledButton(
                onPressed: _answered ? _nextQuestion : null,
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}