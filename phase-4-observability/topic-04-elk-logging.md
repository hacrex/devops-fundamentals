# 📝 Topic 4: Logging with ELK Stack

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 90 min


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
