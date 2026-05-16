# 🏆 Capstone Project: Build a Complete DevOps Pipeline

**Time Estimate:** 8-12 hours  
**Difficulty:** 🔴 Advanced  
**Total Points:** 200

---

## Project Overview

Design, implement, and deploy a production-ready application with full CI/CD, monitoring, and resilience features. This capstone project combines all skills learned throughout the DevOps Fundamentals program.

---

## Scenario

You are the lead DevOps engineer at a startup launching a new e-commerce platform. Your task is to build the complete infrastructure and deployment pipeline from scratch.

---

## Requirements

### 1. Application Containerization (25 points)

**Objective:** Containerize a sample web application

**Tasks:**
- Create or use a simple web application (Node.js, Python Flask, or similar)
- Write a multi-stage Dockerfile optimizing for size and security
- Create a `.dockerignore` file
- Build and test the container locally
- Push to a container registry (Docker Hub, GitHub Container Registry, etc.)

**Deliverables:**
- Dockerfile with best practices
- Built and pushed container image
- Documentation of image layers and size optimization

---

### 2. Orchestration Setup (30 points)

**Objective:** Deploy the application using Kubernetes or Docker Compose

**Tasks:**
- Create Kubernetes manifests OR Docker Compose file including:
  - Web application deployment/service
  - Database (PostgreSQL or MySQL)
  - Redis cache
  - ConfigMaps and Secrets management
- Implement health checks (liveness and readiness probes)
- Configure resource limits and requests
- Set up persistent storage

**Deliverables:**
- Kubernetes YAML files OR docker-compose.yml
- Deployment documentation
- Screenshots of running pods/services

---

### 3. CI/CD Pipeline Implementation (35 points)

**Objective:** Automate build, test, and deployment

**Tasks:**
- Create a GitHub Actions workflow that:
  - Triggers on push to main branch
  - Runs automated tests
  - Builds Docker image
  - Scans for vulnerabilities (use Trivy or similar)
  - Pushes to container registry
  - Deploys to staging environment
- Implement deployment strategies:
  - Blue-Green OR Canary deployment
- Add manual approval gate for production deployment

**Deliverables:**
- `.github/workflows/ci-cd.yml` file
- Pipeline execution screenshots
- Documentation of the workflow

---

### 4. Monitoring & Observability (30 points)

**Objective:** Implement comprehensive monitoring

**Tasks:**
- Deploy Prometheus for metrics collection
- Configure Grafana dashboards showing:
  - Application metrics (request rate, error rate, response time)
  - System metrics (CPU, memory, disk)
  - Business metrics (if applicable)
- Set up alerting rules for:
  - High error rate (>5%)
  - High response time (>1s)
  - Pod restarts
  - Low disk space
- Implement centralized logging with ELK stack or Loki

**Deliverables:**
- Prometheus configuration
- Grafana dashboard screenshots (export JSON)
- Alert rules configuration
- Logging setup documentation

---

### 5. Infrastructure as Code (25 points)

**Objective:** Provision infrastructure using Terraform

**Tasks:**
- Write Terraform code to provision:
  - Cloud provider resources (AWS Free Tier, GCP, or Azure)
  - OR local infrastructure (using kind, minikube, or localstack)
- Include:
  - VPC and networking
  - Kubernetes cluster or VM instances
  - Database instance
  - Load balancer
- Use modules for reusability
- Store state remotely (S3, GCS, or Terraform Cloud)

**Deliverables:**
- Terraform configuration files
- State file screenshot (not the actual file!)
- Architecture diagram

---

### 6. Reliability Engineering (25 points)

**Objective:** Define and implement SLOs and error budgets

**Tasks:**
- Define SLIs for your application:
  - Availability
  - Latency
  - Throughput
- Set SLO targets (e.g., 99.9% availability)
- Calculate error budgets
- Create error budget burn rate monitoring
- Document incident response procedure
- Perform a chaos engineering experiment:
  - Kill a pod randomly
  - Simulate network latency
  - Test database failure recovery

**Deliverables:**
- SLO document
- Error budget calculation
- Chaos experiment report with findings
- Incident response runbook

---

