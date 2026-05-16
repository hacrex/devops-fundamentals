# ⚡ Topic 2: GitHub Actions

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

## Best Practices

1. Use specific versions for actions
2. Cache dependencies
3. Use secrets for sensitive data
4. Test workflows locally
5. Keep workflows modular

## Additional Resources
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Awesome GitHub Actions](https://github.com/sdras/awesome-actions)
