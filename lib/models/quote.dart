class Quote {
  final String id;
  final String text;
  final String source;

  Quote({
    required this.id,
    required this.text,
    required this.source,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'source': source,
    };
  }
}