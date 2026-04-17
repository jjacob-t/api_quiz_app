import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';
 
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
 
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}
 
class _QuizScreenState extends State<QuizScreen> {
  final List<Question> _questions = [
    Question(
      category: 'General Knowledge',
      difficulty: 'easy',
      question: 'What is the capital of France?',
      correctAnswer: 'Paris',
      allAnswers: ['Berlin', 'Paris', 'Madrid', 'Rome'],
    ),
    Question(
      category: 'General Knowledge',
      difficulty: 'easy',
      question: 'How many sides does a triangle have?',
      correctAnswer: '3',
      allAnswers: ['3', '4', '5', '6'],
    ),
  ];
  bool _answered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
  }

  void _onAnswerTapped(String answer) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswer = answer;
    });
  }

  Color _buttonColor(String answer) {
    if (!_answered) return Theme.of(context).colorScheme.primaryContainer;
    final correct = _questions[0].correctAnswer;
    if (answer == correct) return Colors.green.shade400;
    if (answer == _selectedAnswer) return Colors.red.shade400;
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[0];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Trivia Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
          ],
        ),
      ),
    );
  }
}