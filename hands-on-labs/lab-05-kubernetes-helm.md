# 🧪 Lab 5: Kubernetes Deployment with Helm

## 🎯 Goal
Deploy a microservices application to Kubernetes using Helm charts, configure ingress, secrets, and implement rolling updates.

## 📋 Prerequisites
- Kubernetes cluster (minikube, kind, or cloud-based)
- kubectl installed and configured
- Helm 3.x installed
- Basic understanding of Kubernetes concepts

⏱️ **Estimated Time:** 75 minutes  
📊 **Difficulty:** 🟡 Intermediate

---

## Project Structure
```
k8s-helm-lab/
├── charts/
│   └── myapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-dev.yaml
│       ├── values-prod.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── hpa.yaml
│           └── NOTES.txt
├── app/
│   ├── Dockerfile
│   └── app.py
└── scripts/
    ├── deploy.sh
    └── rollback.sh
```

---

## Step 1: Create Sample Application

Create `app/app.py`:
```python
from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello from Kubernetes!',
        'version': os.getenv('APP_VERSION', '1.0.0'),
        'hostname': socket.gethostname(),
        'environment': os.getenv('ENVIRONMENT', 'development')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/ready')
def ready():
    return jsonify({'status': 'ready'}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
```

Create `app/Dockerfile`:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir flask gunicorn

COPY app.py .

ENV PORT=5000

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

Build and push the image:
```bash
cd app
docker build -t your-dockerhub-username/myapp:1.0.0 .
docker push your-dockerhub-username/myapp:1.0.0
```

---

## Step 2: Create Helm Chart Structure

Initialize the chart:
```bash
mkdir -p charts/myapp/templates
cd charts/myapp
```

Create `Chart.yaml`:
```yaml
apiVersion: v2
name: myapp
description: A Helm chart for deploying Flask application on Kubernetes
type: application
version: 0.1.0
appVersion: "1.0.0"
keywords:
  - flask
  - python
  - web
maintainers:
  - name: DevOps Team
    email: devops@example.com
```

---

## Step 3: Create Templates Helpers

Create `templates/_helpers.tpl`:
```tpl
{{/*
Expand the name of the chart.
*/}}
{{- define "myapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "myapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "myapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "myapp.labels" -}}
helm.sh/chart: {{ include "myapp.chart" . }}
{{ include "myapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "myapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "myapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```

---

## Step 4: Create Deployment Template

Create `templates/deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "myapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
        checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
      labels:
        {{- include "myapp.selectorLabels" . | nindent 8 }}
    spec:
      serviceAccountName: {{ include "myapp.fullname" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /health
              port: http
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /ready
              port: http
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 3
            failureThreshold: 3
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          env:
            - name: APP_VERSION
              valueFrom:
                configMapKeyRef:
                  name: {{ include "myapp.fullname" . }}-config
                  key: APP_VERSION
            - name: ENVIRONMENT
              valueFrom:
                configMapKeyRef:
                  name: {{ include "myapp.fullname" . }}-config
                  key: ENVIRONMENT
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ include "myapp.fullname" . }}-secret
                  key: db-password
                  optional: true
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
```

---

## Step 5: Create Service Template

Create `templates/service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: TCP
      name: http
      {{- if and (eq .Values.service.type "NodePort") .Values.service.nodePort }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
  selector:
    {{- include "myapp.selectorLabels" . | nindent 4 }}
```

---

## Step 6: Create Ingress Template

