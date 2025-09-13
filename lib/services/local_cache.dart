import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_to_peace/models/quote.dart';
import 'package:path_to_peace/models/faq.dart';

class LocalCache {
  static const String _quoteKey = 'quote_of_the_day';
  static const String _faqsKey = 'faqs';
  static const String _favoritesKey = 'favorites';

  static Future<void> cacheQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quoteKey, json.encode(quote.toJson()));
  }

  static Future<Quote?> getCachedQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final String? quoteJson = prefs.getString(_quoteKey);
    
    if (quoteJson != null) {
      final Map<String, dynamic> data = json.decode(quoteJson);
      return Quote.fromJson(data);
    }
    return null;
  }

  static Future<void> cacheFaqs(List<Faq> faqs) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> faqsJson = faqs.map((faq) => json.encode(faq.toJson())).toList();
    await prefs.setStringList(_faqsKey, faqsJson);
  }

  static Future<List<Faq>?> getCachedFaqs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? faqsJson = prefs.getStringList(_faqsKey);
    
    if (faqsJson != null) {
      return faqsJson.map((faqJson) {
        final Map<String, dynamic> data = json.decode(faqJson);
        return Faq.fromJson(data);
      }).toList();
    }
    return null;
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(id);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
}