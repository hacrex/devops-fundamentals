# 💼 DevOps Interview Questions & Answers

## 🐧 Linux

**Q1. What is the difference between a process and a thread?**
> A process is an independent program with its own memory space. A thread is a lightweight unit within a process that shares the same memory. Processes are isolated; threads share resources.

**Q2. How do you troubleshoot a server that is slow?**
> 1. Check CPU: `top` or `htop`
> 2. Check memory: `free -h`
> 3. Check disk I/O: `iostat`, `iotop`
> 4. Check disk space: `df -h`
> 5. Check network: `netstat`, `ss`
> 6. Check logs: `journalctl -xe`, `/var/log/syslog`
> 7. Identify top processes: `ps aux --sort=-%cpu`

**Q3. What is the difference between hard link and soft link?**
> - **Hard link**: Points directly to inode. Survives original file deletion.
> - **Soft link (symlink)**: Points to file path. Breaks if original is deleted.

**Q4. Explain the Linux boot process.**
> BIOS/UEFI → Bootloader (GRUB) → Kernel loads → initramfs → systemd (PID 1) → Targets/Services → Login prompt

**Q5. What is a zombie process?**
> A process that has finished execution but still has an entry in the process table because its parent hasn't read its exit status. Identified by `Z` status in `ps`.

---

## 🌐 Networking

**Q6. What is the difference between TCP and UDP?**
> - **TCP**: Connection-oriented, reliable, ordered, slower. Used for HTTP, SSH, FTP.
> - **UDP**: Connectionless, unreliable, faster. Used for DNS, video streaming, gaming.

**Q7. What happens when you type a URL in a browser?**
> 1. DNS resolution (domain → IP)
> 2. TCP handshake (3-way: SYN, SYN-ACK, ACK)
> 3. TLS handshake (if HTTPS)
> 4. HTTP request sent
> 5. Server responds
> 6. Browser renders HTML

**Q8. What is a subnet mask?**
> It defines which portion of an IP address is the network and which is the host. Example: `255.255.255.0` means the first 3 octets are network, last is host.

**Q9. What is NAT?**
> Network Address Translation maps private IPs to a public IP. Allows multiple devices on a LAN to share one public IP address.

---

## 🐳 Docker & Containers

**Q10. What is the difference between a container and a VM?**
> - **VM**: Full OS, heavy, slow to start, strong isolation (hypervisor).
> - **Container**: Shares host OS kernel, lightweight, fast startup, process-level isolation (namespaces + cgroups).

**Q11. What is a Dockerfile?**
> A text file with instructions to build a Docker image. Each instruction creates a layer. Key instructions: `FROM`, `RUN`, `COPY`, `ENV`, `EXPOSE`, `CMD`, `ENTRYPOINT`.

**Q12. What is the difference between CMD and ENTRYPOINT?**
> - **CMD**: Default command, can be overridden at runtime.
> - **ENTRYPOINT**: Fixed command that always runs. CMD becomes its arguments.

**Q13. How do you reduce Docker image size?**
> - Use minimal base images (`alpine`, `distroless`)
> - Multi-stage builds
> - Combine RUN commands
> - Use `.dockerignore`
> - Remove cache (`--no-cache`)

**Q14. What are Docker namespaces?**
> Linux namespaces provide isolation for containers: PID, Network, Mount, UTS (hostname), IPC, User namespaces.

---

## ☸️ Kubernetes

**Q15. What is a Pod in Kubernetes?**
> The smallest deployable unit in K8s. A Pod can contain one or more containers that share network and storage. Containers in a Pod communicate via `localhost`.

**Q16. What is the difference between a Deployment and a StatefulSet?**
> - **Deployment**: For stateless apps. Pods are interchangeable.
> - **StatefulSet**: For stateful apps (databases). Each Pod has a stable identity and persistent storage.

**Q17. How does Kubernetes handle rolling updates?**
> Kubernetes gradually replaces old Pods with new ones based on `maxSurge` and `maxUnavailable` settings, ensuring zero downtime during updates.

