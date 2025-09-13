import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_to_peace/models/quote.dart';
import 'package:path_to_peace/models/faq.dart';

class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static Future<Quote?> fetchQuoteOfTheDay() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quote-of-the-day'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Quote.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Faq>?> fetchFaqs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/faq'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Faq.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}