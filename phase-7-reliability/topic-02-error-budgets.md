# 💰 Topic 2: Error Budgets

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 60 min


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

1. Define clear budget policies
2. Implement burn rate alerts
3. Share budget status with team
4. Adjust SLOs based on learnings
5. Use budgets for release decisions

## Additional Resources
- [Google SRE Workbook](https://sre.google/workbook/)
- [Error Budgets in Practice](https://landing.google.com/sre/workbook/chapters/error-budgets/)
