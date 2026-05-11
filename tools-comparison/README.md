# ⚔️ Tools Comparison Guide

## CI/CD: Jenkins vs GitHub Actions vs GitLab CI

| Feature | Jenkins | GitHub Actions | GitLab CI |
|---------|---------|----------------|-----------|
| **Type** | Self-hosted | Cloud/Self-hosted | Cloud/Self-hosted |
| **Setup** | Complex | Simple | Simple |
| **Config** | Groovy/Jenkinsfile | YAML | YAML |
| **Cost** | Free (infra cost) | Free tier + paid | Free tier + paid |
| **Plugin ecosystem** | Huge (1800+) | Growing | Built-in features |
| **Docker support** | Plugin needed | Native | Native |
| **K8s integration** | Plugin | Actions | Built-in |
| **Secrets mgmt** | Credentials store | GitHub Secrets | CI Variables |
| **Best for** | Enterprise, complex pipelines | GitHub repos | GitLab repos |

### When to choose:
- **Jenkins**: Large enterprise, heavy customization needs, existing Jenkins setup
- **GitHub Actions**: Your code is on GitHub, want simplicity, open source projects
- **GitLab CI**: Full DevOps platform in one place, self-hosted compliance needs

---

## IaC: Ansible vs Terraform vs Puppet

| Feature | Ansible | Terraform | Puppet |
|---------|---------|-----------|--------|
| **Primary use** | Config management | Infrastructure provisioning | Config management |
| **Language** | YAML (Playbooks) | HCL | Puppet DSL |
| **Agent required** | No (agentless) | No | Yes (agent) |
| **State management** | No state | State file | Catalog |
| **Cloud support** | Yes | Excellent | Limited |
| **Learning curve** | Low | Medium | High |
| **Idempotent** | Yes | Yes | Yes |
| **Best for** | App config, ad-hoc tasks | Cloud infra, multi-cloud | Large-scale OS config |

### When to choose:
- **Ansible**: Quick automation, app deployment, server config, no agent overhead
- **Terraform**: Cloud infrastructure, multi-cloud, immutable infra
- **Puppet**: Large enterprises with complex compliance and config drift prevention

---

## Monitoring: Prometheus vs Datadog vs New Relic

| Feature | Prometheus | Datadog | New Relic |
|---------|-----------|---------|-----------|
| **Type** | Open source | SaaS | SaaS |
| **Cost** | Free (infra cost) | Expensive | Expensive |
| **Setup** | Manual | Easy (agent) | Easy (agent) |
| **Metrics** | Excellent | Excellent | Excellent |
| **Logs** | Via Loki | Built-in | Built-in |
| **Traces** | Via Jaeger/Tempo | Built-in | Built-in |
| **Alerting** | Alertmanager | Built-in | Built-in |
| **Dashboards** | Grafana | Built-in | Built-in |
| **K8s support** | Native | Excellent | Good |
| **Best for** | OSS, budget-conscious | Enterprise, full platform | Enterprise, APM focus |

### When to choose:
- **Prometheus + Grafana**: Open source, Kubernetes-native, cost-sensitive
- **Datadog**: All-in-one, enterprise, willing to pay for convenience
- **New Relic**: APM-heavy workloads, developer observability focus

---

## Container Orchestration: Kubernetes vs Docker Swarm vs Nomad

| Feature | Kubernetes | Docker Swarm | Nomad |
|---------|-----------|--------------|-------|
| **Complexity** | High | Low | Medium |
| **Scalability** | Excellent | Good | Excellent |
| **Ecosystem** | Huge | Limited | Growing |
| **Learning curve** | Steep | Easy | Medium |
| **Multi-workload** | Containers only | Containers only | Containers + VMs + binaries |
| **Cloud support** | EKS, GKE, AKS | Limited | Yes |
| **Best for** | Production, large scale | Small teams, simple needs | Mixed workloads, HashiCorp stack |

---

## Cloud Providers: AWS vs GCP vs Azure

| Feature | AWS | GCP | Azure |
|---------|-----|-----|-------|
| **Market share** | ~33% | ~11% | ~22% |
| **Compute** | EC2 | Compute Engine | Virtual Machines |
| **Kubernetes** | EKS | GKE (best K8s) | AKS |
| **Serverless** | Lambda | Cloud Functions | Azure Functions |
| **Database** | RDS, DynamoDB | Cloud SQL, Spanner | Azure SQL, CosmosDB |
| **Storage** | S3 | Cloud Storage | Blob Storage |
| **ML/AI** | SageMaker | Vertex AI (strong) | Azure AI |
| **Free tier** | 12 months | $300 credit | 12 months |
| **Best for** | Most use cases | Data/ML workloads | Microsoft/enterprise shops |
