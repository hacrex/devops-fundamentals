# 🧪 Lab 3: Infrastructure as Code with Terraform (AWS EC2)

## 🎯 Goal
Use Terraform to provision an AWS EC2 instance, security group, and key pair — fully automated.

## 📋 Prerequisites
- AWS account (free tier works)
- Terraform installed: `terraform -v`
- AWS CLI configured: `aws configure`

---

## Project Structure
```
terraform-ec2/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── user_data.sh
```

---

## Step 1: Provider Configuration

Create `provider.tf`:
```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

## Step 2: Variables

Create `variables.tf`:
```hcl
variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "devops-key"
}

variable "project_name" {
  description = "Name for resource tagging"
  type        = string
  default     = "devops-fundamentals"
}
```

---

## Step 3: Main Resources

Create `main.tf`:
```hcl
# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Key pair
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Name    = var.key_name
    Project = var.project_name
  }
}

# Security group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = file("user_data.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.project_name}-server"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

---

## Step 4: User Data Script

Create `user_data.sh`:
```bash
#!/bin/bash
apt-get update -y
apt-get install -y docker.io curl git

# Start Docker
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Setup complete!" > /home/ubuntu/setup.log
```

---

## Step 5: Outputs

Create `outputs.tf`:
```hcl
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS name"
  value       = aws_instance.web.public_dns
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.web.public_ip}"
}
```

---

## Step 6: Terraform Commands

```bash
# Initialize (download providers)
terraform init

# Preview changes
terraform plan

# Apply (create resources)
terraform apply

# SSH into instance
ssh -i ~/.ssh/id_rsa ubuntu@<public_ip>

# Destroy all resources (save costs!)
terraform destroy
```

---

## Step 7: Remote State (Best Practice)

For teams, store state remotely:
```hcl
# Add to provider.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "devops-fundamentals/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

---

## ✅ What You Learned
- Writing Terraform HCL configurations
- Managing AWS resources (EC2, SG, Key Pair)
- Using data sources and variables
- Outputs for resource information
- Remote state management
- Always run `terraform destroy` to avoid AWS charges!
