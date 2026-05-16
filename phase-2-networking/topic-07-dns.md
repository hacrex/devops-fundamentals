# 📡 Topic 7: DNS

## Overview
DNS (Domain Name System) translates human-readable domain names to IP addresses. It's a critical component of internet infrastructure that every DevOps engineer must understand.

## Key Concepts

### 1. DNS Hierarchy

```
Root (.) → TLD (.com, .org) → Domain (example.com) → Subdomain (www.example.com)
```

### 2. Record Types

| Type | Purpose | Example |
|------|---------|---------|
| A | IPv4 address | example.com → 93.184.216.34 |
| AAAA | IPv6 address | example.com → 2606:2800:220:1:: |
| CNAME | Alias to another domain | www → example.com |
| MX | Mail server | mail.example.com |
| TXT | Text records (SPF, DKIM) | "v=spf1 include:_spf.google.com" |
| NS | Name servers | ns1.example.com |
| SOA | Start of Authority | Zone information |
| PTR | Reverse DNS | IP → domain |

### 3. DNS Resolution Process

1. Client queries local DNS cache
2. Query recursive resolver
3. Resolver queries root servers
4. Root directs to TLD servers
5. TLD directs to authoritative servers
6. Authoritative returns IP address
7. Response cached at each level

### 4. TTL (Time To Live)

How long DNS records are cached:
- **Low TTL (60s):** Fast changes, more queries
- **High TTL (86400s/24h):** Slower changes, fewer queries

### 5. Common DNS Tools

```bash
# Basic lookup
nslookup example.com

# Detailed query
dig example.com

# Specific record type
dig MX example.com

# Trace resolution path
dig +trace example.com

# Reverse lookup
dig -x 93.184.216.34
```

## Hands-On Exercises

### Exercise 1: Query DNS Records
```bash
# Get A record
dig google.com

# Get all records
dig ANY google.com

# Use specific DNS server
dig @8.8.8.8 google.com
```

### Exercise 2: Test DNS Propagation
```bash
# Check from different servers
dig @1.1.1.1 example.com
dig @8.8.8.8 example.com
dig @208.67.222.222 example.com
```

## Best Practices

1. Use multiple name servers
2. Implement DNSSEC for security
3. Monitor DNS health
4. Set appropriate TTL values
5. Use CDN for global distribution
6. Have disaster recovery plan

## Additional Resources
- [DNS Basics](https://howdns.works/)
- [RFC 1035 - DNS Specification](https://tools.ietf.org/html/rfc1035)
- [Cloudflare DNS Learning](https://www.cloudflare.com/learning/dns/)
