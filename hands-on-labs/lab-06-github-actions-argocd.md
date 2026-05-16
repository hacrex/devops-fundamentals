# 🧪 Lab 6: CI/CD Pipeline with GitHub Actions + ArgoCD (GitOps)

## 🎯 Goal
Build a complete GitOps workflow where code commits trigger CI pipelines that build and push Docker images, and ArgoCD automatically deploys changes to Kubernetes when the Helm chart repository is updated.

## 📋 Prerequisites
- GitHub account
- Kubernetes cluster (minikube, kind, or cloud-based)
- kubectl and Helm installed
- Docker installed
- ArgoCD installed on cluster

⏱️ **Estimated Time:** 90 minutes  
📊 **Difficulty:** 🔴 Advanced

---

## Architecture Overview

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Code      │     │    CI        │     │   Artifact   │
│  Repository │────▶│  Pipeline    │────▶│   Registry   │
│  (App Code) │     │(GitHub Actions)│   │(Docker Hub)  │
└─────────────┘     └──────────────┘     └──────────────┘
                                               │
                                               ▼
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│  Kubernetes │◀────│    GitOps    │◀────│   Config     │
│   Cluster   │     │   (ArgoCD)   │     │  Repository  │
│             │     │              │     │(Helm Charts) │
└─────────────┘     └──────────────┘     └──────────────┘
```

---

## Project Structure

You'll create two repositories:

**1. Application Repository** (`myapp`):
```
myapp/
├── src/
│   └── app.py
├── Dockerfile
├── requirements.txt
├── .github/
│   └── workflows/
│       └── ci-cd.yml
└── README.md
```

**2. GitOps Configuration Repository** (`myapp-gitops`):
```
myapp-gitops/
├── environments/
│   ├── dev/
│   │   └── app-values.yaml
│   └── prod/
│       └── app-values.yaml
├── charts/
│   └── myapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
└── applications/
    ├── myapp-dev.yaml
    └── myapp-prod.yaml
```

---

## Step 1: Create Sample Application

Create `src/app.py`:
```python
from flask import Flask, jsonify
import os
import socket
from datetime import datetime

app = Flask(__name__)

