# 🛠️ Troubleshooting Guide

This guide covers common issues and solutions for the DevOps Fundamentals labs.

---

## Table of Contents
- [Docker Issues](#docker-issues)
- [Kubernetes Issues](#kubernetes-issues)
- [Network Issues](#network-issues)
- [Permission Problems](#permission-problems)
- [Resource Exhaustion](#resource-exhaustion)
- [CI/CD Pipeline Failures](#cicd-pipeline-failures)
- [Terraform Issues](#terraform-issues)
- [Monitoring Stack Issues](#monitoring-stack-issues)

---

## Docker Issues

### Problem: Cannot connect to Docker daemon

**Symptoms:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

**Solutions:**
```bash
# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (avoid using sudo)
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker info
```

---

### Problem: Container exits immediately

**Symptoms:**
```
Container keeps restarting or exits with code 0/1
```

**Solutions:**
```bash
# Check container logs
docker logs <container-name>

# Inspect container
docker inspect <container-name>

# Run interactively to debug
docker run -it --entrypoint /bin/sh <image-name>

# Check health check status
docker ps --format "table {{.Names}}\t{{.Status}}"
```

**Common Causes:**
- Missing environment variables
- Application crash on startup
- Port already in use
- Volume mount permissions

---

### Problem: Port already in use

**Symptoms:**
```
Error starting userland proxy: listen tcp 0.0.0.0:8080: bind: address already in use
```

**Solutions:**
```bash
# Find process using the port
sudo lsof -i :8080
sudo netstat -tulpn | grep :8080

# Kill the process
sudo kill -9 <PID>

# Or use a different port
docker run -p 8081:80 <image>
```

---

## Kubernetes Issues

### Problem: Pods stuck in Pending state

**Symptoms:**
```
NAME       READY   STATUS    RESTARTS   AGE
myapp      0/1     Pending   0          5m
```

**Solutions:**
```bash
# Check why pod is pending
kubectl describe pod <pod-name> -n <namespace>

# Common causes and fixes:

# 1. Insufficient resources
kubectl top nodes
kubectl describe node <node-name>

# 2. No matching nodes for selector/taints
kubectl get nodes --show-labels
kubectl taint nodes <node-name> <taint>-

# 3. PersistentVolume not available
kubectl get pv,pvc

# 4. Resource quotas exceeded
kubectl describe quota -n <namespace>
```

---

### Problem: CrashLoopBackOff

**Symptoms:**
```
NAME       READY   STATUS             RESTARTS   AGE
myapp      0/1     CrashLoopBackOff   5          10m
```

**Solutions:**
```bash
# View logs from current and previous instance
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous

# Describe pod for events
kubectl describe pod <pod-name> -n <namespace>

# Check readiness/liveness probes
kubectl get pod <pod-name> -n <namespace> -o yaml | grep -A 10 probe

# Exec into container (if possible)
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Common fixes:
# - Fix application errors
# - Adjust probe timings
# - Increase memory/CPU limits
# - Check ConfigMaps and Secrets exist
```

---

### Problem: ImagePullBackOff / ErrImagePull

**Symptoms:**
```
NAME       READY   STATUS             RESTARTS   AGE
myapp      0/1     ImagePullBackOff   0          2m
```

**Solutions:**
```bash
# Describe pod for detailed error
kubectl describe pod <pod-name> -n <namespace>

# Check image name and tag
kubectl get pod <pod-name> -n <namespace> -o yaml | grep image

# Verify image exists
docker pull <image-name>

# For private registries, check imagePullSecrets
kubectl get secrets -n <namespace>
kubectl get serviceaccount <sa-name> -n <namespace> -o yaml

# Create image pull secret if needed
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<user> \
  --docker-password=<password> \
  -n <namespace>
```

---

### Problem: Service not accessible

**Symptoms:**
```
curl: (7) Failed to connect to <service-ip> port <port>: Connection refused
```

**Solutions:**
```bash
# Check service exists and has endpoints
kubectl get svc <service-name> -n <namespace>
kubectl get endpoints <service-name> -n <namespace>

# Verify pods are ready
kubectl get pods -n <namespace> -l app=<label>

# Test from inside cluster
kubectl run test --rm -it --image=busybox --restart=Never -- nslookup <service-name>
kubectl run test --rm -it --image=busybox --restart=Never -- wget -O- http://<service-name>:<port>

# Check network policies
kubectl get networkpolicy -n <namespace>

# For NodePort/LoadBalancer, check external IP
kubectl get svc <service-name> -n <namespace> -o wide
```

---

## Network Issues

### Problem: DNS resolution failing in pods

**Symptoms:**
```
nslookup: can't resolve 'kubernetes.default'
```

**Solutions:**
```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Check CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns

# Test DNS from pod
kubectl run dns-test --rm -it --image=busybox --restart=Never -- nslookup kubernetes.default

# Check /etc/resolv.conf in pod
kubectl exec <pod-name> -- cat /etc/resolv.conf

# Restart CoreDNS
kubectl rollout restart deployment/coredns -n kube-system
```

---

### Problem: Cannot connect to external services

**Symptoms:**
```
Connection timeout to external API/database
```

**Solutions:**
```bash
# Check egress rules
kubectl get networkpolicy -n <namespace>

# Test connectivity
kubectl run test --rm -it --image=busybox --restart=Never -- ping <external-host>
kubectl run test --rm -it --image=busybox --restart=Never -- telnet <host> <port>

# Check NAT gateway / firewall rules (cloud providers)
# AWS: Check security groups and NACLs
# GCP: Check firewall rules
# Azure: Check NSGs

# Verify proxy settings if behind corporate firewall
kubectl exec <pod-name> -- env | grep -i proxy
```

---

## Permission Problems

### Problem: Permission denied accessing files

**Symptoms:**
```
Error: open /var/log/app.log: permission denied
```

**Solutions:**
```bash
# Check volume mount permissions
ls -la /path/to/volume

# Set proper fsGroup in pod security context
securityContext:
  fsGroup: 1000

# Or run as root (not recommended for production)
securityContext:
  runAsUser: 0

# Fix volume permissions
chmod -R 755 /path/to/volume
chown -R 1000:1000 /path/to/volume
```

---

### Problem: RBAC access denied

**Symptoms:**
```
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:..." cannot list resource "pods"
```

**Solutions:**
```bash
# Check service account
kubectl get sa <sa-name> -n <namespace>

# Check role bindings
kubectl get rolebinding,clusterrolebinding -n <namespace>

# Describe the binding for details
kubectl describe rolebinding <binding-name> -n <namespace>

# Create missing role
kubectl create role <role-name> \
  --verb=get,list,watch \
  --resource=pods,deployments \
  -n <namespace>

# Bind role to service account
kubectl create rolebinding <binding-name> \
  --role=<role-name> \
  --serviceaccount=<namespace>:<sa-name>
```

---

## Resource Exhaustion

### Problem: Out of Memory (OOMKilled)

**Symptoms:**
```
NAME       READY   STATUS      RESTARTS   AGE
myapp      0/1     OOMKilled   3          5m
```

**Solutions:**
```bash
# Check memory usage
kubectl top pods -n <namespace>

# Increase memory limits
resources:
  requests:
    memory: "256Mi"
  limits:
    memory: "512Mi"

# Check for memory leaks in application
kubectl logs <pod-name> --previous

# Monitor node memory
kubectl top nodes

# If node is out of memory, drain and cordon
kubectl cordon <node-name>
kubectl drain <node-name> --ignore-daemonsets
```

---

### Problem: CPU throttling

**Symptoms:**
```
Application responding slowly
High CPU wait times
```

**Solutions:**
```bash
# Check CPU usage
kubectl top pods -n <namespace>

# Increase CPU limits
resources:
  requests:
    cpu: "500m"
  limits:
    cpu: "1000m"

# Check node CPU pressure
kubectl describe node <node-name> | grep -A 5 "Allocated resources"

# Scale horizontally instead of vertically
kubectl scale deployment <deployment-name> --replicas=3
```

---

### Problem: Disk space full

**Symptoms:**
```
No space left on device
Failed to pull image: no space left on device
```

**Solutions:**
```bash
# Check disk usage on node
df -h

# Clean up unused images (on node)
docker image prune -a

# Remove old containers
docker container prune

# Clean up unused volumes
docker volume prune

# In Kubernetes, clean up old logs
kubectl du -a -n <namespace>

# Rotate logs
# Add log rotation to container logging configuration
```

---

## CI/CD Pipeline Failures

### Problem: GitHub Actions workflow fails

**Symptoms:**
```
Error: Process completed with exit code 1
```

**Solutions:**
```yaml
# Enable debug logging
# Add to workflow:
env:
  ACTIONS_RUNNER_DEBUG: true
  ACTIONS_STEP_DEBUG: true

# Common fixes:

# 1. Checkout issue
- uses: actions/checkout@v4
  with:
    fetch-depth: 0

# 2. Dependency cache issue
- name: Clear cache
  run: rm -rf node_modules package-lock.json

# 3. Docker authentication
- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}

# 4. Timeout issues
timeout-minutes: 30
```

---

### Problem: ArgoCD sync failed

**Symptoms:**
```
ComparisonError: rpc error: code = Unknown desc = ...
SyncFailed: ...
```

**Solutions:**
```bash
# Check application status
argocd app get <app-name>

# View sync logs
argocd app logs <app-name>

# Common fixes:

# 1. Refresh application
argocd app get <app-name> --refresh

# 2. Force sync
argocd app sync <app-name> --force

# 3. Check repository connection
argocd repo list
argocd repo add <repo-url> --username <user> --password <pass>

# 4. Validate manifests locally
helm template <chart-path> -f <values-file>
kubectl apply --dry-run=client -f <manifest>

# 5. Check cluster credentials
argocd cluster list
```

---

## Terraform Issues

### Problem: State lock error

**Symptoms:**
```
Error: Error locking state: Error acquiring the state lock
```

**Solutions:**
```bash
# Wait for lock to be released (usually automatic)

# Force unlock (use with caution!)
terraform force-unlock <LOCK_ID>

# Check who has the lock
# For S3 backend, check DynamoDB table

# Initialize again
terraform init -reconfigure

# Best practice: Use remote backends with locking
```

---

### Problem: Provider version conflicts

**Symptoms:**
```
Error: Failed to install provider
```

**Solutions:**
```bash
# Update provider versions
terraform init -upgrade

# Specify exact versions in required_providers
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

# Clear provider cache
rm -rf .terraform/
rm .terraform.lock.hcl
terraform init
```

---

### Problem: Resource already exists

**Symptoms:**
```
Error: creating EC2 Instance: InvalidParameterValue: Resource already exists
```

**Solutions:**
```bash
# Import existing resource
terraform import <resource_type>.<resource_name> <resource_id>

# Example:
terraform import aws_instance.web i-1234567890abcdef0

# Or remove from state and recreate
terraform state rm <resource_type>.<resource_name>
terraform apply

# Always run plan first to see what will happen
terraform plan
```

---

## Monitoring Stack Issues

### Problem: Prometheus not scraping targets

**Symptoms:**
```
Target status: DOWN
```

**Solutions:**
```bash
# Check Prometheus targets UI: http://localhost:9090/targets

# Verify target is reachable
curl http://<target-ip>:<port>/metrics

# Check Prometheus config
kubectl get configmap prometheus-config -n monitoring -o yaml

# Common fixes:
# 1. Wrong service discovery config
# 2. Network policy blocking access
# 3. Target not exposing /metrics endpoint
# 4. Authentication required

# Reload Prometheus config
curl -X POST http://localhost:9090/-/reload
```

---

### Problem: Grafana dashboards not loading

**Symptoms:**
```
Dashboard shows "Panel loading..." indefinitely
```

**Solutions:**
```bash
# Check data source connection
# Grafana UI → Configuration → Data sources → Test

# Check browser console for errors (F12)

# Verify Prometheus is accessible from Grafana
kubectl exec -it <grafana-pod> -- curl http://prometheus:9090/-/healthy

# Check Grafana logs
kubectl logs <grafana-pod> -n monitoring

# Restart Grafana
kubectl rollout restart deployment/grafana -n monitoring
```

---

### Problem: Elasticsearch cluster health RED/YELLOW

**Symptoms:**
```
cluster_health: red/yellow
unassigned_shards: > 0
```

**Solutions:**
```bash
# Check cluster health
curl -u elastic:<password> http://localhost:9200/_cluster/health?pretty

# View unassigned shards reason
curl -u elastic:<password> http://localhost:9200/_cluster/allocation/explain?pretty

# Common fixes:

# 1. Not enough nodes for replicas
# Reduce replica count or add nodes
PUT /_all/_settings
{
  "index.number_of_replicas": 0
}

# 2. Disk space low
# Check disk usage
GET /_cat/allocation?v

# 3. Master node election issues
# Check node roles
GET /_cat/nodes?v&h=name,node.role,master

# 4. Increase heap size if needed
# Edit elasticsearch.yml or environment variables
```

---

## Quick Diagnostic Commands

### Docker Diagnostics
```bash
docker info
docker ps -a
docker images
docker system df
docker inspect <container>
docker logs <container>
```

### Kubernetes Diagnostics
```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A -o wide
kubectl top nodes
kubectl top pods -A
kubectl describe node <node-name>
kubectl get events -A --sort-by='.lastTimestamp'
```

### Network Diagnostics
```bash
ping <host>
traceroute <host>
nslookup <host>
curl -v http://<host>:<port>
telnet <host> <port>
netstat -tulpn
ss -tulpn
```

### Resource Diagnostics
```bash
df -h
free -m
top
htop
iotop
vmstat 1
```

---

## Getting Help

If you're still stuck:

1. **Check Logs**: Always check logs first (`docker logs`, `kubectl logs`)
2. **Describe Resources**: Get detailed info (`kubectl describe`, `docker inspect`)
3. **Search Errors**: Copy exact error message to search engine
4. **Documentation**: Check official docs for the tool/service
5. **Community**: Ask in relevant Slack/Discord communities
6. **GitHub Issues**: Search for similar issues in project repositories

### Useful Resources
- [Kubernetes Troubleshooting](https://kubernetes.io/docs/tasks/debug/)
- [Docker Troubleshooting](https://docs.docker.com/config/daemon/troubleshoot/)
- [Prometheus Debugging](https://prometheus.io/docs/operating/debugging/)
- [Terraform Debugging](https://developer.hashicorp.com/terraform/internals/debugging/)

---

## Prevention Tips

1. **Always set resource limits** to prevent resource exhaustion
2. **Use health checks** to detect issues early
3. **Implement proper logging** for easier debugging
4. **Test in non-production** before deploying changes
5. **Monitor everything** - you can't fix what you can't see
6. **Document common issues** specific to your applications
7. **Keep tools updated** to benefit from bug fixes
8. **Use infrastructure as code** for reproducible environments