**Q18. What is a ConfigMap vs Secret?**
> - **ConfigMap**: Stores non-sensitive config data (env vars, config files).
> - **Secret**: Stores sensitive data (passwords, tokens) — base64 encoded.

**Q19. What is a Kubernetes Ingress?**
> An API object that manages external HTTP/HTTPS access to services inside the cluster. Acts as a reverse proxy/load balancer with routing rules.

**Q20. What happens when a node fails in Kubernetes?**
> The controller manager detects the node is `NotReady`. After a timeout, it evicts Pods and reschedules them on healthy nodes.

---

## 🔁 CI/CD

**Q21. What is the difference between CI and CD?**
> - **CI (Continuous Integration)**: Automatically build and test code on every commit.
> - **CD (Continuous Delivery)**: Automatically deliver tested code to staging.
> - **CD (Continuous Deployment)**: Automatically deploy to production without manual approval.

**Q22. What is a pipeline in CI/CD?**
> A series of automated stages (build → test → lint → security scan → deploy) triggered by a code change.

**Q23. How do you handle secrets in a CI/CD pipeline?**
> - Use CI/CD secret stores (GitHub Secrets, GitLab CI Variables)
> - Integrate with Vault or AWS Secrets Manager
> - Never hardcode secrets in code or Dockerfiles
> - Use environment injection at runtime

---

## 🏗️ Infrastructure as Code

**Q24. What is Terraform state?**
> A file (`terraform.tfstate`) that maps your Terraform config to real-world resources. It tracks what Terraform manages. Should be stored remotely (S3 + DynamoDB) in teams.

**Q25. What is idempotency in IaC?**
> Running the same configuration multiple times produces the same result without unintended side effects. Core principle of Terraform, Ansible, etc.

---

## 📊 Observability

**Q26. What are the three pillars of observability?**
> 1. **Metrics** — numeric measurements over time (CPU, latency)
> 2. **Logs** — timestamped text events
> 3. **Traces** — end-to-end request journey across services

**Q27. What is the difference between monitoring and observability?**
> - **Monitoring**: Watching known metrics for known failures.
> - **Observability**: Ability to understand internal system state from external outputs — includes unknown failures.

---

## 📈 Reliability

**Q28. What is an SLO?**
> Service Level Objective — a target reliability goal. Example: "99.9% of requests respond in < 200ms." Derived from SLIs (indicators) and backed by error budgets.

**Q29. What is an error budget?**
> The allowed amount of downtime/errors before SLO is breached. If a service has 99.9% SLO → it has 8.7 hours/year of error budget.

**Q30. What is a blameless postmortem?**
> A structured review after an incident focused on processes and systems — not individuals. Goal: learn and prevent recurrence without creating fear culture.

---

## 🎯 Scenario-Based Questions

**Q31. Production is down. What do you do?**
> 1. Acknowledge the incident
> 2. Check monitoring dashboards
> 3. Review recent deployments (rollback if needed)
> 4. Check logs and error rates
> 5. Communicate status to stakeholders
> 6. Fix forward or rollback
> 7. Document timeline for postmortem

**Q32. How would you migrate a monolith to microservices?**
> 1. Identify bounded contexts
> 2. Strangler Fig pattern — replace pieces incrementally
> 3. Set up service-to-service communication (REST/gRPC)
> 4. Implement independent CI/CD per service
> 5. Add observability from day one

**Q33. How would you design a zero-downtime deployment?**
> - Blue/Green deployment
> - Canary releases
> - Rolling updates in Kubernetes
> - Feature flags
> - Database migrations that are backward-compatible

## 🐳 Containers & Kubernetes

**Q34. What is the difference between Docker and a VM?**
> Docker containers share the host kernel and are lightweight (MBs). VMs include full OS with hypervisor overhead (GBs). Containers start in seconds; VMs take minutes.

**Q35. Explain Kubernetes architecture.**
> - **Master Node**: API server, scheduler, controller manager, etcd
> - **Worker Nodes**: kubelet, kube-proxy, container runtime
> - **Pods**: Smallest deployable units
> - **Services**: Network abstraction for pods

