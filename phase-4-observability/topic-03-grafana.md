# 📊 Topic 3: Grafana

## Overview
Grafana is an open-source platform for monitoring and observability. It provides powerful visualization tools for metrics, logs, and traces from various data sources.

## Key Concepts

### 1. Core Components

**Dashboards:** Collections of panels that visualize data
**Panels:** Individual visualizations (graphs, tables, gauges)
**Data Sources:** Connections to backends (Prometheus, Elasticsearch, etc.)
**Alerts:** Notifications based on threshold conditions
**Users & Teams:** Access control and permissions

### 2. Data Sources

| Data Source | Type | Use Case |
|-------------|------|----------|
| Prometheus | Metrics | Time-series monitoring |
| Elasticsearch | Logs/Docs | Log analysis |
| Loki | Logs | Lightweight log aggregation |
| Jaeger | Traces | Distributed tracing |
| MySQL/PostgreSQL | SQL | Database metrics |
| CloudWatch | Metrics | AWS monitoring |
| Azure Monitor | Metrics | Azure monitoring |

### 3. Panel Types

- **Graph/Time Series:** Line charts over time
- **Stat:** Single value with sparkline
- **Gauge:** Value within a range
- **Bar Gauge:** Horizontal/vertical bars
- **Table:** Tabular data
- **Heatmap:** Distribution over time
- **Pie Chart:** Proportional data
- **Alert List:** Active alerts
- **Text:** Markdown/HTML content

### 4. Query Building

**Prometheus Example:**
```promql
# CPU Usage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk Usage
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

**Variables for Dynamic Dashboards:**
```
$instance - Select specific host
$job - Filter by job name
$interval - Adjust time resolution
```

### 5. Dashboard Best Practices

1. **Start with overview** - Show key metrics at top
2. **Use consistent colors** - Green=good, Red=bad
3. **Add appropriate thresholds** - Visual indicators
4. **Include documentation** - Text panels explaining metrics
5. **Optimize queries** - Use variables, avoid expensive operations
6. **Set appropriate refresh rates** - Balance freshness vs. load

## Hands-On Exercises

### Exercise 1: Install Grafana
```bash
docker run -d \
  --name grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana:latest
```

### Exercise 2: Add Prometheus Data Source
1. Open http://localhost:3000 (admin/admin)
2. Go to Configuration → Data Sources
3. Add data source → Prometheus
4. URL: http://prometheus:9090
5. Save & Test

### Exercise 3: Create Dashboard
1. Create new dashboard
2. Add panel for CPU usage
3. Add panel for memory usage
4. Add panel for disk usage
5. Save dashboard

## Additional Resources
- [Grafana Docs](https://grafana.com/docs/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
