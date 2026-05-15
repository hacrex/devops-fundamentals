# Topic 4: Kubernetes Pods and Deployments

## Introduction
Pods and Deployments are fundamental building blocks in Kubernetes for running applications.

## Pods

### What is a Pod?
- Smallest deployable unit in Kubernetes
- One or more containers sharing storage and network
- Containers in a pod share:
  - Same IP address and port space
  - Shared storage volumes
  - Same namespace
  - Can communicate via localhost

### Pod Lifecycle
```
Pending → Running → Succeeded/Failed
              ↓
           Terminated
```

### Basic Pod Example
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /health
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
```

### Multi-Container Pod (Sidecar Pattern)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-with-logger
spec:
  containers:
  - name: web
    image: nginx:1.21
    ports:
    - containerPort: 80
    volumeMounts:
    - name: logs
      mountPath: /var/log/nginx
  - name: logger
    image: busybox
    command: ['sh', '-c', 'tail -f /var/log/nginx/access.log']
    volumeMounts:
    - name: logs
      mountPath: /var/log/nginx
  volumes:
  - name: logs
    emptyDir: {}
```

### Common Pod Commands
```bash
# Create pod
kubectl apply -f pod.yaml

# List pods
kubectl get pods

# Get pod details
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>

# Execute command
kubectl exec -it <pod-name> -- /bin/bash

# Port forwarding
kubectl port-forward <pod-name> 8080:80

# Delete pod
kubectl delete pod <pod-name>
```

## Deployments

### What is a Deployment?
- Manages ReplicaSets and Pods
- Provides declarative updates
- Handles rolling updates and rollbacks
- Ensures desired state is maintained

### Basic Deployment Example
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Deployment Strategies

#### 1. Rolling Update (Default)
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 25%       # Can create 25% extra pods
    maxUnavailable: 25% # Can have 25% unavailable
```

#### 2. Recreate
```yaml
strategy:
  type: Recreate  # Kill all, then create new
```

#### 3. Blue-Green (Manual)
- Run two deployments simultaneously
- Switch traffic via Service selector

#### 4. Canary (Manual/Advanced)
- Gradually shift traffic to new version
- Use with service mesh or ingress

### Update Operations
```bash
# Update image
kubectl set image deployment/nginx-deployment nginx=nginx:1.22

# Check rollout status
kubectl rollout status deployment/nginx-deployment

# View rollout history
kubectl rollout history deployment/nginx-deployment

# Undo rollout
kubectl rollout undo deployment/nginx-deployment

# Undo to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=2

# Pause rollout
kubectl rollout pause deployment/nginx-deployment

# Resume rollout
kubectl rollout resume deployment/nginx-deployment
```

### Scaling Deployments
```bash
# Scale manually
kubectl scale deployment nginx-deployment --replicas=5

# Autoscale based on CPU
kubectl autoscale deployment nginx-deployment \
  --min=2 --max=10 --cpu-percent=80

# View HPA
kubectl get hpa
```

## Advanced Pod Features

### Init Containers
Run before main containers start:
```yaml
spec:
  initContainers:
  - name: init-db
    image: busybox
    command: ['sh', '-c', 'until nslookup db-service; do sleep 2; done']
  containers:
  - name: app
    image: myapp:latest
```

### Environment Variables
```yaml
containers:
- name: app
  image: myapp:latest
  env:
  - name: DATABASE_URL
    value: "postgresql://db:5432/mydb"
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: secret-key
  - name: POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: CONFIG_VALUE
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: config-key
```

### Affinity and Anti-Affinity
```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values: [ssd]
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: nginx
          topologyKey: kubernetes.io/hostname
```

### Tolerations
```yaml
spec:
  tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoSchedule"
```

## Hands-On Lab

### Exercise: Deploy a Web Application

1. Create deployment file:
```yaml
# web-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "50m"
            memory: "64Mi"
          limits:
            cpu: "100m"
            memory: "128Mi"
```

2. Apply and verify:
```bash
kubectl apply -f web-app-deployment.yaml
kubectl get deployments
kubectl get pods
kubectl describe deployment web-app
```

3. Scale the application:
```bash
kubectl scale deployment web-app --replicas=5
kubectl get pods
```

4. Update the image:
```bash
kubectl set image deployment/web-app nginx=nginx:1.22
kubectl rollout status deployment/web-app
```

5. Rollback if needed:
```bash
kubectl rollout undo deployment/web-app
```

## Best Practices

1. **Resource Limits**: Always set requests and limits
2. **Health Checks**: Implement liveness and readiness probes
3. **Labels**: Use meaningful labels for organization
4. **Replicas**: Run multiple replicas for availability
5. **Pod Disruption Budgets**: Protect against voluntary disruptions
6. **Security Context**: Run as non-root when possible
7. **Image Tags**: Use specific tags, avoid `latest`

## Troubleshooting

| Issue | Command | Solution |
|-------|---------|----------|
| Pod pending | `kubectl describe pod` | Check resources, node capacity |
| CrashLoopBackOff | `kubectl logs <pod>` | Fix application error |
| ImagePullBackOff | `kubectl describe pod` | Check image name, registry auth |
| OOMKilled | `kubectl top pod` | Increase memory limits |

## Next Steps
- Learn about Services for networking
- Study ConfigMaps and Secrets
- Explore StatefulSets for stateful applications

## Resources
- [Kubernetes Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
