# 🧪 Lab 4: ELK Stack for Centralized Logging

## 🎯 Goal
Set up a complete logging stack with Elasticsearch, Logstash, Kibana, and Filebeat to collect, process, and visualize logs from applications.

## 📋 Prerequisites
- Docker & Docker Compose installed
- At least 4GB RAM available (ELK is resource-intensive)
- Basic understanding of logging concepts

⏱️ **Estimated Time:** 90 minutes  
📊 **Difficulty:** 🟡 Intermediate

---

## Project Structure
```
elk-stack/
├── docker-compose.yml
├── elasticsearch/
│   └── config/
│       └── elasticsearch.yml
├── kibana/
│   └── config/
│       └── kibana.yml
├── logstash/
│   ├── config/
│   │   ├── logstash.yml
│   │   └── pipeline/
│   │       └── app.conf
│   └── patterns/
│       └── custom.patterns
└── filebeat/
    └── filebeat.yml
```

---

## Step 1: Elasticsearch Configuration

Create `elasticsearch/config/elasticsearch.yml`:
```yaml
cluster.name: "docker-cluster"
network.host: 0.0.0.0
discovery.type: single-node
xpack.security.enabled: true
xpack.security.enrollment.enabled: false

# Memory settings (adjust based on available RAM)
bootstrap.memory_lock: true

# Performance tuning
indices.query.bool.max_clause_count: 4096
```

Create `.env` file for credentials:
```bash
ELASTIC_PASSWORD=elastic123!
KIBANA_PASSWORD=kibana123!
LOGSTASH_PASSWORD=logstash123!
```

⚠️ **Security Note:** Change these passwords in production!

---

## Step 2: Kibana Configuration

Create `kibana/config/kibana.yml`:
```yaml
server.name: kibana
server.host: 0.0.0.0
server.port: 5601
elasticsearch.hosts: ["http://elasticsearch:9200"]
elasticsearch.username: elastic
elasticsearch.password: ${ELASTIC_PASSWORD}
xpack.security.enabled: true
xpack.encryptedSavedObjects.encryptionKey: "something_at_least_32_characters_long"
```

---

## Step 3: Logstash Pipeline

Create `logstash/config/logstash.yml`:
```yaml
http.host: 0.0.0.0
xpack.monitoring.elasticsearch.hosts: ["http://elasticsearch:9200"]
xpack.monitoring.enabled: true
```

Create `logstash/config/pipeline/app.conf`:
```ruby
input {
  beats {
    port => 5044
  }
  
  tcp {
    port => 5000
    codec => json_lines
  }
}

filter {
  # Parse JSON logs
  if [message] =~ /^\{.*\}$/ {
    json {
      source => "message"
      target => "parsed"
    }
  }
  
  # Add timestamp if missing
  if ![timestamp] {
    mutate {
      add_field => { "timestamp" => "%{@timestamp}" }
    }
  }
  
  # Remove unnecessary fields
  mutate {
    remove_field => ["host", "agent"]
  }
  
  # Add environment tag
  mutate {
    add_field => { "environment" => "development" }
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    user => "elastic"
    password => "${ELASTIC_PASSWORD}"
    index => "app-logs-%{+YYYY.MM.dd}"
  }
  
  # Also print to stdout for debugging
  stdout { codec => rubydebug }
}
```

Create `logstash/patterns/custom.patterns`:
```
CUSTOMIP %{IP}:%{NUMBER}
LOGLEVEL (DEBUG|INFO|WARN|ERROR|FATAL)
```

---

## Step 4: Filebeat Configuration

Create `filebeat/filebeat.yml`:
```yaml
filebeat.inputs:
  # Container logs
  - type: container
    paths:
      - /var/lib/docker/containers/*/*.log
    processors:
      - add_docker_metadata:
          host: "unix:///var/run/docker.sock"
    
  # Application logs
  - type: log
    enabled: true
    paths:
      - /var/log/app/*.log
    multiline.pattern: '^\d{4}-\d{2}-\d{2}'
    multiline.negate: true
    multiline.match: after
    fields:
      log_type: application

# Logstash output
output.logstash:
  hosts: ["logstash:5044"]

# Monitoring
monitoring:
  enabled: true
  elasticsearch:
    hosts: ["http://elasticsearch:9200"]
    username: elastic
    password: ${ELASTIC_PASSWORD}

# Logging
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat.log
  keepfiles: 7
  permissions: 0644
```

