# 🔒 Topic 8: TLS/SSL Certificates

## Overview
TLS (Transport Layer Security) and SSL (Secure Sockets Layer) certificates encrypt data in transit, ensuring secure communication between clients and servers.

## Key Concepts

### 1. Certificate Types

| Type | Validation | Use Case |
|------|------------|----------|
| DV (Domain Validated) | Domain ownership only | Basic websites |
| OV (Organization Validated) | Business verification | Corporate sites |
| EV (Extended Validation) | Rigorous verification | Financial/legal |
| Wildcard | *.domain.com | Multiple subdomains |
| SAN/Multi-domain | Multiple domains | Complex infrastructures |

### 2. Certificate Chain

```
Root CA → Intermediate CA → Server Certificate
(Signed by) → (Signed by) → (Presented to client)
```

### 3. Common Certificate Formats

- **PEM:** Base64 encoded, .pem/.crt/.cer
- **DER:** Binary format, .der
- **PKCS#12:** Contains cert + private key, .pfx/.p12
- **CSR:** Certificate Signing Request, .csr

### 4. Certificate Lifecycle

1. Generate private key
2. Create CSR (Certificate Signing Request)
3. Submit to Certificate Authority (CA)
4. CA validates and issues certificate
5. Install on server
6. Monitor expiration
7. Renew before expiry

### 5. OpenSSL Commands

```bash
# Generate private key
openssl genrsa -out server.key 2048

# Create CSR
openssl req -new -key server.key -out server.csr

# View certificate details
openssl x509 -in certificate.crt -text -noout

# Check certificate expiration
openssl x509 -enddate -noout -in certificate.crt

# Verify certificate chain
openssl verify -CAfile ca-bundle.crt certificate.crt
```

### 6. Let's Encrypt (Free Certificates)

```bash
# Using Certbot
certbot --nginx -d example.com

# Auto-renewal (cron job)
0 0 1 * * certbot renew --quiet
```

## Hands-On Exercises

### Exercise 1: Generate Self-Signed Certificate
```bash
# Generate key and certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout server.key -out server.crt \
  -subj "/CN=localhost"
```

### Exercise 2: Check Certificate Expiry
```bash
# Check remote certificate
echo | openssl s_client -connect google.com:443 2>/dev/null | \
  openssl x509 -noout -dates
```

## Best Practices

1. Use certificates from trusted CAs
2. Enable auto-renewal
3. Monitor expiration dates
4. Use strong key sizes (2048+ bits)
5. Implement HSTS headers
6. Support only TLS 1.2+
7. Regularly rotate keys

## Additional Resources
- [Let's Encrypt](https://letsencrypt.org/)
- [SSL Labs Test](https://www.ssllabs.com/ssltest/)
- [Mozilla SSL Config Generator](https://ssl-config.mozilla.org/)
