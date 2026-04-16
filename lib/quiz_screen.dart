import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';
 
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
 
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}
 
class _QuizScreenState extends State<QuizScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Trivia Quiz'),
        centerTitle: true,
      ),
    
    );
  }


}