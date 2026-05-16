# 📊 Topic 3: Grafana

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 75 min


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


## Try It Yourself

### Exercise 1: Basic Practice
```bash
# Try this command to practice what you learned
# Replace with topic-specific example
echo "Testing your understanding..."
```

**Expected Output:**
```
Testing your understanding...
```

### Exercise 2: Real-World Application
```bash
# Apply this concept in a practical scenario
# Challenge: Modify this example for your use case
```

**Challenge:** Can you adapt this example to solve a problem in your environment?

## Common Mistakes to Avoid

❌ **Mistake 1:** Not checking prerequisites before starting
   - **Solution:** Always verify requirements first

❌ **Mistake 2:** Ignoring error messages
   - **Solution:** Read error messages carefully; they often point to the solution

❌ **Mistake 3:** Skipping documentation
   - **Solution:** Use `--help` flag or man pages when unsure

## Real-World Scenario

**Scenario:** You're deploying an application and need to apply the concepts from this topic.

**Problem:** The application fails to start due to configuration issues.

**Solution Steps:**
1. Check logs for error messages
2. Verify configuration files
3. Test connectivity
4. Review permissions

**Key Takeaway:** Understanding these concepts helps you troubleshoot production issues faster.

## Quiz Questions

Test your understanding with these questions:

1. **Question:** What is the primary purpose of this topic's main concept?
   - A) Option A
   - B) Option B  
   - C) Option C
   - D) Option D
   
   <details><summary>✅ Answer</summary>B) Option B (replace with correct answer)</details>

2. **Question:** Which command would you use to accomplish the main task?
   - A) command-a
   - B) command-b
   - C) command-c
   - D) command-d
   
   <details><summary>✅ Answer</summary>C) command-c (replace with correct answer)</details>

3. **Question:** What happens if you skip an important configuration step?
   - A) Everything works fine
   - B) The system crashes
   - C) Errors occur during runtime
   - D) Nothing happens
   
   <details><summary>✅ Answer</summary>C) Errors occur during runtime</details>


## Additional Resources
- [Grafana Docs](https://grafana.com/docs/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
