# Flutter Integration Example

This is a simple example of how to integrate the Path to Peace API with a Flutter app.

## 1. Add HTTP dependency

First, add the HTTP dependency to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^0.13.5
```

## 2. Model Classes

Create model classes for the API responses:

```dart
// quote.dart
class Quote {
  final String id;
  final String text;
  final String source;

  Quote({required this.id, required this.text, required this.source});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      source: json['source'],
    );
  }
}

// faq.dart
class FAQ {
  final String id;
  final String question;
  final String answer;

  FAQ({required this.id, required this.question, required this.answer});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
```

## 3. API Service

Create an API service to handle requests:

```dart
// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote.dart';
import 'faq.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  // Get quote of the day
  static Future<Quote> getQuoteOfTheDay() async {
    final response = await http.get(Uri.parse('$baseUrl/quotes'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Quote.fromJson(data['data']);
    } else {
      throw Exception('Failed to load quote');
    }
  }
  
  // Get random quote
  static Future<Quote> getRandomQuote() async {
    final response = await http.get(Uri.parse('$baseUrl/quotes?random=true'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Quote.fromJson(data['data']);
    } else {
      throw Exception('Failed to load random quote');
    }
  }
  
  // Get all FAQs
  static Future<List<FAQ>> getFAQs() async {
    final response = await http.get(Uri.parse('$baseUrl/faq'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> faqsJson = data['data'];
      return faqsJson.map((json) => FAQ.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FAQs');
    }
  }
  
  // Submit a question
  static Future<bool> submitQuestion({
    required String name,
    required String email,
    required String question,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/questions'),
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
      return true;
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to submit question');
    }
  }
}
```

## 4. Using in Widgets

Example of how to use the API service in your Flutter widgets:

```dart
// quote_widget.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'quote.dart';

class QuoteWidget extends StatefulWidget {
  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  Quote? _quote;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  _loadQuote() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final quote = await ApiService.getQuoteOfTheDay();
      setState(() {
        _quote = quote;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print('Error loading quote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the Day'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _quote != null
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _quote!.text,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _quote!.source,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text('No quote available'),
                ),
    );
  }
}
```

## 5. Error Handling

For production apps, implement proper error handling:

```dart
try {
  final quote = await ApiService.getQuoteOfTheDay();
  // Handle success
} on SocketException {
  // Handle network errors
  showMessage('No internet connection');
} on TimeoutException {
  // Handle timeout
  showMessage('Request timeout');
} catch (e) {
  // Handle other errors
  showMessage('Error: ${e.toString()}');
}
```

## 6. Rate Limiting Considerations

The API implements rate limiting (50 requests per 15 minutes). In your app:

1. Cache responses when appropriate
2. Implement exponential backoff for retry logic
3. Show user-friendly messages when rate limited

```dart
if (response.statusCode == 429) {
  showMessage('Too many requests. Please try again later.');
}
```

This example provides a foundation for integrating the Path to Peace API with your Flutter app. Adjust the base URL for your production deployment.