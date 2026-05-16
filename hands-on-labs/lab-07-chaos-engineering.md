# 🧪 Lab 7: Chaos Engineering with Chaos Mesh

## 🎯 Goal
Learn chaos engineering principles by injecting failures into a Kubernetes cluster using Chaos Mesh to test application resilience, identify weaknesses, and improve system reliability.

## 📋 Prerequisites
- Kubernetes cluster (v1.16+)
- kubectl installed and configured
- Helm 3.x installed
- Basic understanding of Kubernetes concepts
- Sample application deployed

⏱️ **Estimated Time:** 60 minutes  
📊 **Difficulty:** 🔴 Advanced

---

## What is Chaos Engineering?

Chaos Engineering is the discipline of experimenting on a system to build confidence in its capability to withstand turbulent conditions. It helps you:
- Identify weaknesses before they cause outages
- Test disaster recovery procedures
- Build resilient systems
- Improve incident response

### The Four Steps of Chaos Engineering
1. **Define Steady State** - What does normal look like?
2. **Hypothesize** - How will the system behave under stress?
3. **Inject Failures** - Introduce real-world events
4. **Learn & Improve** - Analyze results and fix issues

---

## Project Structure
```
chaos-lab/
├── app/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── app.py
├── chaos-experiments/
│   ├── pod-failure.yaml
│   ├── network-latency.yaml
│   ├── stress-test.yaml
│   ├── io-chaos.yaml
│   └── schedule.yaml
└── monitoring/
    └── dashboard.json
```

---

## Step 1: Deploy Sample Application

Create `app/deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: chaos-demo
  labels:
    app: demo-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
        - name: api
          image: nginx:alpine
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 256Mi
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 15
            periodSeconds: 20
        - name: sidecar
          image: busybox:latest
          command: ['sh', '-c', 'while true; do echo "Sidecar running"; sleep 30; done']
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
---
apiVersion: v1
kind: Namespace
metadata:
  name: chaos-demo
```

Apply the application:
```bash
kubectl apply -f app/deployment.yaml
kubectl wait --for=condition=available deployment/demo-app -n chaos-demo --timeout=2m
```

---

## Step 2: Install Chaos Mesh

```bash
# Create namespace
kubectl create namespace chaos-testing

# Add Helm repository
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm repo update

# Install Chaos Mesh
helm install chaos-mesh chaos-mesh/chaos-mesh \
  --namespace=chaos-testing \
  --set chaosDaemon.runtime=containerd \
  --set chaosDaemon.socket=/run/containerd/containerd.sock

# Wait for installation
kubectl wait --for=condition=available deployment --all -n chaos-testing --timeout=5m

# Verify installation
kubectl get pods -n chaos-testing
```

For Docker runtime, use:
```bash
helm install chaos-mesh chaos-mesh/chaos-mesh \
  --namespace=chaos-testing \
  --set chaosDaemon.runtime=docker \
  --set chaosDaemon.socket=/var/run/docker.sock
```

---

## Step 3: Grant Permissions

