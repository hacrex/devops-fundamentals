# Terraform Cheatsheet

## Quick Reference for Terraform Commands

### Initialization & Planning
```bash
terraform init                          # Initialize working directory
terraform init -upgrade                 # Upgrade providers
terraform init -reconfigure             # Reconfigure backend
terraform validate                      # Validate configuration
terraform fmt                           # Format configuration
terraform fmt -recursive                # Format all directories
terraform plan                          # Show execution plan
terraform plan -out=tfplan              # Save plan to file
terraform plan -var-file=prod.tfvars    # Use variable file
terraform plan -target=aws_instance.web # Target specific resource
```

### Apply & Destroy
```bash
terraform apply                         # Apply changes
terraform apply -auto-approve           # Skip confirmation
terraform apply tfplan                  # Apply saved plan
terraform apply -var="instance_type=t3.micro"
terraform destroy                       # Destroy all resources
terraform destroy -target=aws_instance.web
terraform destroy -auto-approve
```

### State Management
```bash
terraform state list                    # List resources in state
terraform state show <resource>         # Show resource details
terraform state mv <old> <new>          # Move/rename resource
terraform state rm <resource>           # Remove from state
terraform state pull                    # Download state
terraform state push                    # Upload state
terraform import <resource> <id>        # Import existing resource
terraform refresh                       # Update state from real world
```

### Workspace Management
```bash
terraform workspace list                # List workspaces
terraform workspace new prod            # Create workspace
terraform workspace select prod         # Select workspace
terraform workspace delete dev          # Delete workspace
terraform workspace show                # Show current workspace
```

### Output & Inspection
```bash
terraform output                        # Show outputs
terraform output -json                  # JSON format
terraform output instance_id            # Specific output
terraform console                       # Interactive console
terraform graph                         # Generate dependency graph
terraform providers                     # Show providers
terraform version                       # Show version info
```

### Remote State
```bash
terraform force-unlock <lock-id>        # Force unlock state
```

## Resource Examples

### AWS EC2 Instance
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name        = "web-server"
    Environment = "production"
  }
}
```

### S3 Bucket
```hcl
resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
  
  tags = {
    Name = "Data Bucket"
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
```

### VPC
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "public-subnet"
  }
}
```

### Variables
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
```

### Outputs
```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name"
  value       = aws_instance.web.public_dns
  sensitive   = false
}
```

### Locals
```hcl
locals {
  common_tags = {
    Project     = "myproject"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
  
  instance_name = "${var.project}-${var.environment}-web"
}
```

### Data Sources
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  owners = ["099720109477"] # Canonical
}

data "aws_region" "current" {}
```

### Modules
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  
  tags = local.common_tags
}
```

### Providers
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = local.common_tags
  }
}
```

## Best Practices

1. **State Management**
   - Use remote state (S3 + DynamoDB)
   - Enable state locking
   - Encrypt state at rest

2. **Code Organization**
   - Use modules for reusability
   - Separate environments with workspaces or directories
   - Keep state files separate per environment

3. **Security**
   - Never commit secrets
   - Use AWS Secrets Manager or Vault
   - Enable encryption everywhere

4. **Version Control**
   - Pin provider versions
   - Use semantic versioning for modules
   - Review plans before applying

5. **Testing**
   - Use terraform validate
   - Run terraform plan in CI/CD
   - Test modules independently

## Common Patterns

### Count vs For_Each
```hcl
# Count
resource "aws_instance" "count" {
  count         = 3
  ami           = "ami-123456"
  instance_type = "t3.micro"
}

# For_each (preferred)
resource "aws_instance" "foreach" {
  for_each      = toset(["web", "api", "db"])
  ami           = "ami-123456"
  instance_type = "t3.micro"
  
  tags = {
    Name = each.key
  }
}
```

### Conditional Creation
```hcl
resource "aws_s3_bucket" "optional" {
  count  = var.create_bucket ? 1 : 0
  bucket = "my-bucket"
}
```

### Dynamic Blocks
```hcl
resource "aws_security_group" "example" {
  name = "example"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```
