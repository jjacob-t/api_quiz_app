class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers;

  Question({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final correct = json['correct_answer'] as String;
    final incorrect = List<String>.from(json['incorrect_answers'] as List);

    // Combine and shuffle all answers
    final answers = [correct, ...incorrect]..shuffle();

    return Question(
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      question: _decode(json['question'] as String),
      correctAnswer: _decode(correct),
      allAnswers: answers.map(_decode).toList(),
    );
  }

  // Decodes HTML entities returned by the API
  static String _decode(String raw) {
    return const HtmlUnescape().convert(raw);
  }
}

// HTML entity decoder
class HtmlUnescape {
  const HtmlUnescape();

  static const _entities = <String, String>{
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&#039;': "'",
    '&apos;': "'",
    '&nbsp;': ' ',
    '&ldquo;': '\u201C',
    '&rdquo;': '\u201D',
    '&lsquo;': '\u2018',
    '&rsquo;': '\u2019',
    '&mdash;': '\u2014',
    '&ndash;': '\u2013',
  };

  String convert(String input) {
    var result = input;
    _entities.forEach((entity, char) {
      result = result.replaceAll(entity, char);
    });
    // Handle numeric entities like &#123;
    result = result.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
      final code = int.tryParse(m.group(1)!);
      return code != null ? String.fromCharCode(code) : m.group(0)!;
    });
    return result;
  }
}