VERSION = os.getenv('APP_VERSION', '1.0.0')
ENVIRONMENT = os.getenv('ENVIRONMENT', 'development')

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello from GitOps!',
        'version': VERSION,
        'hostname': socket.gethostname(),
        'environment': ENVIRONMENT,
        'timestamp': datetime.utcnow().isoformat()
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/ready')
def ready():
    return jsonify({'status': 'ready'}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
```

Create `requirements.txt`:
```
flask==3.0.0
gunicorn==21.2.0
```

Create `Dockerfile`:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

ENV PORT=5000
ENV APP_VERSION=1.0.0
ENV ENVIRONMENT=development

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

USER nobody

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
```

---

## Step 2: Create GitHub Actions CI/CD Pipeline

Create `.github/workflows/ci-cd.yml`:
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: docker.io
  IMAGE_NAME: ${{ github.repository_owner }}/myapp

jobs:
  # Job 1: Test
  test:
    name: Test
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov

      - name: Run tests
        run: |
          pytest --cov=src --cov-report=xml || echo "No tests found"
          
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
          fail_ci_if_error: false

  # Job 2: Build and Push Docker Image
  build:
    name: Build & Push
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    
    permissions:
      contents: read
      packages: write

    outputs:
      image_tag: ${{ steps.meta.outputs.tags }}
      version: ${{ steps.version.outputs.version }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Generate version
        id: version
        run: |
          VERSION="1.0.${{ github.run_number }}"
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "Generated version: $VERSION"

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=raw,value=${{ steps.version.outputs.version }}
            type=raw,value=latest,enable={{is_default_branch}}
            type=sha,prefix=,format=short

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          build-args: |
            APP_VERSION=${{ steps.version.outputs.version }}
            ENVIRONMENT=${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ steps.version.outputs.version }}
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
        continue-on-error: true

  # Job 3: Update GitOps Repository
  update-gitops:
    name: Update GitOps Config
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout GitOps repo
        uses: actions/checkout@v4
        with:
          repository: ${{ github.repository_owner }}/myapp-gitops
          token: ${{ secrets.GITOPS_PAT }}
          path: gitops-repo

      - name: Update image tag in values
        working-directory: gitops-repo
        run: |
          IMAGE_TAG="${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ needs.build.outputs.version }}"
          
          # Update dev environment
          cat > environments/dev/app-values.yaml <<EOF
          replicaCount: 2
          image:
            repository: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
            tag: "${{ needs.build.outputs.version }}"
            pullPolicy: IfNotPresent
          app:
            version: "${{ needs.build.outputs.version }}"
            environment: development
          EOF
          
          # Update prod environment
          cat > environments/prod/app-values.yaml <<EOF
          replicaCount: 3
          image:
            repository: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
            tag: "${{ needs.build.outputs.version }}"
            pullPolicy: IfNotPresent
          app:
            version: "${{ needs.build.outputs.version }}"
            environment: production
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
            maxReplicas: 10
          EOF

      - name: Commit and push changes
        working-directory: gitops-repo
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add environments/
          git commit -m "chore: update myapp to version ${{ needs.build.outputs.version }}
          
          Auto-updated by GitHub Actions
          Commit: ${{ github.sha }}
          Build: ${{ github.run_number }}"
          git push origin main
```

---

## Step 3: Create GitOps Repository Structure

Create directory structure:
```bash
mkdir -p myapp-gitops/{environments/{dev,prod},charts/myapp/templates,applications}
cd myapp-gitops
```

Create `charts/myapp/Chart.yaml`:
```yaml
apiVersion: v2
name: myapp
description: My Application Helm Chart
type: application
version: 1.0.0
appVersion: "1.0.0"
```

Create `charts/myapp/values.yaml`:
```yaml
replicaCount: 1

image:
  repository: docker.io/username/myapp
  pullPolicy: IfNotPresent
  tag: "latest"

serviceAccount:
  create: true
  name: ""

service:
  type: ClusterIP
  port: 80
  targetPort: 5000

ingress:
  enabled: false
  className: nginx
  hosts: []

resources:
  limits:
    cpu: 500m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

app:
  version: "1.0.0"
  environment: development

livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 10
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: http
  initialDelaySeconds: 5
  periodSeconds: 5
```

Create `charts/myapp/templates/deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "myapp.name" . }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ include "myapp.name" . }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          env:
            - name: APP_VERSION
              value: {{ .Values.app.version | quote }}
            - name: ENVIRONMENT
              value: {{ .Values.app.environment | quote }}
```

Create `charts/myapp/templates/service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "myapp.fullname" . }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
```

---

## Step 4: Create ArgoCD Application Manifests

Create `applications/myapp-dev.yaml`:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-dev
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/YOUR_USERNAME/myapp-gitops.git
    targetRevision: HEAD
    path: charts/myapp
    helm:
      valueFiles:
        - ../../environments/dev/app-values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - CreateNamespace=true
      - Validate=true
      - SkipDryRunOnMissingResource=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

Create `applications/myapp-prod.yaml`:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-prod
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/YOUR_USERNAME/myapp-gitops.git
    targetRevision: HEAD
    path: charts/myapp
    helm:
      valueFiles:
        - ../../environments/prod/app-values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - CreateNamespace=true
      - Validate=true
    retry:
      limit: 3
      backoff:
        duration: 10s
        factor: 2
        maxDuration: 5m
```

---

## Step 5: Install and Configure ArgoCD

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for installation
kubectl wait --for=condition=available deployment --all -n argocd --timeout=5m

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access ArgoCD UI at https://localhost:8080
- Username: `admin`
- Password: (from previous command)

---

## Step 6: Add GitHub Secrets

In your application repository (`myapp`):

1. Go to Settings → Secrets and variables → Actions
2. Add these secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Docker Hub access token
   - `GITOPS_PAT`: GitHub Personal Access Token with repo access