### 7. Security Best Practices (20 points)

**Objective:** Implement security throughout the pipeline

**Tasks:**
- Scan containers for vulnerabilities
- Implement secrets management (never hardcode!)
- Configure network policies
- Set up RBAC (Role-Based Access Control)
- Enable TLS/HTTPS
- Implement security headers
- Conduct a security review

**Deliverables:**
- Security scan reports
- Secrets management implementation
- Network policies
- Security checklist completion

---

## Deliverables Summary

Submit the following in a GitHub repository:

### Code & Configuration
- [ ] Application source code
- [ ] Dockerfile
- [ ] Kubernetes manifests or Docker Compose
- [ ] GitHub Actions workflows
- [ ] Terraform configurations
- [ ] Prometheus/Grafana configurations

### Documentation
- [ ] README with project overview
- [ ] Architecture diagram
- [ ] Deployment guide
- [ ] Monitoring dashboard guide
- [ ] Incident response runbook
- [ ] SLO/Error budget document
- [ ] Chaos experiment report

### Evidence
- [ ] Screenshots of running application
- [ ] Pipeline execution logs
- [ ] Grafana dashboards
- [ ] Security scan reports
- [ ] Video demo (optional, 5-10 minutes)

---

## Evaluation Criteria

| Category | Points | Weight |
|----------|--------|--------|
| Containerization | 25 | 12.5% |
| Orchestration | 30 | 15% |
| CI/CD Pipeline | 35 | 17.5% |
| Monitoring | 30 | 15% |
| Infrastructure as Code | 25 | 12.5% |
| Reliability Engineering | 25 | 12.5% |
| Security | 20 | 10% |
| Documentation Quality | 10 | 5% |
| **Total** | **200** | **100%** |

**Passing Score:** 160 points (80%)

### Grading Rubric

**Excellent (90-100%):**
- All requirements met with exceptional quality
- Clean, well-documented code
- Creative solutions beyond requirements
- Professional-grade documentation

**Good (80-89%):**
- All core requirements met
- Good code quality
- Adequate documentation
- Minor issues or improvements possible

**Needs Improvement (<80%):**
- Missing key requirements
- Code quality issues
- Poor documentation
- Significant gaps in implementation

---

## Timeline Recommendation

| Week | Focus Area | Hours |
|------|-----------|-------|
| 1 | Containerization + Orchestration | 3-4 hrs |
| 2 | CI/CD Pipeline | 2-3 hrs |
| 3 | Monitoring + IaC | 3-4 hrs |
| 4 | Reliability + Security + Documentation | 2-3 hrs |

---

## Resources Allowed

- ✅ All course materials
- ✅ Official documentation
- ✅ Stack Overflow and forums
- ✅ AI assistants for guidance (not code generation)
- ✅ Open-source tools and libraries

## Resources NOT Allowed

- ❌ Pre-built complete solutions from the internet
- ❌ Having someone else do the work
- ❌ AI generating entire codebases without understanding

---

## Submission Instructions

1. Create a public GitHub repository named `devops-capstone-[yourname]`
2. Push all code and documentation
3. Submit the repository link via the assessment portal
4. Include a brief README with setup instructions

---

## Presentation (Optional Bonus: 10 points)

Record a 10-minute video presentation covering:
- Architecture overview
- Key challenges and solutions
- Demo of the running system
- Lessons learned

Upload to YouTube (unlisted) or Loom and include the link in your README.

---

## Next Steps After Completion

🎉 **Congratulations!** You've completed the DevOps Fundamentals program!

**Your Journey Continues:**
1. Receive your [Certificate of Completion](../certificate-template.md)
2. Add this project to your portfolio
3. Consider advanced certifications:
   - Certified Kubernetes Administrator (CKA)
   - AWS Certified DevOps Engineer
   - HashiCorp Terraform Associate
   - Google Cloud Professional DevOps Engineer

---

## Need Help?

- Review phase materials if stuck
- Check [Troubleshooting Guide](../../TROUBLESHOOTING.md)
- Join study groups or forums
- Ask specific questions (show what you've tried first)

---

**Good luck, and may your deployments be always green! 🚀**
