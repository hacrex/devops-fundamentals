# 🚀 Topic 3: ArgoCD

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

## Best Practices

1. Store all manifests in Git
2. Use Helm or Kustomize for templating
3. Implement RBAC properly
4. Monitor sync status
5. Set up notifications

## Additional Resources
- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [GitOps Principles](https://www.gitops.tech/)
