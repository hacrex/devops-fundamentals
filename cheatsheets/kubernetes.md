# Kubernetes Cheatsheet

## Quick Reference for kubectl Commands

### Cluster Information
```bash
kubectl cluster-info                    # Display cluster info
kubectl version                         # Show client/server versions
kubectl config view                     # View kubeconfig
kubectl config current-context          # Show current context
kubectl get nodes                       # List all nodes
kubectl top nodes                       # Show node resource usage
```

### Pods
```bash
kubectl get pods                        # List pods
kubectl get pods -n <namespace>         # List pods in namespace
kubectl get pods -o wide                # More details
kubectl describe pod <pod-name>         # Pod details
kubectl logs <pod-name>                 # View logs
kubectl logs -f <pod-name>              # Follow logs
kubectl exec -it <pod-name> -- bash     # Execute in pod
kubectl port-forward <pod> 8080:80      # Port forward
kubectl delete pod <pod-name>           # Delete pod
kubectl delete pod --all                # Delete all pods
```

### Deployments
```bash
kubectl get deployments                 # List deployments
kubectl describe deployment <name>      # Deployment details
kubectl create deployment <name> --image=<image>
kubectl scale deployment <name> --replicas=3
kubectl set image deployment/<name> <container>=<image>
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>
kubectl rollout history deployment/<name>
```

### Services
```bash
kubectl get services                    # List services
kubectl describe service <name>         # Service details
kubectl expose deployment <name> --port=80 --type=LoadBalancer
kubectl delete service <name>
```

### ConfigMaps & Secrets
```bash
kubectl get configmaps                  # List configmaps
kubectl create configmap <name> --from-literal=key=value
kubectl get secrets                     # List secrets
kubectl create secret generic <name> --from-literal=key=value
kubectl create secret tls <name> --cert=tls.crt --key=tls.key
```

### Namespaces
```bash
kubectl get namespaces                  # List namespaces
kubectl create namespace <name>
kubectl delete namespace <name>
kubectl config set-context --current --namespace=<name>
```

### Debugging
```bash
kubectl get events --sort-by='.lastTimestamp'
kubectl describe pod <pod> | grep -A 10 Events
kubectl logs <pod> --previous           # Previous instance logs
kubectl debug -it <pod> --image=busybox
```

### Labels & Selectors
```bash
kubectl get pods -l app=myapp
kubectl label pod <pod> env=prod
kubectl annotate pod <pod> description="My app"
```

### Resources
```bash
kubectl api-resources                   # All API resources
kubectl explain pod                     # Resource documentation
kubectl explain deployment.spec
```

### Apply & Delete
```bash
kubectl apply -f file.yaml              # Apply configuration
kubectl apply -f directory/             # Apply all in directory
kubectl delete -f file.yaml             # Delete from file
kubectl replace --force -f file.yaml    # Force replace
```

### Copy Files
```bash
kubectl cp <pod>:<path> <local-path>    # Copy from pod
kubectl cp <local-path> <pod>:<path>    # Copy to pod
```

### Watch Changes
```bash
kubectl get pods -w                     # Watch pods
kubectl get events -w                   # Watch events
```

### JSONPath
```bash
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{.items[0].status.podIP}'
```

### Common Issues
```bash
# Pod stuck in Pending
kubectl describe pod <pod>              # Check events
kubectl get nodes                       # Check node capacity

# CrashLoopBackOff
kubectl logs <pod> --previous           # Check previous logs
kubectl describe pod <pod>              # Check exit code

# ImagePullBackOff
kubectl describe pod <pod>              # Check error message
kubectl get secrets                     # Check registry auth

# OOMKilled
kubectl top pod                         # Check memory usage
kubectl describe pod <pod>              # Check limits
```