Generate Docker Hub token:
```bash
# Visit https://hub.docker.com/settings/security
# Create access token with read/write permissions
```

Generate GitHub PAT:
```bash
# Visit https://github.com/settings/tokens
# Create token with 'repo' scope
```

---

## Step 7: Deploy Applications with ArgoCD

```bash
# Apply ArgoCD applications
kubectl apply -f applications/myapp-dev.yaml
kubectl apply -f applications/myapp-prod.yaml

# Check application status
kubectl get applications -n argocd

# Watch sync progress
watch kubectl get applications -n argocd

# View application details
kubectl get application myapp-dev -n argocd -o yaml
```

Or use ArgoCD CLI:
```bash
# Install ArgoCD CLI
brew install argocd-cli  # macOS
# or download from https://github.com/argoproj/argo-cd/releases

# Login
argocd login localhost:8080 --username admin --password <password> --insecure

# List applications
argocd app list

# Get app details
argocd app get myapp-dev

# Sync manually
argocd app sync myapp-dev
```

---

## Step 8: Test the GitOps Workflow

```bash
# 1. Make a code change in myapp repository
cd myapp
echo "# Version 2.0.0" >> src/app.py
git add .
git commit -m "feat: update application"
git push

# 2. Watch CI pipeline in GitHub Actions
# Visit: https://github.com/YOUR_USERNAME/myapp/actions

# 3. After CI completes, check GitOps repo
# The values files should be updated automatically

# 4. Watch ArgoCD sync
kubectl get applications -n argocd -w

# 5. Verify deployment
kubectl get pods -n dev
kubectl get pods -n prod

# 6. Test the application
kubectl port-forward svc/myapp -n dev 8080:80
curl http://localhost:8080
```

---

## 🔍 Try It Yourself Exercises

### Exercise 1: Implement Approval Gate for Production
1. Modify the ArgoCD prod application to disable auto-sync
2. Add a manual approval step using GitHub Environments
3. Require PR review before prod deployment

### Exercise 2: Add Canary Deployment
1. Create a canary environment in GitOps repo
2. Configure Argo Rollouts for progressive delivery
3. Set up metrics-based promotion

### Exercise 3: Multi-Cluster Deployment
1. Register multiple clusters with ArgoCD
2. Deploy dev to cluster A, prod to cluster B
3. Implement cluster-specific configurations

---

## ⚠️ Common Mistakes to Avoid

1. **Hardcoded Credentials**: Never commit secrets; use sealed-secrets or external secret managers
2. **No Resource Limits**: Always set CPU/memory limits in production
3. **Skipping Tests**: Ensure CI runs all tests before deploying
4. **Manual Interventions**: Let ArgoCD handle sync automatically
5. **Ignoring Drift**: Enable self-healing to prevent configuration drift

---

## 🌍 Real-World Scenarios

### Scenario 1: Enterprise Multi-Tenant Setup
- Separate ArgoCD projects per team
- RBAC for different environments
- Audit trails for compliance

### Scenario 2: Blue-Green Deployments
- Two production environments
- Switch traffic using ingress
- Instant rollback capability

### Scenario 3: Disaster Recovery
- GitOps repo as single source of truth
- Quick cluster recreation from Git
- Automated backup of critical state

---

## ✅ What You Learned
- Building end-to-end GitOps workflows
- Creating CI/CD pipelines with GitHub Actions
- Configuring ArgoCD for automated deployments
- Managing multi-environment deployments
- Implementing security scanning in CI
- Using Helm for package management
- Automating infrastructure updates

---

## 📚 Additional Resources
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitHub Actions Docs](https://docs.github.com/actions)
- [GitOps Toolkit](https://toolkit.fluxcd.io/)
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

---

## 🧹 Cleanup

```bash
# Remove ArgoCD applications
kubectl delete -f applications/myapp-dev.yaml
kubectl delete -f applications/myapp-prod.yaml

# Delete namespaces
kubectl delete ns dev prod

# Uninstall ArgoCD (optional)
kubectl delete namespace argocd

# Delete repositories (manual)
# Remove myapp and myapp-gitops from GitHub
```