---

## Step 5: Docker Compose Stack

Create `docker-compose.yml`:
```yaml
version: '3.8'

networks:
  elk:
    driver: bridge

volumes:
  elasticsearch_data:
  kibana_data:

services:
  # Elasticsearch
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    container_name: elasticsearch
    environment:
      - node.name=es01
      - cluster.name=docker-cluster
      - discovery.type=single-node
      - xpack.security.enabled=true
      - xpack.security.enrollment.enabled=false
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD:-elastic123!}
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
      - ./elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    ports:
      - "9200:9200"
      - "9300:9300"
    networks:
      - elk
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: unless-stopped

  # Kibana
  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD:-elastic123!}
      - XPACK_SECURITY_ENABLED=true
    volumes:
      - kibana_data:/usr/share/kibana/data
      - ./kibana/config/kibana.yml:/usr/share/kibana/config/kibana.yml
    ports:
      - "5601:5601"
    networks:
      - elk
    depends_on:
      elasticsearch:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: unless-stopped

  # Logstash
  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    container_name: logstash
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD:-elastic123!}
      - LS_JAVA_OPTS=-Xmx512m -Xms512m
    volumes:
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml
      - ./logstash/config/pipeline:/usr/share/logstash/pipeline
      - ./logstash/patterns:/usr/share/logstash/patterns
    ports:
      - "5000:5000/tcp"
      - "5000:5000/udp"
      - "5044:5044"
    networks:
      - elk
    depends_on:
      elasticsearch:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9600/_node/stats || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: unless-stopped

  # Filebeat
  filebeat:
    image: docker.elastic.co/beats/filebeat:8.11.0
    container_name: filebeat
    user: root
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD:-elastic123!}
    volumes:
      - ./filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./logs:/var/log/app:ro
    networks:
      - elk
    depends_on:
      logstash:
        condition: service_healthy
    restart: unless-stopped

  # Sample App to Generate Logs
  app:
    image: nginx:alpine
    container_name: sample-app
    volumes:
      - ./logs:/var/log/nginx
    networks:
      - elk
    restart: unless-stopped
```

---

## Step 6: Create Sample Log Generator

Create `generate-logs.sh`:
```bash
#!/bin/bash

LOG_FILE="./logs/app.log"
mkdir -p ./logs

echo "Starting log generator..."

for i in {1..100}; do
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
  LEVELS=("INFO" "WARN" "ERROR" "DEBUG")
  LEVEL=${LEVELS[$RANDOM % ${#LEVELS[@]}]}
  
  echo "{\"timestamp\":\"$TIMESTAMP\",\"level\":\"$LEVEL\",\"message\":\"Sample log message $i\",\"user_id\":$((RANDOM % 1000)),\"request_id\":\"req-$((RANDOM % 10000))\"}" >> "$LOG_FILE"
  
  sleep 0.5
done

echo "Generated 100 log entries"
```

Make it executable:
```bash
chmod +x generate-logs.sh
```

---

## Step 7: Start the ELK Stack

```bash
# Create logs directory
mkdir -p logs

# Start all services
docker compose up -d

# Check status
docker compose ps

# View Elasticsearch logs
docker compose logs -f elasticsearch

# Wait for all services to be healthy (may take 2-3 minutes)
watch docker compose ps
```

---

## Step 8: Access the UIs

| Service | URL | Credentials |
|---------|-----|-------------|
| Kibana | http://localhost:5601 | elastic / elastic123! |
| Elasticsearch | http://localhost:9200 | elastic / elastic123! |
| Logstash API | http://localhost:9600 | - |

