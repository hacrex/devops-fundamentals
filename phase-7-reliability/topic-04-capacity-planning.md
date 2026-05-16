# 📈 Topic 4: Capacity Planning

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