Create `templates/ingress.yaml`:
```yaml
{{- if .Values.ingress.enabled -}}
{{- $fullName := include "myapp.fullname" . -}}
{{- $svcPort := .Values.service.port -}}
{{- if and .Values.ingress.className (not (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion)) }}
  {{- if not (hasKey .Values.ingress.annotations "kubernetes.io/ingress.class") }}
  {{- $_ := set .Values.ingress.annotations "kubernetes.io/ingress.class" .Values.ingress.className}}
  {{- end }}
{{- end }}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if and .Values.ingress.className (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion) }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            {{- if and .pathType (semverCompare ">=1.18-0" $.Capabilities.KubeVersion.GitVersion) }}
            pathType: {{ .pathType }}
            {{- end }}
            backend:
              {{- if semverCompare ">=1.19-0" $.Capabilities.KubeVersion.GitVersion }}
              service:
                name: {{ $fullName }}
                port:
                  number: {{ $svcPort }}
              {{- else }}
              serviceName: {{ $fullName }}
              servicePort: {{ $svcPort }}
              {{- end }}
          {{- end }}
    {{- end }}
{{- end }}
```

---

## Step 7: Create ConfigMap and Secret Templates

Create `templates/configmap.yaml`:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "myapp.fullname" . }}-config
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
data:
  APP_VERSION: {{ .Values.app.version | quote }}
  ENVIRONMENT: {{ .Values.app.environment | quote }}
  LOG_LEVEL: {{ .Values.app.logLevel | quote }}
```

Create `templates/secret.yaml`:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "myapp.fullname" . }}-secret
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
type: Opaque
data:
  {{- if .Values.secrets.dbPassword }}
  db-password: {{ .Values.secrets.dbPassword | b64enc | quote }}
  {{- end }}
  {{- if .Values.secrets.apiKey }}
  api-key: {{ .Values.secrets.apiKey | b64enc | quote }}
  {{- end }}
```

---

## Step 8: Create HPA Template

Create `templates/hpa.yaml`:
```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "myapp.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}
    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
{{- end }}
```

---

## Step 9: Create Values Files

Create `values.yaml` (default):
```yaml
replicaCount: 2

image:
  repository: your-dockerhub-username/myapp
  pullPolicy: IfNotPresent
  tag: "1.0.0"

nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name: ""

podSecurityContext:
  {}

securityContext:
  {}

service:
  type: ClusterIP
  port: 80
  targetPort: 5000
  nodePort: null

ingress:
  enabled: false
  className: "nginx"
  annotations:
    {}
  hosts:
    - host: myapp.local
      paths:
        - path: /
          pathType: Prefix
  tls: []

resources:
  limits:
    cpu: 500m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}

app:
  version: "1.0.0"
  environment: "development"
  logLevel: "INFO"

secrets:
  dbPassword: ""
  apiKey: ""
```

Create `values-dev.yaml`:
```yaml
replicaCount: 1

image:
  tag: "1.0.0"

service:
  type: NodePort
  nodePort: 30080

app:
  environment: "development"
  logLevel: "DEBUG"

resources:
  limits:
    cpu: 250m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi

autoscaling:
  enabled: false
```

Create `values-prod.yaml`:
```yaml
replicaCount: 3

image:
  tag: "1.0.0"

service:
  type: LoadBalancer

ingress:
  enabled: true
  className: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: myapp-tls
      hosts:
        - myapp.example.com

resources:
  limits:
    cpu: 1000m
    memory: 512Mi
  requests:
    cpu: 200m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70

app:
  environment: "production"
  logLevel: "WARN"

secrets:
  dbPassword: "super-secret-password-change-me"
  apiKey: "your-api-key-here"
```

---

## Step 10: Create NOTES.txt

Create `templates/NOTES.txt`:
```txt
Thank you for installing {{ .Chart.Name }}!

Your release is named {{ .Release.Name }}.

To learn more about the release, try:

  $ helm status {{ .Release.Name }}
  $ helm get all {{ .Release.Name }}

{{- if .Values.ingress.enabled }}
The application is available at:
{{- range .Values.ingress.hosts }}
  http{{ if $.Values.ingress.tls }}s{{ end }}://{{ .host }}
{{- end }}
{{- else if contains "NodePort" .Values.service.type }}
Get the application URL by running these commands:

  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "myapp.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" .Values.service.type }}
NOTE: It may take a few minutes for the LoadBalancer IP to be available.

Get the application URL by running these commands:

  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "myapp.fullname" . }} --template "{{"{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"}}")
  echo http://$SERVICE_IP:{{ .Values.service.port }}
{{- else if contains "ClusterIP" .Values.service.type }}
Get the application URL by running these commands:

  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "myapp.name" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace {{ .Release.Namespace }} $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  kubectl --namespace {{ .Release.Namespace }} port-forward $POD_NAME 8080:$CONTAINER_PORT
  echo "Visit http://127.0.0.1:8080 to use your application"
{{- end }}
```

