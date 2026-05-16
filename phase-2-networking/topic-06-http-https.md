# 🌐 Topic 6: HTTP & HTTPS

## Overview
HTTP (Hypertext Transfer Protocol) and HTTPS (HTTP Secure) are the foundation of web communication. Understanding these protocols is essential for DevOps engineers.

## Key Concepts

### 1. HTTP Basics

**Request Methods:**
- **GET:** Retrieve data
- **POST:** Submit data
- **PUT:** Update resource
- **DELETE:** Remove resource
- **PATCH:** Partial update

**Status Codes:**
- **1xx:** Informational
- **2xx:** Success (200 OK, 201 Created)
- **3xx:** Redirection (301 Moved, 302 Found)
- **4xx:** Client Error (400 Bad Request, 404 Not Found)
- **5xx:** Server Error (500 Internal, 503 Unavailable)

### 2. HTTP Headers

**Common Request Headers:**
```
Host: example.com
User-Agent: Mozilla/5.0
Accept: application/json
Authorization: Bearer token
Content-Type: application/json
```

**Common Response Headers:**
```
Content-Type: application/json
Cache-Control: max-age=3600
Set-Cookie: session=abc123
X-Frame-Options: DENY
```

### 3. HTTPS & TLS

**TLS Handshake Process:**
1. Client Hello (supported ciphers)
2. Server Hello (selected cipher + certificate)
3. Key Exchange
4. Encrypted communication begins

**Benefits of HTTPS:**
- Encryption (confidentiality)
- Authentication (verify server identity)
- Integrity (detect tampering)

### 4. Load Testing HTTP Services

```bash
# Using curl
curl -v https://api.example.com/users

# Using httpie
http GET https://api.example.com/users

# Using ab (Apache Bench)
ab -n 1000 -c 10 https://example.com/
```

## Hands-On Exercises

### Exercise 1: Inspect HTTP Traffic
```bash
# View request/response headers
curl -I https://www.google.com

# Full verbose output
curl -v https://www.google.com
```

### Exercise 2: Test Different Methods
```bash
# GET request
curl https://api.example.com/users

# POST request
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John"}'
```

## Best Practices

1. Always use HTTPS in production
2. Implement proper caching headers
3. Use appropriate status codes
4. Validate all inputs
5. Implement rate limiting

## Additional Resources
- [MDN HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [RFC 7231 - HTTP/1.1](https://tools.ietf.org/html/rfc7231)
