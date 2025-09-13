import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_to_peace/models/quote.dart';
import 'package:path_to_peace/models/faq.dart';

class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Fetches the quote of the day from the API
  static Future<Quote?> fetchQuoteOfTheDay() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quotes'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return Quote.fromJson(jsonResponse['data']);
        }
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        throw ApiException('Too many requests. Please try again later.', response.statusCode);
      }
      return null;
    } catch (e) {
      // Re-throw as ApiException for consistent error handling
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to load quote: $e', 500);
    }
  }

  /// Fetches a random quote from the API
  static Future<Quote?> fetchRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quotes?random=true'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return Quote.fromJson(jsonResponse['data']);
        }
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        throw ApiException('Too many requests. Please try again later.', response.statusCode);
      }
      return null;
    } catch (e) {
      // Re-throw as ApiException for consistent error handling
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to load random quote: $e', 500);
    }
  }

  /// Fetches all FAQs from the API
  static Future<List<Faq>?> fetchFaqs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/faq'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> faqsJson = jsonResponse['data'];
          return faqsJson.map((json) => Faq.fromJson(json)).toList();
        }
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        throw ApiException('Too many requests. Please try again later.', response.statusCode);
      }
      return null;
    } catch (e) {
      // Re-throw as ApiException for consistent error handling
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to load FAQs: $e', 500);
    }
  }

  /// Submits a user question to the API
  static Future<bool> submitQuestion({
    required String name,
    required String email,
    required String question,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/questions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'question': question,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        throw ApiException(jsonResponse['message'] ?? 'Validation error', response.statusCode);
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        throw ApiException('Too many requests. Please try again later.', response.statusCode);
      } else {
        throw ApiException('Failed to submit question', response.statusCode);
      }
    } catch (e) {
      // Re-throw as ApiException for consistent error handling
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to submit question: $e', 500);
    }
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}