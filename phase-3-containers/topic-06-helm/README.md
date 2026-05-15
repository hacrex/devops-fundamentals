# Topic 6: Helm - Kubernetes Package Manager

## Introduction
Helm is the package manager for Kubernetes that helps you define, install, and upgrade complex Kubernetes applications using Charts.

## Key Concepts

### What is Helm?
- Package manager for Kubernetes (like apt/yum for Linux)
- Uses Charts to define applications
- Manages releases and versions
- Simplifies complex deployments

### Core Components
- **Chart**: Package of pre-configured Kubernetes resources
- **Config**: Configuration information merged into chart
- **Release**: Running instance of a chart
- **Repository**: Place where charts are stored and shared

## Chart Structure

```
my-chart/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration values
├── values-prod.yaml    # Production overrides
├── charts/             # Sub-charts (dependencies)
├── templates/          # Kubernetes manifests templates
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── ingress.yaml
└── README.md
```

### Chart.yaml Example
```yaml
apiVersion: v2
name: myapp
description: A Helm chart for MyApp
type: application
version: 1.0.0
appVersion: "2.0.0"
keywords:
  - web
  - api
maintainers:
  - name: DevOps Team
    email: devops@example.com
dependencies:
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
```

### values.yaml Example
```yaml
replicaCount: 3

image:
  repository: myapp
  tag: "latest"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

ingress:
  enabled: true
  host: myapp.example.com
```

## Essential Commands

```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Search for charts
helm search repo nginx

# Install chart
helm install my-release bitnami/nginx

# List releases
helm list

# Check status
helm status my-release

# Upgrade release
helm upgrade my-release bitnami/nginx --values values-prod.yaml

# Rollback
helm rollback my-release 1

# Uninstall
helm uninstall my-release

# Create new chart
helm create my-chart

# Package chart
helm package my-chart

# Install with custom values
helm install my-app ./my-chart -f values-prod.yaml

# Dry run
helm install my-app ./my-chart --dry-run --debug

# Template rendering
helm template my-app ./my-chart
```

## Creating Your First Chart

### Step 1: Create Chart
```bash
helm create my-web-app
cd my-web-app
```

### Step 2: Customize values.yaml
```yaml
replicaCount: 2

image:
  repository: nginx
  tag: "1.21"
  pullPolicy: IfNotPresent

service:
  type: LoadBalancer
  port: 80

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

### Step 3: Install and Test
```bash
helm install web-app ./my-web-app
helm list
kubectl get pods
```

### Step 4: Upgrade
```bash
helm upgrade web-app ./my-web-app --set replicaCount=3
helm history web-app
```

## Best Practices

1. **Version Control**: Store charts in Git repositories
2. **Semantic Versioning**: Follow semver for chart versions
3. **Values Files**: Separate configs per environment
4. **Documentation**: Document all configurable values
5. **Testing**: Use helm lint and helm test
6. **Dependencies**: Pin dependency versions
7. **Security**: Scan charts for vulnerabilities

## Advanced Features

### Conditional Dependencies
```yaml
# Chart.yaml
dependencies:
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: postgresql.enabled
    tags:
      - database

# values.yaml
postgresql:
  enabled: true
```

### Hooks
```yaml
# templates/hooks.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pre-install-job
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "-5"
spec:
  template:
    spec:
      containers:
      - name: migration
        image: myapp:migrate
      restartPolicy: Never
```

### Tests
```yaml
# templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "{{ .Release.Name }}-test"
  annotations:
    "helm.sh/hook": test
spec:
  containers:
  - name: wget
    image: busybox
    command: ['wget']
    args: ['{{ .Release.Name }}:{{ .Values.service.port }}']
  restartPolicy: Never
```

Run tests:
```bash
helm test my-release
```

## Hands-On Lab

### Exercise: Deploy WordPress with Helm

1. Add Bitnami repository:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

2. Create values file:
```yaml
# wordpress-values.yaml
wordpressUsername: admin
wordpressPassword: admin123
wordpressEmail: admin@example.com

service:
  type: ClusterIP

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

persistence:
  enabled: true
  size: 5Gi

mariadb:
  primary:
    persistence:
      enabled: true
      size: 5Gi
```

3. Install WordPress:
```bash
helm install my-wp bitnami/wordpress -f wordpress-values.yaml
helm status my-wp
kubectl get pods
```

4. Access WordPress:
```bash
kubectl port-forward svc/my-wp-wordpress 8080:80
```

5. Upgrade:
```bash
helm upgrade my-wp bitnami/wordpress --set replicaCount=2
```

6. Cleanup:
```bash
helm uninstall my-wp
```

## Troubleshooting

| Issue | Command | Solution |
|-------|---------|----------|
| Chart not found | `helm repo update` | Update repositories |
| Release failed | `helm status <release>` | Check events |
| Values not applied | `helm get values <release>` | Verify values file |
| Hook failures | `kubectl get jobs` | Check hook jobs |

## Resources
- [Helm Documentation](https://helm.sh/docs/)
- [Artifact Hub](https://artifacthub.io/) - Find charts
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/)