Create `rbac.yaml`:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: chaos-mesh-experiment
rules:
  - apiGroups: [""]
    resources: ["pods", "namespaces"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["chaos-mesh.org"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: chaos-admin
  namespace: chaos-testing
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: chaos-admin-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: chaos-mesh-experiment
subjects:
  - kind: ServiceAccount
    name: chaos-admin
    namespace: chaos-testing
```

Apply RBAC:
```bash
kubectl apply -f rbac.yaml
```

---

## Step 4: Experiment 1 - Pod Failure

Create `chaos-experiments/pod-failure.yaml`:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: PodChaos
metadata:
  name: pod-failure-example
  namespace: chaos-demo
spec:
  action: pod-failure
  mode: one
  duration: "30s"
  selector:
    namespaces:
      - chaos-demo
    labelSelectors:
      "app": "demo-app"
  scheduler:
    cron: "@every 2m"
```

Apply and observe:
```bash
# Apply the experiment
kubectl apply -f chaos-experiments/pod-failure.yaml

# Watch what happens
watch kubectl get pods -n chaos-demo

# Check Chaos Mesh status
kubectl get podchaos -n chaos-demo

# View events
kubectl describe podchaos pod-failure-example -n chaos-demo
```

**Expected Behavior:**
- One pod will fail every 2 minutes for 30 seconds
- Kubernetes should recreate the failed pod
- Application should remain available

---

## Step 5: Experiment 2 - Network Latency

Create `chaos-experiments/network-latency.yaml`:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: network-latency-example
  namespace: chaos-demo
spec:
  action: latency
  mode: all
  selector:
    namespaces:
      - chaos-demo
    labelSelectors:
      "app": "demo-app"
  latency: "100ms"
  correlation: "25"
  jitter: "10ms"
  duration: "60s"
  direction: both
```

Apply and test:
```bash
# Apply network chaos
kubectl apply -f chaos-experiments/network-latency.yaml

# Test latency from inside a pod
POD_NAME=$(kubectl get pods -n chaos-demo -l app=demo-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n chaos-demo $POD_NAME -- ping -c 5 google.com

# Check network chaos status
kubectl get networkchaos -n chaos-demo

# Clean up
kubectl delete -f chaos-experiments/network-latency.yaml
```

**Expected Behavior:**
- All pods experience 100ms latency (+/- 10ms jitter)
- API responses will be slower
- Timeout configurations will be tested

---

## Step 6: Experiment 3 - CPU Stress

Create `chaos-experiments/stress-test.yaml`:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: StressChaos
metadata:
  name: cpu-stress-example
  namespace: chaos-demo
spec:
  selector:
    namespaces:
      - chaos-demo
    labelSelectors:
      "app": "demo-app"
  mode: all
  duration: "60s"
  stressors:
    cpu:
      workers: 2
      load: 80
  scheduler:
    cron: "@every 5m"
```

Apply and monitor:
```bash
# Apply stress test
kubectl apply -f chaos-experiments/stress-test.yaml

# Monitor CPU usage
kubectl top pods -n chaos-demo

# Watch for HPA scaling (if enabled)
kubectl get hpa -n chaos-demo -w

# Check stress chaos status
kubectl get stresschaos -n chaos-demo
```

**Expected Behavior:**
- Pods consume 80% CPU on 2 workers
- Horizontal Pod Autoscaler may trigger (if configured)
- Performance degradation observable

---

## Step 7: Experiment 4 - IO Chaos

Create `chaos-experiments/io-chaos.yaml`:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: IOChaos
metadata:
  name: io-latency-example
  namespace: chaos-demo
spec:
  selector:
    namespaces:
      - chaos-demo
    labelSelectors:
      "app": "demo-app"
  mode: one
  volumePath: /var/log
  path: "/var/log/*"
  delay: "100ms"
  percent: 50
  duration: "30s"
  attrs:
    - READ
    - WRITE
```

Apply and observe:
```bash
# Apply IO chaos
kubectl apply -f chaos-experiments/io-chaos.yaml

# Generate some IO activity
POD_NAME=$(kubectl get pods -n chaos-demo -l app=demo-app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n chaos-demo $POD_NAME -- sh -c 'for i in {1..10}; do echo "test $i" >> /var/log/test.log; done'

# Check IO chaos status
kubectl get iochaos -n chaos-demo
```

**Expected Behavior:**
- 50% of IO operations delayed by 100ms
- Log writes will be slower
- Applications with heavy IO will be impacted

---

## Step 8: Scheduled Chaos Experiments

Create `chaos-experiments/schedule.yaml`:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: Schedule
metadata:
  name: scheduled-pod-kill
  namespace: chaos-demo
spec:
  schedule: "@every 10m"
  historyLimit: 5
  concurrencyPolicy: Forbid
  startingDeadlineSeconds: 0
  type: PodChaos
  podChaos:
    action: pod-kill
    mode: random-max-percent
    selector:
      namespaces:
        - chaos-demo
      labelSelectors:
        "app": "demo-app"
    value: "50"
    duration: "30s"
```

Apply scheduled experiment:
```bash
# Apply schedule
kubectl apply -f chaos-experiments/schedule.yaml

# List scheduled experiments
kubectl get schedule -n chaos-demo

# View next execution time
kubectl describe schedule scheduled-pod-kill -n chaos-demo

# Pause schedule (without deleting)
kubectl patch schedule scheduled-pod-kill -n chaos-demo -p '{"spec":{"suspend":true}}'

# Resume schedule
kubectl patch schedule scheduled-pod-kill -n chaos-demo -p '{"spec":{"suspend":false}}'
```

---

## Step 9: Access Chaos Dashboard

Chaos Mesh provides a web UI:

```bash
# Port forward to dashboard
kubectl port-forward svc/chaos-dashboard -n chaos-testing 23333:23333

# Access at http://localhost:23333
```

**Dashboard Features:**
- Visual experiment creation
- Real-time status monitoring
- Event timeline
- Experiment history

---

## 🔍 Try It Yourself Exercises

### Exercise 1: Create Custom Workflow
Combine multiple chaos experiments in sequence:
```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: Workflow
metadata:
  name: resilience-test
  namespace: chaos-demo
spec:
  entry: entry
  templates:
    - name: entry
      templateType: Serial
      deadline: 3600
      children:
        - network-latency
        - pod-failure
        - cpu-stress
    
    - name: network-latency
      templateType: NetworkChaos
      deadline: 120
      networkChaos:
        # ... network config
    
    - name: pod-failure
      templateType: PodChaos
      deadline: 60
      podChaos:
        # ... pod config
```

### Exercise 2: Test Database Resilience
1. Deploy a database (PostgreSQL/MySQL)
2. Inject network partition between app and DB
3. Verify connection pooling and retry logic
4. Measure recovery time

### Exercise 3: Multi-Zone Failure Simulation
1. Label nodes by availability zone
2. Kill all pods in one zone
3. Verify cross-zone failover
4. Test data consistency

---

## ⚠️ Common Mistakes to Avoid

1. **Running in Production Without Testing**: Always test chaos experiments in non-prod first
2. **No Monitoring**: Ensure observability is in place before injecting failures
3. **Too Aggressive**: Start small, increase blast radius gradually
4. **Ignoring Blast Radius**: Use appropriate mode (one, all, fixed-percent, random-max-percent)
5. **No Rollback Plan**: Know how to stop experiments quickly
6. **Not Informing Team**: Coordinate chaos experiments with your team

---

## 🛑 Emergency Stop Commands

```bash
# Stop all chaos experiments in namespace
kubectl delete podchaos --all -n chaos-demo
kubectl delete networkchaos --all -n chaos-demo
kubectl delete stresschaos --all -n chaos-demo
kubectl delete iochaos --all -n chaos-demo
kubectl delete schedule --all -n chaos-demo

# Or delete all chaos resources at once
kubectl delete all --all -n chaos-demo

# Uninstall Chaos Mesh completely
helm uninstall chaos-mesh -n chaos-testing
kubectl delete namespace chaos-testing
```

---

## 🌍 Real-World Scenarios

### Scenario 1: E-commerce Platform
- **Goal**: Ensure checkout works during infrastructure failures
- **Experiments**: 
  - Kill payment service pods
  - Add latency to inventory API
  - Simulate database connection failures
- **Metrics**: Order completion rate, error rates

### Scenario 2: Microservices Architecture
- **Goal**: Test circuit breakers and retries
- **Experiments**:
  - Network partitions between services
  - Random pod failures
  - CPU starvation
- **Metrics**: Request latency, circuit breaker trips

### Scenario 3: Data Pipeline
- **Goal**: Verify data integrity during failures
- **Experiments**:
  - IO delays on storage
  - Pod kills during processing
  - Network timeouts
- **Metrics**: Data loss, duplicate processing

---

## ✅ What You Learned
- Installing and configuring Chaos Mesh
- Creating pod failure experiments
- Injecting network latency and partitions
- Running CPU and IO stress tests
- Scheduling recurring chaos experiments
- Using Chaos Dashboard for visualization
- Best practices for chaos engineering
- Emergency stop procedures

---

## 📚 Additional Resources
- [Chaos Mesh Documentation](https://chaos-mesh.org/docs/)
- [Principles of Chaos Engineering](https://principlesofchaos.org/)
- [Chaos Engineering Community](https://chaosengineering.community/)
- [Gremlin Tutorials](https://www.gremlin.com/community/tutorials/)
- [Kubernetes Failure Stories](https://kubernetes.io/blog/2019/03/01/kubernetes-failure-stories/)

---

## 🧹 Cleanup

```bash
# Remove all chaos experiments
kubectl delete -f chaos-experiments/

# Delete demo application
kubectl delete namespace chaos-demo

# Uninstall Chaos Mesh (optional)
helm uninstall chaos-mesh -n chaos-testing
kubectl delete namespace chaos-testing

# Remove local files
rm -rf chaos-lab/
```

---

## 📝 Chaos Engineering Report Template

After each experiment, document:

```markdown
# Chaos Experiment Report

## Experiment Name
[Name]

## Date
[Date]

## Hypothesis
[What did you expect to happen?]

## Configuration
[Experiment YAML or description]

## Observations
- [What actually happened?]
- [Metrics affected]
- [Unexpected behaviors]

## Impact
- Duration: [X minutes]
- Affected services: [List]
- User impact: [None/Low/Medium/High]

## Learnings
1. [Learning 1]
2. [Learning 2]

## Action Items
- [ ] [Action item 1]
- [ ] [Action item 2]

## Next Steps
[What experiments to run next?]
```