Verify Elasticsearch is running:
```bash
curl -u elastic:elastic123! http://localhost:9200/_cluster/health?pretty
```

---

## Step 9: Configure Kibana Dashboards

### 9.1 Create Index Pattern
1. Open Kibana (http://localhost:5601)
2. Go to **Stack Management** → **Index Patterns**
3. Click **Create index pattern**
4. Enter `app-logs-*` as the pattern
5. Select `@timestamp` as time field
6. Click **Create index pattern**

### 9.2 Create Dashboard
1. Go to **Discover**
2. Select `app-logs-*` index pattern
3. Add filters: `level: ERROR`
4. Click **Visualize Library** → **Create visualization**
5. Choose **Lens** or **Vertical Bar**
6. Configure:
   - X-axis: `@timestamp` (date histogram)
   - Y-axis: Count of documents
   - Split by: `level`
7. Save visualization as "Log Levels Over Time"

### 9.3 Create Error Rate Dashboard
1. Create new dashboard
2. Add "Log Levels Over Time" visualization
3. Add metric: "Total Errors" (count where level: ERROR)
4. Add data table showing top error messages
5. Save dashboard as "Application Logs"

---

## Step 10: Test Log Ingestion

Run the log generator:
```bash
./generate-logs.sh
```

Check logs in Elasticsearch:
```bash
curl -u elastic:elastic123! -X GET "http://localhost:9200/app-logs-*/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "size": 5
}'
```

View in Kibana Discover section.

---

## 🔍 Try It Yourself Exercises

### Exercise 1: Create Custom Alert
1. In Kibana, go to **Alerts and Insights** → **Rules**
2. Create rule: "High Error Rate"
3. Condition: When error count > 10 in 5 minutes
4. Action: Send email or webhook notification

### Exercise 2: Parse Multi-line Logs
Modify `logstash/config/pipeline/app.conf` to handle Java stack traces:
```ruby
filter {
  multiline {
    pattern => "^[0-9]{4}-[0-9]{2}-[0-9]{2}"
    negate => true
    what => "previous"
  }
}
```

### Exercise 3: Add GeoIP Enrichment
Install GeoIP plugin and add location data based on IP addresses.

---

## ⚠️ Common Mistakes to Avoid

1. **Insufficient Memory**: ELK needs at least 4GB RAM. Adjust `-Xms` and `-Xmx` values.
2. **Missing Healthchecks**: Always wait for Elasticsearch before starting other services.
3. **No Log Rotation**: Configure file rotation to prevent disk space issues.
4. **Security Disabled**: Never disable X-Pack security in production.
5. **Wrong Index Pattern**: Ensure index pattern matches your actual index names.

---

## 🌍 Real-World Scenarios

### Scenario 1: E-commerce Platform
- Collect logs from multiple microservices
- Track order processing failures
- Monitor payment gateway errors
- Set up alerts for checkout failures

### Scenario 2: SaaS Application
- Multi-tenant log separation using indices
- User activity auditing
- Performance bottleneck identification
- Compliance reporting

### Scenario 3: Security Operations
- Failed login attempt tracking
- Suspicious IP address detection
- Data access audit trails
- Incident investigation timeline

---

## ✅ What You Learned
- Setting up complete ELK stack with Docker
- Configuring Logstash pipelines for log processing
- Creating Filebeat inputs for various log sources
- Building Kibana dashboards and visualizations
- Implementing log aggregation best practices
- Setting up alerts for critical events

---

## 📚 Additional Resources
- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Logstash Configuration](https://www.elastic.co/guide/en/logstash/current/configuration.html)
- [Kibana Tutorials](https://www.elastic.co/guide/en/kibana/current/tutorials.html)
- [Filebeat Modules](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules.html)
- [ELK Best Practices](https://www.elastic.co/blog/found-elasticsearch-from-the-bottom-up)

---

## 🧹 Cleanup

To stop and remove all resources:
```bash
docker compose down -v
rm -rf logs/
```

⚠️ **Warning**: This deletes all indexed logs!
