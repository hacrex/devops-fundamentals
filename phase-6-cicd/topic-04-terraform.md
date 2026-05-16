# 🏗️ Topic 4: Terraform

## Overview
Terraform is an Infrastructure as Code (IaC) tool that allows you to define, provision, and manage infrastructure using declarative configuration files.

## Key Concepts

### 1. Core Principles

**Infrastructure as Code:** Manage infrastructure with version-controlled files
**Declarative:** Define desired state, not steps
**Execution Plan:** Preview changes before applying
**Resource Graph:** Understand dependencies

### 2. Configuration Structure

```hcl
# Provider
provider "aws" {
  region = "us-east-1"
}

# Resource
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "web-server"
  }
}

# Output
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

### 3. Key Commands

```bash
terraform init      # Initialize working directory
terraform plan      # Generate execution plan
terraform apply     # Create/update infrastructure
terraform destroy   # Destroy infrastructure
terraform state     # Manage state
```

### 4. State Management

- **Local state:** terraform.tfstate file
- **Remote state:** S3, Azure Blob, GCS
- **State locking:** Prevent concurrent modifications
- **State versioning:** Track changes over time

### 5. Modules

Reusable, shareable units of Terraform code:
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  cidr   = "10.0.0.0/16"
}
```

## Hands-On Exercises

### Exercise 1: Basic Terraform Setup
```bash
mkdir terraform-lab && cd terraform-lab
terraform init
terraform plan
terraform apply
```

## Best Practices

1. Use remote state storage
2. Implement state locking
3. Version pin providers and modules
4. Use workspaces for environments
5. Validate and format code
6. Store secrets securely

## Additional Resources
- [Terraform Docs](https://www.terraform.io/docs/)
- [Terraform Registry](https://registry.terraform.io/)
- [Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)
