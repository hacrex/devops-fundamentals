# 🏗️ Topic 4: Terraform

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 90 min


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


## Try It Yourself

### Exercise 1: Basic Practice
```bash
# Try this command to practice what you learned
# Replace with topic-specific example
echo "Testing your understanding..."
```

**Expected Output:**
```
Testing your understanding...
```

### Exercise 2: Real-World Application
```bash
# Apply this concept in a practical scenario
# Challenge: Modify this example for your use case
```

**Challenge:** Can you adapt this example to solve a problem in your environment?

## Common Mistakes to Avoid

❌ **Mistake 1:** Not checking prerequisites before starting
   - **Solution:** Always verify requirements first

❌ **Mistake 2:** Ignoring error messages
   - **Solution:** Read error messages carefully; they often point to the solution

❌ **Mistake 3:** Skipping documentation
   - **Solution:** Use `--help` flag or man pages when unsure

## Real-World Scenario

**Scenario:** You're deploying an application and need to apply the concepts from this topic.

**Problem:** The application fails to start due to configuration issues.

**Solution Steps:**
1. Check logs for error messages
2. Verify configuration files
3. Test connectivity
4. Review permissions

**Key Takeaway:** Understanding these concepts helps you troubleshoot production issues faster.

## Quiz Questions

Test your understanding with these questions:

1. **Question:** What is the primary purpose of this topic's main concept?
   - A) Option A
   - B) Option B  
   - C) Option C
   - D) Option D
   
   <details><summary>✅ Answer</summary>B) Option B (replace with correct answer)</details>

2. **Question:** Which command would you use to accomplish the main task?
   - A) command-a
   - B) command-b
   - C) command-c
   - D) command-d
   
   <details><summary>✅ Answer</summary>C) command-c (replace with correct answer)</details>

3. **Question:** What happens if you skip an important configuration step?
   - A) Everything works fine
   - B) The system crashes
   - C) Errors occur during runtime
   - D) Nothing happens
   
   <details><summary>✅ Answer</summary>C) Errors occur during runtime</details>


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
