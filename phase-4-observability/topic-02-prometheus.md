# 📈 Topic 2: Prometheus

## Overview
Prometheus is an open-source monitoring and alerting toolkit originally built at SoundCloud. It's now a Cloud Native Computing Foundation (CNCF) graduated project, widely adopted for monitoring cloud-native applications.

## Key Concepts

### 1. Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Targets    │────▶│  Prometheus  │────▶│   Grafana    │
│ (Exporters)  │     │   Server     │     │  Dashboard   │
└──────────────┘     └──────────────┘     └──────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │ Alertmanager │
                     └──────────────┘
```

**Components:**
- **Prometheus Server:** Scrapes and stores time series data
- **Exporters:** Expose metrics from various systems
- **Alertmanager:** Handles alerts and notifications
- **Pushgateway:** Accepts pushed metrics from short-lived jobs
- **Grafana:** Visualization and dashboards

### 2. Data Model

**Metric Names:** Follow pattern `namespace_subsystem_component_unit`
```
http_requests_total
node_cpu_seconds_total
container_memory_usage_bytes
```

**Labels:** Key-value pairs attached to metrics
```
http_requests_total{method="POST", handler="/api/users", status="200"}
```

**Timestamps:** Each sample has a millisecond-precision timestamp

### 3. Configuration (prometheus.yml)

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

rule_files:
  - "alerts.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance

  - job_name: 'docker'
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    filters:
      - name: label
        values: ["metrics"]
```

### 4. Service Discovery

**Static Configs:** Manually defined targets
```yaml
static_configs:
  - targets: ['host1:9100', 'host2:9100']
```

**Dynamic Service Discovery:**
- **DNS SD:** Discover via DNS records
- **File SD:** Read targets from files
- **Kubernetes SD:** Auto-discover pods/services
- **Docker SD:** Discover containers
- **Consul SD:** Integrate with Consul
- **EC2 SD:** Discover AWS instances

### 5. PromQL (Prometheus Query Language)

**Basic Queries:**
```promql
# Raw metric
http_requests_total

# Filter by label
http_requests_total{method="GET", status="200"}

# Rate over time window
rate(http_requests_total[5m])

# Increase over time
increase(http_requests_total[1h])
```

**Aggregation Operators:**
```promql
# Sum across all instances
sum(rate(http_requests_total[5m]))

# Average by label
avg by (job) (node_cpu_seconds_total)

# Maximum
max(node_memory_MemAvailable_bytes)

# Count
count(up == 1)
```

**Math Operations:**
```promql
# Percentage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) 
/ node_memory_MemTotal_bytes * 100

# Join metrics
node_filesystem_size_bytes * on(instance) group_left() node_uname_info
```

**Time Functions:**
```promql
# Offset (compare with past)
rate(http_requests_total[5m]) offset 1d

# Predict linear regression
predict_linear(node_filesystem_avail_bytes[6h], 3600 * 24)
```

### 6. Recording Rules

Pre-compute frequently used queries:
```yaml
groups:
  - name: recording_rules
    interval: 1m
    rules:
      - record: job:http_requests_total:rate5m
        expr: sum by (job) (rate(http_requests_total[5m]))
      
      - record: instance:node_cpu_utilization:ratio
        expr: 1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
```

### 7. Alerting Rules

```yaml
groups:
  - name: application_alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum by (service) (rate(http_requests_total{status=~"5.."}[5m]))
          / sum by (service) (rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate in {{ $labels.service }}"
          description: "Error rate is {{ $value | humanizePercentage }}"
      
      - alert: InstanceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
      
      - alert: HighMemoryUsage
        expr: |
          (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)
          / node_memory_MemTotal_bytes > 0.9
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
```

### 8. Common Exporters

| Exporter | Port | Purpose |
|----------|------|---------|
| Node Exporter | 9100 | Hardware/OS metrics |
| cAdvisor | 8080 | Container metrics |
| Blackbox Exporter | 9115 | Probe endpoints (HTTP, TCP, ICMP) |
| Pushgateway | 9091 | Push metrics from batch jobs |
| Alertmanager | 9093 | Alert routing/silencing |
| mysqld_exporter | 9104 | MySQL metrics |
| postgres_exporter | 9187 | PostgreSQL metrics |
| redis_exporter | 9121 | Redis metrics |

### 9. Storage & Retention

**Local Storage:**
```bash
# Default retention: 15 days
--storage.tsdb.path=/prometheus
--storage.tsdb.retention.time=15d
--storage.tsdb.retention.size=10GB
```

**Remote Write (to long-term storage):**
```yaml
remote_write:
  - url: "https://cortex.example.com/api/v1/push"
    basic_auth:
      username: user
      password: pass
```

### 10. Deployment Options

**Docker Compose:**
```yaml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:v2.45.0
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    restart: unless-stopped

volumes:
  prometheus_data:
```

**Kubernetes (Helm):**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

## Hands-On Exercises

### Exercise 1: Install Prometheus with Docker
```bash
mkdir prometheus-lab && cd prometheus-lab

cat > prometheus.yml << 'YAML'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'node'
    static_configs:
      - targets: ['host.docker.internal:9100']
YAML

docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus:latest
```

### Exercise 2: Install Node Exporter
```bash
docker run -d \
  --name node-exporter \
  -p 9100:9100 \
  --pid="host" \
  --net="host" \
  quay.io/prometheus/node-exporter:latest
```

### Exercise 3: Practice PromQL
1. Open http://localhost:9090
2. Try these queries:
   - `up` - Check which targets are up
   - `rate(prometheus_http_requests_total[5m])` - Request rate
   - `prometheus_tsdb_head_samples_appended_total` - Samples ingested
   - `node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100` - Memory %

### Exercise 4: Create Alerts
```bash
cat > alerts.yml << 'YAML'
groups:
  - name: example_alerts
    rules:
      - alert: TargetDown
        expr: up == 0
        for: 1m
        annotations:
          summary: "Target {{ $labels.job }} is down"
YAML

# Add to prometheus.yml rule_files section
```

## Common Issues & Solutions

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| Targets not scraping | Check network/firewall | Verify exporter is running |
| High cardinality | Too many label combinations | Reduce dynamic labels |
| Missing data | Gaps in scrape | Check scrape interval |
| Slow queries | Complex expressions | Use recording rules |
| Disk full | TSDB growing too large | Adjust retention settings |

## Best Practices

1. **Use appropriate scrape intervals** - 15-30s for most, 1-5m for slow-changing metrics
2. **Label consistently** - Follow naming conventions
3. **Avoid high cardinality** - Don't use usernames, emails as labels
4. **Use recording rules** - Pre-compute expensive queries
5. **Set retention based on needs** - Balance storage vs. history
6. **Test alerts** - Ensure they fire when expected
7. **Document metrics** - Maintain metric dictionary
8. **Monitor Prometheus itself** - Self-monitoring is crucial

## Next Steps

- Learn Grafana for visualization (Topic 3)
- Implement ELK stack for logging (Topic 4)
- Explore distributed tracing (Topic 5)

## Additional Resources

- [Prometheus Official Docs](https://prometheus.io/docs/)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
- [Awesome Prometheus](https://awesome-prometheus-alerts.grep.to/)
- [Prometheus Community](https://prometheus.io/community/)
