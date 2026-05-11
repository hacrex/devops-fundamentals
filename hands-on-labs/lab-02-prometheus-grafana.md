# 🧪 Lab 2: Prometheus + Grafana Monitoring Stack

## 🎯 Goal
Set up a full observability stack with Prometheus (metrics collection) and Grafana (dashboards) using Docker Compose.

## 📋 Prerequisites
- Docker & Docker Compose installed
- Basic understanding of containers

---

## Project Structure
```
monitoring-stack/
├── docker-compose.yml
├── prometheus/
│   └── prometheus.yml
└── grafana/
    └── provisioning/
        ├── dashboards/
        │   └── dashboard.yml
        └── datasources/
            └── prometheus.yml
```

---

## Step 1: Prometheus Configuration

Create `prometheus/prometheus.yml`:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  # Prometheus self-monitoring
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node exporter (system metrics)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  # Our app (if it exposes /metrics)
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:3000']
    metrics_path: /metrics
```

---

## Step 2: Grafana Datasource

Create `grafana/provisioning/datasources/prometheus.yml`:
```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
```

---

## Step 3: Docker Compose Stack

Create `docker-compose.yml`:
```yaml
version: '3.8'

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:

services:
  # Prometheus
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=15d'
      - '--web.enable-lifecycle'
    networks:
      - monitoring
    restart: unless-stopped

  # Grafana
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_USERS_ALLOW_SIGN_UP=false
    networks:
      - monitoring
    restart: unless-stopped
    depends_on:
      - prometheus

  # Node Exporter (system metrics)
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    networks:
      - monitoring
    restart: unless-stopped

  # Alertmanager
  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    networks:
      - monitoring
    restart: unless-stopped
```

---

## Step 4: Start the Stack

```bash
mkdir monitoring-stack && cd monitoring-stack
# Create all files above

docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f prometheus
```

---

## Step 5: Access the UIs

| Service | URL | Credentials |
|---------|-----|-------------|
| Prometheus | http://localhost:9090 | none |
| Grafana | http://localhost:3000 | admin / admin123 |
| Alertmanager | http://localhost:9093 | none |
| Node Exporter | http://localhost:9100/metrics | none |

---

## Step 6: Useful PromQL Queries

Try these in Prometheus (http://localhost:9090):

```promql
# CPU usage percentage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk usage
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100

# HTTP request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])
```

---

## Step 7: Import a Grafana Dashboard

1. Go to Grafana → Dashboards → Import
2. Enter dashboard ID: **1860** (Node Exporter Full)
3. Select Prometheus datasource
4. Click Import

---

## ✅ What You Learned
- Setting up Prometheus for metrics collection
- Configuring Node Exporter for system metrics
- Running Grafana with auto-provisioned datasources
- Writing basic PromQL queries
- Importing community dashboards
