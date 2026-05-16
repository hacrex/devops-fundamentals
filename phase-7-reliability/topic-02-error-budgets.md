# 💰 Topic 2: Error Budgets

## Overview
Error budgets quantify how much unreliability a service can tolerate before violating its SLO, enabling data-driven decisions about reliability vs. feature development.

## Key Concepts

### 1. What is an Error Budget?

The acceptable amount of failure or unavailability within a specific period.

**Formula:** `Error Budget = 1 - SLO`

### 2. Calculation Examples

| SLO | Error Budget | Monthly Downtime |
|-----|--------------|------------------|
| 99% | 1% | ~7.3 hours |
| 99.9% | 0.1% | ~43 minutes |
| 99.95% | 0.05% | ~22 minutes |
| 99.99% | 0.01% | ~4 minutes |

### 3. Budget Policies

**When budget remains:**
- Ship features freely
- Take calculated risks
- Experiment with changes

**When budget depleted:**
- Freeze feature releases
- Focus on reliability
- Require extra approval for changes

### 4. Burn Rate Monitoring

Track how fast you're consuming your error budget:

```
Burn Rate = (Error Rate) / (Allowed Error Rate)
```

Alert thresholds:
- **2x burn rate:** Warning - budget lasts 15 days
- **5x burn rate:** Critical - budget lasts 6 days
- **10x burn rate:** Emergency - budget lasts 3 days

## Hands-On Exercises

### Exercise 1: Calculate Error Budget
```python
def calculate_error_budget(slo_percentage, period_days):
    error_budget = 1 - (slo_percentage / 100)
    total_minutes = period_days * 24 * 60
    allowed_downtime = total_minutes * error_budget
    return allowed_downtime

# Example: 99.9% SLO over 30 days
print(calculate_error_budget(99.9, 30))  # ~43.2 minutes
```

## Best Practices

1. Define clear budget policies
2. Implement burn rate alerts
3. Share budget status with team
4. Adjust SLOs based on learnings
5. Use budgets for release decisions

## Additional Resources
- [Google SRE Workbook](https://sre.google/workbook/)
- [Error Budgets in Practice](https://landing.google.com/sre/workbook/chapters/error-budgets/)
