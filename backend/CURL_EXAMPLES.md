# API Testing with cURL

This file contains cURL commands to test all API endpoints.

## Health Check
```bash
curl -X GET http://localhost:3000/health
```

## Get Quote of the Day
```bash
curl -X GET http://localhost:3000/quotes
```

## Get Random Quote
```bash
curl -X GET http://localhost:3000/quotes?random=true
```

## Get All FAQs
```bash
curl -X GET http://localhost:3000/faq
```

## Submit a Question
```bash
curl -X POST http://localhost:3000/questions \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "question": "What is the purpose of life according to Islam?"
  }'
```

## Submit a Question with Invalid Data (for testing validation)
```bash
curl -X POST http://localhost:3000/questions \
  -H "Content-Type: application/json" \
  -d '{
    "name": "",
    "email": "invalid-email",
    "question": ""
  }'
```

## Test Rate Limiting
```bash
# Run this command 50+ times to test rate limiting
for i in {1..60}; do curl -s http://localhost:3000/quotes; echo "Request $i"; done
```