---

## Step 11: Deploy the Application

```bash
# Validate the chart
helm lint charts/myapp

# Dry run to see rendered templates
helm install myapp-release charts/myapp --dry-run --debug

# Deploy to development
helm install myapp-dev charts/myapp -f charts/myapp/values-dev.yaml --namespace dev --create-namespace

# Check deployment
kubectl get all -n dev
kubectl get pods -n dev -w

# Test the application
export NODE_PORT=$(kubectl get svc -n dev myapp-dev -o jsonpath="{.spec.ports[0].nodePort}")
export NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
curl http://$NODE_IP:$NODE_PORT

# View logs
kubectl logs -n dev -l app.kubernetes.io/name=myapp -f
```

---

## Step 12: Upgrade and Rollback

```bash
# Upgrade to production configuration
helm upgrade myapp-dev charts/myapp -f charts/myapp/values-prod.yaml --namespace dev

# Check rollout status
kubectl rollout status deployment/myapp-dev -n dev

# View release history
helm history myapp-dev -n dev

# Rollback to previous version
helm rollback myapp-dev 1 -n dev

# Uninstall release
helm uninstall myapp-dev -n dev
```

---

## 🔍 Try It Yourself Exercises

### Exercise 1: Enable Auto-scaling
1. Update `values-prod.yaml` to enable HPA
2. Deploy and generate load using `hey` or `ab`
3. Watch pods scale up: `kubectl get hpa -n dev -w`

### Exercise 2: Add Database Dependency
1. Create a PostgreSQL subchart or dependency
2. Update deployment to wait for database
3. Configure connection strings in secrets

### Exercise 3: Implement Blue-Green Deployment
1. Create two separate releases (blue and green)
2. Use ingress to switch traffic between them
3. Automate with Helm hooks

---

## ⚠️ Common Mistakes to Avoid

1. **Hardcoding Values**: Always use values.yaml, never hardcode in templates
2. **Missing Resource Limits**: Always set CPU/memory limits to prevent resource exhaustion
3. **No Health Checks**: Liveness and readiness probes are critical for reliability
4. **Ignoring Namespace**: Always specify namespace explicitly
5. **Not Testing Templates**: Use `helm lint` and `helm template` before deploying

---

## 🌍 Real-World Scenarios

### Scenario 1: Multi-Environment Deployment
- Separate values files for dev/staging/prod
- Different resource quotas per environment
- Environment-specific configurations

### Scenario 2: Microservices Architecture
- Multiple charts with dependencies
- Shared configuration via parent chart
- Coordinated deployments

### Scenario 3: GitOps Workflow
- Store charts in Git repository
- Use ArgoCD or Flux for automated deployments
- Version control for all infrastructure changes

---

## ✅ What You Learned
- Creating production-ready Helm charts
- Using templates, values, and helpers effectively
- Implementing health checks and auto-scaling
- Managing secrets and configurations
- Performing upgrades and rollbacks
- Best practices for Kubernetes deployments

---

## 📚 Additional Resources
- [Helm Documentation](https://helm.sh/docs/)
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/)
- [Kubernetes Patterns](https://kubernetes-patterns.github.io/)
- [Artifact Hub](https://artifacthub.io/) - Find existing charts
- [Helm Testing](https://helm.sh/docs/chart_tests/)

---

## 🧹 Cleanup

```bash
# Remove all releases
helm list --all-namespaces
helm uninstall myapp-dev -n dev

# Delete namespace
kubectl delete namespace dev

# Remove local files (optional)
rm -rf charts/ app/
```
