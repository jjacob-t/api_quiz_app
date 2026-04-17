import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static const String _url = 'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple';

  // Fetches [amount] trivia questions from the OpenTDB API.
  //
  // Optional [category] and [difficulty] parameters narrow the query.
  // Throws an [Exception] if the network request fails or the API
  // returns a non-zero response code.
  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Network error: HTTP ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['response_code'] != 0) {
      throw Exception('OpenTDB error — response_code: ${body['response_code']}');
    }

    final results = body['results'] as List<dynamic>;
    return results
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}