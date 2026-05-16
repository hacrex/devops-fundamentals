# ⚡ Topic 2: GitHub Actions

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 90 min


## Overview
GitHub Actions is a CI/CD platform that allows you to automate your build, test, and deployment pipeline directly from your GitHub repository.

## Key Concepts

### 1. Core Components

**Workflow:** Automated process defined in YAML
**Event:** Trigger that starts a workflow (push, PR, schedule)
**Job:** Set of steps that execute on same runner
**Step:** Individual task or action
**Action:** Reusable unit of code
**Runner:** Server that executes workflows

### 2. Workflow Structure

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: npm install && npm run build
      - name: Test
        run: npm test
```

### 3. Common Use Cases

- Automated testing
- Docker image building
- Deployment to cloud
- Code quality checks
- Release automation

## Hands-On Exercises

### Exercise 1: Create Basic Workflow
```bash
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'YAML'
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: echo "Hello GitHub Actions"
YAML
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

1. Use specific versions for actions
2. Cache dependencies
3. Use secrets for sensitive data
4. Test workflows locally
5. Keep workflows modular

## Additional Resources
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Awesome GitHub Actions](https://github.com/sdras/awesome-actions)
