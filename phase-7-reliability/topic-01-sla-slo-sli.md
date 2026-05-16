# 📊 Topic 1: SLA/SLO/SLI

## Overview
Service Level Objectives (SLOs), Service Level Indicators (SLIs), and Service Level Agreements (SLAs) are key concepts in Site Reliability Engineering for measuring and managing service reliability.

## Key Concepts

### 1. Definitions

**SLI (Service Level Indicator):** What you measure
- Latency, availability, error rate, throughput
- Example: "99.9% of requests complete in < 200ms"

**SLO (Service Level Objective):** Your target
- Internal goal for reliability
- Example: "99.9% availability over 30 days"

**SLA (Service Level Agreement):** Contract with customers
- Legal agreement with consequences
- Example: "99.5% uptime or service credit"

### 2. Relationship

```
SLI (Measurement) → SLO (Target) → SLA (Contract)
     ↓                ↓               ↓
  Metrics         Goals          Business
```

### 3. Common SLIs

| Metric | Description | Example Target |
|--------|-------------|----------------|
| Availability | % of successful requests | 99.9% |
| Latency | Response time percentiles | p99 < 500ms |
| Throughput | Requests per second | 1000 req/s |
| Error Rate | % of failed requests | < 0.1% |

### 4. Error Budgets

**Formula:** `Error Budget = 1 - SLO`

Example:
- SLO: 99.9% availability
- Error Budget: 0.1% downtime
- Monthly budget: ~43 minutes of downtime

## Hands-On Exercises

### Exercise 1: Define SLOs
```yaml
service: api-gateway
slos:
  availability:
    target: 99.9%
    window: 30d
  latency:
    target: p99 < 300ms
    window: 7d
```

## Best Practices

1. Start with simple SLIs
2. Set realistic SLOs
3. Track error budget consumption
4. Alert on budget burn rate
5. Review and adjust regularly

## Additional Resources
- [Google SRE Book - SLIs/SLOs/SLAs](https://sre.google/sre-book/service-level-objectives/)
- [SLO Implementation Guide](https://sre.google/workbook/implementing-slos/)
