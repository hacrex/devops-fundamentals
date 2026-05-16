# 🚀 Topic 3: ArgoCD

**Difficulty:** 🔴 Advanced | **Time:** ⏱️ 90 min


## Overview
ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes that continuously monitors running applications and compares their state against the desired state in Git.

## Key Concepts

### 1. GitOps Principles

- **Declarative:** Desired state in Git
- **Versioned:** All changes tracked
- **Automated:** Sync automatically or manually
- **Self-healing:** Drift detection and correction

### 2. Architecture

```
Git Repo → ArgoCD → Kubernetes Cluster
   ↑           ↓
   └─────── Status
```

### 3. Core Components

**Application:** Kubernetes resource definition
**Repository:** Git repo with manifests
**Cluster:** Target Kubernetes cluster
**Project:** Logical grouping of applications

### 4. Deployment Strategies

- **Auto-sync:** Automatic deployment on git push
- **Manual sync:** Approve changes before deploy
- **Blue-green:** Switch between versions
- **Canary:** Gradual rollout

## Hands-On Exercises

### Exercise 1: Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
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

1. Store all manifests in Git
2. Use Helm or Kustomize for templating
3. Implement RBAC properly
4. Monitor sync status
5. Set up notifications

## Additional Resources
- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [GitOps Principles](https://www.gitops.tech/)
