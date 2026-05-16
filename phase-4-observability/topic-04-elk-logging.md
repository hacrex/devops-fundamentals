# 📝 Topic 4: Logging with ELK Stack

## Overview
The ELK Stack (Elasticsearch, Logstash, Kibana) is a popular solution for centralized log management. It enables you to collect, analyze, and visualize logs from multiple sources.

## Components

### 1. Elasticsearch
Distributed search and analytics engine that stores logs.

### 2. Logstash
Server-side data processing pipeline that ingests, transforms, and sends logs.

### 3. Kibana
Visualization interface for exploring and analyzing logs.

### 4. Beats (Optional)
Lightweight data shippers (Filebeat, Metricbeat, etc.)

## Architecture

```
┌──────────┐     ┌──────────┐     ┌─────────────┐     ┌──────────┐
│  Apps    │────▶│ Filebeat │────▶│  Logstash   │────▶│ Elastic  │
│  Logs    │     │          │     │  (Process)  │     │ Search   │
└──────────┘     └──────────┘     └─────────────┘     └──────────┘
                                                              │
                                                              ▼
                                                       ┌──────────┐
                                                       │  Kibana  │
                                                       │ (Visual) │
                                                       └──────────┘
```

## Key Concepts

### Log Levels
- **DEBUG:** Detailed diagnostic information
- **INFO:** General operational events
- **WARN:** Potential issues
- **ERROR:** Error conditions
- **FATAL:** Critical failures

### Structured Logging
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "ERROR",
  "service": "api-gateway",
  "message": "Database connection failed",
  "trace_id": "abc123",
  "host": "server-01"
}
```

## Hands-On Exercises

### Exercise 1: Deploy ELK Stack
```bash
docker-compose up -d elasticsearch kibana
```

### Exercise 2: Configure Filebeat
```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
  fields:
    environment: production

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
```

## Best Practices

1. Use structured logging (JSON format)
2. Include correlation IDs for tracing
3. Implement log rotation
4. Set retention policies
5. Monitor log volume
6. Secure sensitive data

## Additional Resources
- [Elastic Documentation](https://www.elastic.co/guide/)
- [Logging Best Practices](https://www.elastic.co/blog/logging-best-practices)
