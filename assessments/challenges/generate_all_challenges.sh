#!/bin/bash

echo "Generating challenge placeholders..."

# Phase 2 Challenge
cat > /workspace/assessments/challenges/phase-02-networking-challenge.md << 'EOF'
# Phase 2: Networking - Practical Challenge

**Time Limit:** 60 minutes  
**Difficulty:** 🟡 Intermediate  
**Total Points:** 100

---

## Scenario
Configure and troubleshoot a network for a multi-tier application.

---

## Tasks

### Task 1: Network Configuration (25 points)
- Configure static IP addresses
- Set up routing tables
- Test connectivity between subnets

### Task 2: DNS Setup (20 points)
- Configure local DNS resolution
- Set up custom domain names
- Test DNS lookups

### Task 3: Firewall Rules (25 points)
- Configure iptables/nftables rules
- Allow only necessary ports
- Block unauthorized access

### Task 4: Load Balancer (20 points)
- Set up NGINX as load balancer
- Configure health checks
- Test failover

### Task 5: TLS Configuration (10 points)
- Generate self-signed certificates
- Configure HTTPS
- Verify secure connection

---

## Deliverables
Submit configuration files and screenshots.

**Passing Score:** 80 points
EOF

# Generate remaining challenges
for phase in 03 04 05 06 07; do
    case $phase in
        03) name="Containers" ;;
        04) name="Observability" ;;
        05) name="Traffic & Resilience" ;;
        06) name="CI/CD & IaC" ;;
        07) name="Reliability Engineering" ;;
    esac
    
    cat > /workspace/assessments/challenges/phase-${phase}-challenge.md << EOF
# Phase ${phase}: ${name} - Practical Challenge

**Time Limit:** 60-90 minutes  
**Difficulty:** 🟡 Intermediate to 🔴 Advanced  
**Total Points:** 100

---

## Scenario
Apply your ${name,,} skills to solve real-world problems.

---

## Tasks

*(Detailed tasks will be added covering key concepts from Phase ${phase})*

### Task 1: Core Concept Application (25 points)
### Task 2: Advanced Configuration (25 points)
### Task 3: Troubleshooting Scenario (25 points)
### Task 4: Optimization Challenge (25 points)

---

## Deliverables
- Configuration files
- Screenshots of working solution
- Brief explanation of approach

**Passing Score:** 80 points

---

## Next Steps
Complete this challenge after finishing all Phase ${phase} topics and labs.
EOF
done

echo "✅ Challenge placeholders created!"
