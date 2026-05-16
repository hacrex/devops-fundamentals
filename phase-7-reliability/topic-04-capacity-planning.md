# 📈 Topic 4: Capacity Planning

**Difficulty:** 🔴 Advanced | **Time:** ⏱️ 90 min


## Overview
Capacity planning ensures your infrastructure can handle current and future demand while optimizing costs and maintaining reliability.

## Key Concepts

### 1. Types of Capacity Planning

**Short-term:** Days to weeks (tactical)
**Medium-term:** Months (operational)
**Long-term:** Years (strategic)

### 2. Key Metrics to Track

| Metric | Description | Tool |
|--------|-------------|------|
| CPU Utilization | Processor usage | Prometheus |
| Memory Usage | RAM consumption | Node Exporter |
| Disk I/O | Storage throughput | iostat |
| Network Bandwidth | Data transfer rates | nload |
| Request Rate | Traffic volume | Load balancer logs |

### 3. Scaling Strategies

**Vertical Scaling:** Add more resources to existing servers
- Pros: Simple, no code changes
- Cons: Limited, single point of failure

**Horizontal Scaling:** Add more servers
- Pros: Unlimited, resilient
- Cons: Complex, requires stateless design

### 4. Auto-scaling Approaches

**Reactive:** Scale based on current metrics
```yaml
metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageValue: 70%
```

**Predictive:** Scale based on forecasts
- Use historical patterns
- Machine learning models
- Schedule-based scaling

### 5. Capacity Planning Process

1. **Measure:** Collect baseline metrics
2. **Model:** Create capacity models
3. **Forecast:** Predict future demand
4. **Plan:** Develop scaling strategy
5. **Test:** Validate with load tests
6. **Monitor:** Continuously track metrics

## Hands-On Exercises

### Exercise 1: Load Testing
```bash
# Install k6
sudo apt install k6

# Run load test
k6 run script.js
```

### Exercise 2: Kubernetes HPA
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageValue: 70%
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

1. Monitor leading indicators
2. Plan for peak + buffer (20-30%)
3. Test failure scenarios
4. Document capacity limits
5. Review quarterly
6. Automate scaling decisions

## Additional Resources
- [AWS Capacity Planning](https://aws.amazon.com/architecture/well-architected/reliability-pillar/)
- [Kubernetes Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
