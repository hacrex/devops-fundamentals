# 🔍 Topic 5: Distributed Tracing

## Overview
Distributed tracing tracks requests as they flow through microservices, helping identify bottlenecks and failures in complex systems.

## Key Concepts

### 1. Core Terminology

**Trace:** Complete journey of a request through the system
**Span:** Individual operation within a trace
**Context:** Information propagated between services
**Baggage:** Custom key-value pairs attached to traces

### 2. Trace Structure

```
Trace ID: abc123
├─ Span 1: API Gateway (0-100ms)
│  └─ Span 2: Auth Service (10-50ms)
│     └─ Span 3: Database Query (20-45ms)
└─ Span 4: User Service (60-90ms)
   └─ Span 5: Cache Lookup (65-75ms)
```

### 3. Popular Tools

| Tool | Language | Features |
|------|----------|----------|
| Jaeger | Multi | CNCF project, Kubernetes integration |
| Zipkin | Java | Simple, lightweight |
| Tempo | Go | Grafana Labs, cost-effective |
| AWS X-Ray | Proprietary | AWS-native tracing |

## Hands-On Exercises

### Exercise 1: Deploy Jaeger
```bash
docker run -d \
  --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest
```

Access UI at http://localhost:16686

## Best Practices

1. Sample appropriately (not 100% in production)
2. Propagate context across all services
3. Include meaningful span names
4. Add relevant tags and logs
5. Monitor trace storage size

## Additional Resources
- [OpenTelemetry](https://opentelemetry.io/)
- [Jaeger Documentation](https://www.jaegertracing.io/docs/)
