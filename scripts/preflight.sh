#!/bin/bash

###############################################################################
# DevOps Fundamentals - Pre-flight Check Script
###############################################################################
# This script verifies that all required tools and configurations are in place
# before starting the hands-on labs.
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
WARNINGS=0
FAILED=0

# Helper functions
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

check_command() {
    local cmd=$1
    local name=$2
    local required=${3:-true}
    
    if command -v "$cmd" &> /dev/null; then
        version=$("$cmd" --version 2>&1 | head -n 1) || version=$("$cmd" version 2>&1 | head -n 1) || version="installed"
        print_success "$name is installed: $version"
        return 0
    else
        if [ "$required" = true ]; then
            print_error "$name is NOT installed (required)"
            return 1
        else
            print_warning "$name is NOT installed (optional)"
            return 1
        fi
    fi
}

check_docker_running() {
    if docker info &> /dev/null; then
        print_success "Docker daemon is running"
        return 0
    else
        print_error "Docker daemon is NOT running"
        print_warning "Try: sudo systemctl start docker"
        return 1
    fi
}

check_kubeconfig() {
    if [ -f "$HOME/.kube/config" ] || [ -n "$KUBECONFIG" ]; then
        if kubectl cluster-info &> /dev/null; then
            cluster=$(kubectl config current-context 2>/dev/null || echo "unknown")
            print_success "Kubernetes configured: context '$cluster'"
            return 0
        else
            print_warning "Kubernetes config exists but cluster is not accessible"
            return 1
        fi
    else
        print_warning "No Kubernetes configuration found (~/.kube/config)"
        return 1
    fi
}

check_disk_space() {
    local min_gb=${1:-10}
    local available=$(df -BG / | awk 'NR==2 {gsub(/G/,""); print $4}')
    
    if [ "$available" -ge "$min_gb" ]; then
        print_success "Disk space sufficient: ${available}GB available"
        return 0
    else
        print_error "Low disk space: ${available}GB available (minimum ${min_gb}GB recommended)"
        return 1
    fi
}

check_memory() {
    local min_gb=${1:-4}
    local total_mem=$(grep MemTotal /proc/meminfo | awk '{printf "%.0f", $2/1024/1024}')
    
    if [ "$total_mem" -ge "$min_gb" ]; then
        print_success "Memory sufficient: ${total_mem}GB total"
        return 0
    else
        print_warning "Low memory: ${total_mem}GB total (minimum ${min_gb}GB recommended)"
        return 1
    fi
}

check_port_available() {
    local port=$1
    local service=$2
    
    if ! ss -tuln | grep -q ":$port "; then
        print_success "Port $port is available ($service)"
        return 0
    else
        print_warning "Port $port is already in use ($service)"
        return 1
    fi
}

check_aws_credentials() {
    if [ -f "$HOME/.aws/credentials" ] || [ -n "$AWS_ACCESS_KEY_ID" ]; then
        if aws sts get-caller-identity &> /dev/null; then
            account=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "unknown")
            print_success "AWS credentials configured: account $account"
            return 0
        else
            print_warning "AWS credentials exist but validation failed"
            return 1
        fi
    else
        print_warning "AWS credentials not configured (needed for Terraform labs)"
        return 1
    fi
}

check_github_auth() {
    if command -v gh &> /dev/null && gh auth status &> /dev/null; then
        print_success "GitHub CLI authenticated"
        return 0
    else
        print_warning "GitHub CLI not authenticated (needed for GitHub Actions labs)"
        return 1
    fi
}

###############################################################################
# Main Checks
###############################################################################

print_header "🔍 DevOps Fundamentals - Pre-flight Check"

print_header "1. Core Tools"
check_command "docker" "Docker" true
check_command "docker-compose" "Docker Compose" true || check_command "docker compose" "Docker Compose (plugin)" true
check_command "git" "Git" true

print_header "2. Container Runtime"
if command -v docker &> /dev/null; then
    check_docker_running
    check_port_available 80 "HTTP"
    check_port_available 443 "HTTPS"
    check_port_available 3000 "Common App Port"
    check_port_available 5000 "Common App Port"
fi

print_header "3. Kubernetes Tools"
check_command "kubectl" "kubectl" false
if command -v kubectl &> /dev/null; then
    check_kubeconfig
fi
check_command "helm" "Helm" false

print_header "4. Infrastructure as Code"
check_command "terraform" "Terraform" false
if command -v terraform &> /dev/null; then
    check_aws_credentials
fi

print_header "5. Cloud & Version Control"
check_command "aws" "AWS CLI" false
check_command "gh" "GitHub CLI" false
if command -v gh &> /dev/null; then
    check_github_auth
fi

print_header "6. System Resources"
check_disk_space 10
check_memory 4

print_header "7. Common Ports"
check_port_available 9090 "Prometheus"
check_port_available 3000 "Grafana"
check_port_available 5601 "Kibana"
check_port_available 9200 "Elasticsearch"
check_port_available 8080 "Common Alternative HTTP"

###############################################################################
# Summary
###############################################################################

print_header "📊 Summary"
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC}   $FAILED"
echo ""

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Pre-flight check FAILED${NC}"
    echo -e "\n${YELLOW}Please install/configure the missing required tools before proceeding.${NC}"
    echo -e "\nQuick setup commands:"
    echo -e "  Docker:     https://docs.docker.com/get-docker/"
    echo -e "  kubectl:    https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    echo -e "  Helm:       https://helm.sh/docs/intro/install/"
    echo -e "  Terraform:  https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Pre-flight check passed with warnings${NC}"
    echo -e "\n${BLUE}You can proceed, but some optional features may not work.${NC}"
    echo -e "\nTo enable all features, consider installing:"
    if ! command -v kubectl &> /dev/null; then echo "  - kubectl (Kubernetes labs)"; fi
    if ! command -v helm &> /dev/null; then echo "  - helm (Kubernetes package management)"; fi
    if ! command -v terraform &> /dev/null; then echo "  - terraform (Infrastructure as Code labs)"; fi
    if ! command -v aws &> /dev/null; then echo "  - aws cli (Cloud infrastructure labs)"; fi
    exit 0
else
    echo -e "${GREEN}✅ All pre-flight checks passed!${NC}"
    echo -e "\n${BLUE}You're ready to start the DevOps Fundamentals labs! 🚀${NC}"
    echo -e "\nNext steps:"
    echo -e "  1. Review the README.md for learning path"
    echo -e "  2. Start with hands-on-labs/lab-01-nodejs-docker-cicd.md"
    echo -e "  3. Join our community for support"
    exit 0
fi