**Q36. What is a Kubernetes Pod?**
> A Pod is the smallest deployable unit in K8s, containing one or more containers that share storage, network, and specifications.

**Q37. Difference between Deployment and StatefulSet?**
> - **Deployment**: Stateless apps, pods are interchangeable
> - **StatefulSet**: Stateful apps, stable network IDs, ordered deployment

---

## 🔧 CI/CD & IaC

**Q38. What is Infrastructure as Code?**
> Managing infrastructure through code files rather than manual processes. Benefits: version control, repeatability, consistency, documentation.

**Q39. Explain blue-green deployment.**
> Two identical environments (blue=current, green=new). Deploy to green, test, then switch traffic. Zero downtime, easy rollback.

**Q40. What is canary deployment?**
> Gradually roll out changes to small subset of users before full deployment. Reduces risk by limiting blast radius.

**Q41. How do you handle secrets in CI/CD?**
> Use secret management tools (Vault, AWS Secrets Manager), encrypted environment variables, never commit to repo, use CI/CD platform secrets features.

---

## 📊 Observability

**Q42. What are the three pillars of observability?**
> 1. **Metrics**: Numerical data over time (CPU, memory)
> 2. **Logs**: Timestamped event records
> 3. **Traces**: Request flow across services

**Q43. What is the difference between monitoring and observability?**
> Monitoring tells you WHAT is broken. Observability helps you understand WHY it's broken through exploration and debugging.

**Q44. What is Prometheus?**
> Open-source monitoring system with pull-based metrics collection, PromQL query language, and alerting capabilities.

---

## ⚖️ Resilience & Reliability

**Q45. What is a circuit breaker pattern?**
> Prevents cascading failures by stopping requests to failing services. States: Closed (normal), Open (failing), Half-Open (testing recovery).

**Q46. Explain SLO, SLI, and SLA.**
> - **SLI**: Metric measuring service aspect (latency, availability)
> - **SLO**: Target value for SLI (99.9% availability)
> - **SLA**: Contract with consequences if SLOs not met

**Q47. What is error budget?**
> Allowed amount of failure based on SLO. If SLO is 99.9%, error budget is 0.1%. Used to balance reliability vs feature velocity.

**Q48. What is chaos engineering?**
> Proactively testing system resilience by injecting failures (network latency, instance termination) to discover weaknesses before they cause incidents.

---

## 🔒 Security

**Q49. What is DevSecOps?**
> Integrating security practices throughout the DevOps lifecycle. Shift left security, automate security testing, shared responsibility.

**Q50. How do you secure a Docker container?**
> - Use minimal base images (Alpine)
> - Run as non-root user
> - Scan for vulnerabilities
> - Don't expose unnecessary ports
> - Use secrets management
> - Enable read-only filesystem where possible

---

## 🎯 Scenario-Based Questions

**Scenario 1: Production website is down. What do you do?**
> 1. Check monitoring dashboards
> 2. Verify recent deployments
> 3. Check logs for errors
> 4. Test connectivity (DNS, network)
> 5. Rollback if recent change caused issue
> 6. Communicate status to stakeholders
> 7. Document and conduct postmortem

**Scenario 2: Database is slow. How do you troubleshoot?**
> 1. Check query performance (slow query log)
> 2. Analyze indexes
> 3. Check connections and locks
> 4. Review resource usage (CPU, memory, I/O)
> 5. Examine execution plans
> 6. Consider caching layer

**Scenario 3: How would you design a highly available system?**
> - Multiple availability zones
> - Load balancers with health checks
> - Auto-scaling groups
> - Database replication
> - CDN for static content
> - Backup and disaster recovery plan

---

## 💡 Tips for Interviews

1. **Understand fundamentals** - Don't just memorize tools
2. **Share real experiences** - Use STAR method (Situation, Task, Action, Result)
3. **Ask clarifying questions** - Show problem-solving approach
4. **Admit what you don't know** - But explain how you'd learn
5. **Practice hands-on** - Build projects, contribute to open source
6. **Stay updated** - Follow industry blogs, attend meetups

---

**Good luck with your DevOps interviews! 🚀**
