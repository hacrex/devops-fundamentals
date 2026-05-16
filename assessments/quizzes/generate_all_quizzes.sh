#!/bin/bash

# Script to generate placeholder quizzes for all phases
echo "Generating quiz placeholders..."

# Phase 2 Quiz
cat > /workspace/assessments/quizzes/phase-02-networking-quiz.md << 'EOF'
# Phase 2: Networking Quiz

**Time Limit:** 30 minutes  
**Total Questions:** 20  
**Passing Score:** 80% (16 correct answers)

---

## Sample Questions

### 1. What layer of the OSI model does HTTP operate at?
A) Layer 3 - Network  
B) Layer 4 - Transport  
C) Layer 7 - Application  
D) Layer 2 - Data Link  

<details><summary>✅ Answer</summary>C) Layer 7 - Application</details>

### 2. Which port does HTTPS use by default?
A) 80  
B) 443  
C) 8080  
D) 22  

<details><summary>✅ Answer</summary>B) 443</details>

### 3. What does DNS stand for?
A) Domain Name System  
B) Digital Network Service  
C) Dynamic Name Server  
D) Data Network Socket  

<details><summary>✅ Answer</summary>A) Domain Name System</details>

*(Continue with 17 more questions covering TCP/IP, routing, switching, firewalls, load balancing, etc.)*

---

## Next Steps
- If you passed: Proceed to [Networking Challenge](../challenges/phase-02-networking-challenge.md)
- If you didn't pass: Review [Phase 2 Topics](../../phase-2-networking/)
EOF

# Phase 3 Quiz
cat > /workspace/assessments/quizzes/phase-03-containers-quiz.md << 'EOF'
# Phase 3: Containers Quiz

**Time Limit:** 30 minutes  
**Total Questions:** 20  
**Passing Score:** 80%

---

## Sample Questions

### 1. What is Docker?
A) A virtual machine  
B) A containerization platform  
C) A cloud provider  
D) A programming language  

<details><summary>✅ Answer</summary>B) A containerization platform</details>

### 2. Which command builds a Docker image?
A) `docker run`  
B) `docker create`  
C) `docker build`  
D) `docker make`  

<details><summary>✅ Answer</summary>C) `docker build`</details>

*(Continue with 18 more questions)*

---

## Next Steps
- Proceed to [Containers Challenge](../challenges/phase-03-containers-challenge.md)
EOF

# Generate remaining quiz files as placeholders
for phase in 04 05 06 07; do
    case $phase in
        04) name="Observability" ;;
        05) name="Traffic & Resilience" ;;
        06) name="CI/CD & IaC" ;;
        07) name="Reliability Engineering" ;;
    esac
    
    cat > /workspace/assessments/quizzes/phase-${phase}-quiz.md << EOF
# Phase ${phase}: ${name} Quiz

**Time Limit:** 30 minutes  
**Total Questions:** 20  
**Passing Score:** 80%

---

## Instructions
Complete this quiz after studying all topics in Phase ${phase}.

*(Quiz questions to be added - cover key concepts from the phase)*

---

## Next Steps
- Review phase materials
- Take detailed notes
- Complete hands-on labs first
EOF
done

echo "✅ Quiz placeholders created!"
