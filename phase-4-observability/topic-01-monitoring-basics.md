# 📊 Topic 1: Monitoring Basics

## Overview
Monitoring is the practice of observing and checking the progress and quality of a system over time. It's essential for understanding system health, performance, and user experience.

## Key Concepts

### 1. The Three Pillars of Observability

```
┌─────────────────────────────────────────┐
│         OBSERVABILITY                   │
├─────────────┬─────────────┬─────────────┤
│  Metrics    │   Logs      │   Traces    │
│  (What)     │  (Why)      │  (Where)    │
│  Numeric    │  Textual    │  Contextual │
│  data       │  events     │  flow       │
└─────────────┴─────────────┴─────────────┘
```

**Metrics:** Numerical measurements collected over time
- CPU usage, memory consumption, request rates
- Aggregated data points with timestamps
- Example: `http_requests_total{method="POST", status="200"}`

**Logs:** Immutable timestamped records of discrete events
- Application logs, system logs, audit logs
- Structured or unstructured text
- Example: `2024-01-15T10:30:00Z ERROR Database connection failed`

**Traces:** Records of requests flowing through distributed systems
- Request paths across microservices
- Latency breakdown per service
- Example: User request → API Gateway → Auth Service → Database

### 2. Types of Monitoring

| Type | Focus | Examples |
|------|-------|----------|
| Infrastructure | Servers, networks, storage | CPU, memory, disk I/O |
| Application | Code performance, errors | Response time, error rates |
| Business | KPIs, user metrics | Conversion rates, revenue |
| Synthetic | Simulated user interactions | Uptime checks, load tests |
| Real User Monitoring (RUM) | Actual user experiences | Page load times, errors |

### 3. The USE Method

**U**tilization, **S**aturation, **E**rrors - Resource-focused monitoring:

- **Utilization:** Percentage of resource capacity used
  - CPU utilization: 75%
  - Memory utilization: 60%
  
- **Saturation:** Degree to which resource has queued work
  - Run queue length > CPU cores
  - Disk I/O wait time
  
- **Errors:** Rate of hard errors
  - Network packet drops
  - Disk read/write failures

### 4. The RED Method

**R**ate, **E**rrors, **D**uration - Service-focused monitoring:

- **Rate:** Requests per second
  - HTTP requests/sec
  - Database queries/sec
  
- **Errors:** Error rate (failed requests)
  - HTTP 5xx responses
  - Timeout exceptions
  
- **Duration:** Request latency distribution
  - p50, p95, p99 percentiles
  - Average response time

### 5. Metric Types

**Counter:** Monotonically increasing value
```prometheus
http_requests_total  # Always increases, resets on restart
```

**Gauge:** Value that can go up or down
```prometheus
memory_usage_bytes
cpu_temperature
```

**Histogram:** Distribution of values in buckets
```prometheus
http_request_duration_seconds_bucket
```

**Summary:** Similar to histogram but calculates quantiles
```prometheus
http_request_duration_seconds{quantile="0.95"}
```

### 6. Alerting Strategies

**Threshold-based Alerts:**
```yaml
alert: HighCPUUsage
expr: cpu_usage > 80
for: 5m
labels:
  severity: warning
annotations:
  summary: "CPU usage is above 80%"
```

**Anomaly Detection:**
- Baseline normal behavior
- Alert on deviations
- Use machine learning for patterns

**Alert Severity Levels:**
- **Critical:** Immediate action required (page on-call)
- **Warning:** Action needed soon (ticket creation)
- **Info:** Awareness only (dashboard indicator)

### 7. Golden Signals

Google SRE's four golden signals:

1. **Latency:** Time to service a request
   - Track both successful and failed requests
   - Use percentiles (p95, p99)

2. **Traffic:** Demand on your system
   - HTTP requests/sec
   - Concurrent users
   - Network I/O

3. **Errors:** Rate of failed requests
   - HTTP 5xx responses
   - Failed transactions
   - Exception rates

4. **Saturation:** How full your service is
   - Memory usage
   - Thread pool exhaustion
   - Queue depths

## Hands-On Exercises

### Exercise 1: Install Prometheus Locally
```bash
# Using Docker
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus:latest

# Access at http://localhost:9090
```

### Exercise 2: Basic PromQL Queries
```promql
# All metrics
{}

# Specific metric
node_cpu_seconds_total

# Filter by label
node_cpu_seconds_total{mode="idle"}

# Rate over 5 minutes
rate(node_cpu_seconds_total[5m])

# Sum across instances
sum(rate(node_cpu_seconds_total[5m]))
```

### Exercise 3: Create a Simple Dashboard
1. Install Grafana: `docker run -d -p 3000:3000 grafana/grafana`
2. Add Prometheus as data source (http://prometheus:9090)
3. Import dashboard ID 1860 (Node Exporter Full)
4. Customize panels for your metrics

## Common Issues & Solutions

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| Too many alerts | Alert fatigue | Tune thresholds, add grouping |
| Missing metrics | Gaps in data | Check exporters, scrape config |
| High cardinality | Too many labels | Reduce label combinations |
| Slow queries | Complex PromQL | Use recording rules |

## Best Practices

1. **Monitor what matters** - Focus on user-facing metrics
2. **Use meaningful names** - `http_requests_total` not `metric1`
3. **Add labels strategically** - Don't create high cardinality
4. **Set appropriate intervals** - Balance resolution vs. overhead
5. **Document your metrics** - Maintain a metric dictionary
6. **Test alerts regularly** - Ensure they fire correctly
7. **Create runbooks** - Document response procedures

## Next Steps

- Learn Prometheus in depth (Topic 2)
- Master Grafana dashboards (Topic 3)
- Implement centralized logging (Topic 4)
- Explore distributed tracing (Topic 5)

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Labs](https://grafana.com/)
- [Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Awesome Prometheus](https://awesome-prometheus-alerts.grep.to/)
