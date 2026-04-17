import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple';

  // Fetches [amount] trivia questions from the OpenTDB API.
  //
  // Optional [category] and [difficulty] parameters narrow the query.
  // Throws an [Exception] if the network request fails or the API
  // returns a non-zero response code.
  Future<List<Question>> fetchQuestions({
    int amount = 10,
    int? category,
    String? difficulty, // 'easy' | 'medium' | 'hard'
  }) async {
    // Build query parameters
    final params = <String, String>{
      'amount': amount.toString(),
      'type': 'multiple', // multiple-choice only
    };
    if (category != null) params['category'] = category.toString();
    if (difficulty != null) params['difficulty'] = difficulty;

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Network error: HTTP ${response.statusCode}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    // OpenTDB uses response_code 0 for success
    final responseCode = body['response_code'] as int;
    if (responseCode != 0) {
      throw Exception(
        'OpenTDB error — response_code: $responseCode. '
        'Try fewer questions or a different category.',
      );
    }

    final results = body['results'] as List<dynamic>;
    return results
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}