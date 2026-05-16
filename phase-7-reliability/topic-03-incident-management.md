# 🚨 Topic 3: Incident Management

## Overview
Incident management is the process of identifying, analyzing, and resolving service disruptions to minimize impact on users and business.

## Key Concepts

### 1. Incident Lifecycle

```
Detection → Triage → Response → Resolution → Postmortem → Learning
```

### 2. Roles & Responsibilities

**Incident Commander:** Leads response efforts
**Communications Lead:** Manages stakeholder updates
**Tech Lead:** Coordinates technical resolution
**Scribe:** Documents timeline and actions

### 3. Severity Levels

| Severity | Impact | Response Time | Example |
|----------|--------|---------------|---------|
| SEV-1 | Complete outage | Immediate | Site down |
| SEV-2 | Major degradation | < 15 min | High error rate |
| SEV-3 | Minor impact | < 1 hour | Slow performance |
| SEV-4 | Minimal impact | Next business day | Bug fix needed |

### 4. Communication Templates

**Initial Alert:**
```
[SEV-2] Service Degradation - API Latency
Started: 2024-01-15 10:30 UTC
Impact: Increased API response times
Status: Investigating
Next update: 30 minutes
```

### 5. Postmortems

Blameless postmortem structure:
1. **Summary:** What happened
2. **Timeline:** Chronological events
3. **Root Cause:** Why it happened
4. **Action Items:** How to prevent recurrence
5. **Learnings:** What we learned

## Hands-On Exercises

### Exercise 1: Create Incident Runbook
```markdown
# Incident Runbook: Database Outage

## Detection
- Alert: Database connections exhausted
- Dashboard: Connection pool metrics

## Triage
1. Check database status
2. Review recent deployments
3. Check connection counts

## Response
1. Scale database if needed
2. Restart connection pool
3. Rollback recent changes

## Communication
- Update status page
- Notify stakeholders every 30 min
```

## Best Practices

1. Practice with game days
2. Maintain updated runbooks
3. Conduct blameless postmortems
4. Track action items to completion
5. Share learnings organization-wide

## Additional Resources
- [Incident Management Guide](https://sre.google/sre-book/managing-incidents/)
- [Blameless Postmortems](https://landing.google.com/sre/workbook/chapters/postmortem-culture/)
