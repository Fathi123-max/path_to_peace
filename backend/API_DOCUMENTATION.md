# Path to Peace API Documentation

This document provides detailed information about the Path to Peace backend API endpoints for mobile app integration.

## Base URL

```
http://localhost:3000  # For local development
https://your-deployed-url.com  # For production
```

## Common Response Format

All API responses follow this structure:

```json
{
  "success": boolean,
  "data": object|array|null,
  "message": string,  // Optional
  "error": string     // Optional
}
```

## 1. Quotes Endpoint

### Get Quote of the Day
```
GET /quotes
```

**Description**: Returns the quote of the day based on the current date.

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "1",
    "text": "And whoever relies upon Allah – then He is sufficient for him.",
    "source": "Quran 65:3"
  }
}
```

### Get Random Quote
```
GET /quotes?random=true
```

**Description**: Returns a random quote from the collection.

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "3",
    "text": "And We will surely test you with something of fear and hunger and a loss of wealth and lives and fruits, but give good tidings to the patient.",
    "source": "Quran 2:155"
  }
}
```

## 2. FAQ Endpoint

### Get All FAQs
```
GET /faq
```

**Description**: Returns a list of all frequently asked questions.

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "question": "What is Islam?",
      "answer": "Islam is a monotheistic religion founded on the teachings of the Quran..."
    },
    {
      "id": "2",
      "question": "What do Muslims believe?",
      "answer": "Muslims believe in One God (Allah), angels, holy books..."
    }
  ]
}
```

## 3. Questions Endpoint

### Submit a Question
```
POST /questions
```

**Description**: Submit a question to be answered by an expert.

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "question": "What is the purpose of life according to Islam?"
}
```

**Response (Success)**:
```json
{
  "success": true,
  "message": "Your question has been submitted."
}
```

**Response (Validation Error)**:
```json
{
  "success": false,
  "error": "Validation error",
  "message": "Valid email is required"
}
```

## Error Responses

### 404 Not Found
```json
{
  "success": false,
  "error": "Not Found",
  "message": "Endpoint not found"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "error": "Internal Server Error",
  "message": "Something went wrong!"
}
```

### 429 Too Many Requests (Rate Limiting)
```json
{
  "success": false,
  "error": "Too many requests",
  "message": "Too many requests from this IP, please try again later."
}
```

## Flutter Integration Examples

### 1. Fetching Quote of the Day

```dart
Future<Map<String, dynamic>> getQuoteOfTheDay() async {
  final response = await http.get(Uri.parse('http://localhost:3000/quotes'));
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load quote');
  }
}
```

### 2. Fetching Random Quote

```dart
Future<Map<String, dynamic>> getRandomQuote() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/quotes?random=true')
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load random quote');
  }
}
```

### 3. Fetching FAQs

```dart
Future<List<dynamic>> getFAQs() async {
  final response = await http.get(Uri.parse('http://localhost:3000/faq'));
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data'];
  } else {
    throw Exception('Failed to load FAQs');
  }
}
```

### 4. Submitting a Question

```dart
Future<bool> submitQuestion({
  required String name,
  required String email,
  required String question,
}) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/questions'),
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
    throw Exception('Failed to submit question');
  }
}
```

## Rate Limiting

The API implements rate limiting to prevent abuse:
- Limit: 50 requests per 15 minutes per IP address
- Exceeding this limit will result in a 429 status code

## CORS Policy

The API allows cross-origin requests from any domain by default. For production, you should configure the `CORS_ORIGIN` environment variable to restrict access to your mobile app's domain.

## UTF-8 Support

All endpoints fully support UTF-8 encoding, allowing for proper display of Arabic text in quotes and FAQs.

## Health Check

```
GET /health
```

**Description**: Check if the API is running.

**Response**:
```json
{
  "success": true,
  "message": "Path to Peace API is running",
  "timestamp": "2023-07-19T10:30:00.000Z"
}
```