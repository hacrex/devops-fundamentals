# 🐧 Topic 2: Shell Scripting

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 90 min


## Overview
Shell scripting automates repetitive tasks, streamlines workflows, and enables infrastructure automation. Bash (Bourne Again Shell) is the most common shell in Linux environments.

## Key Concepts

### 1. Script Structure

#### Shebang Line
```bash
#!/bin/bash
```
Always start scripts with a shebang to specify the interpreter.

#### Basic Script Template
```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Variables
SCRIPT_NAME=$(basename "$0")
LOG_FILE="/var/log/${SCRIPT_NAME}.log"

# Functions
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Main execution
main() {
    log "Script started"
    # Your code here
    log "Script completed"
}

main "$@"
```

### 2. Variables

```bash
# Variable assignment (no spaces around =)
NAME="DevOps"
VERSION=1.0

# Using variables
echo "Hello $NAME"
echo "Version: ${VERSION}"

# Special variables
$0      # Script name
$1-$9   # Positional parameters
$#      # Number of arguments
$@      # All arguments
$?      # Exit status of last command
$$      # Current process ID
$!      # Last background process ID

# Read-only variables
readonly PI=3.14159

# User input
read -p "Enter your name: " USER_NAME
echo "Hello, $USER_NAME"
```

### 3. Conditional Statements

#### If Statements
```bash
# Simple if
if [ condition ]; then
    commands
fi

# If-else
if [ condition ]; then
    commands
else
    commands
fi

# If-elif-else
if [ condition1 ]; then
    commands
elif [ condition2 ]; then
    commands
else
    commands
fi
```

#### Test Conditions
```bash
# File tests
[ -f file ]      # File exists
[ -d dir ]       # Directory exists
[ -e path ]      # Path exists
[ -r file ]      # Readable
[ -w file ]      # Writable
[ -x file ]      # Executable
[ -s file ]      # Size > 0

# String tests
[ -z "$str" ]    # Empty string
[ -n "$str" ]    # Non-empty string
[ "$a" = "$b" ]  # Equal
[ "$a" != "$b" ] # Not equal

# Numeric tests
[ $a -eq $b ]    # Equal
[ $a -ne $b ]    # Not equal
[ $a -gt $b ]    # Greater than
[ $a -lt $b ]    # Less than
[ $a -ge $b ]    # Greater or equal
[ $a -le $b ]    # Less or equal

# Modern syntax (preferred)
[[ condition ]]  # More powerful than []
(( arithmetic )) # Arithmetic evaluation
```

### 4. Loops

#### For Loop
```bash
# Iterate over items
for item in app1 app2 app3; do
    echo "Processing $item"
done

# Iterate over files
for file in *.txt; do
    echo "File: $file"
done

# C-style for loop
for ((i=0; i<10; i++)); do
    echo "Number: $i"
done

# Iterate over command output
for user in $(cat /etc/passwd | cut -d: -f1); do
    echo "User: $user"
done
```

#### While Loop
```bash
# Basic while
count=0
while [ $count -lt 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# Infinite loop with break
while true; do
    echo "Press Ctrl+C to stop"
    sleep 5
    break  # Remove for actual infinite loop
done
```

### 5. Case Statement
```bash
case $1 in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

### 6. Functions
```bash
# Define function
greet() {
    local name=$1
    echo "Hello, $name!"
}

# Call function
greet "DevOps"

# Function with return value
check_file() {
    local file=$1
    if [ -f "$file" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Check return value
if check_file "/etc/passwd"; then
    echo "File exists"
fi
```

### 7. Arrays
```bash
# Declare array
servers=("web1" "web2" "web3")

# Access elements
echo "${servers[0]}"     # First element
echo "${servers[@]}"     # All elements
echo "${#servers[@]}"    # Array length

# Add element
servers+=("web4")

# Iterate
for server in "${servers[@]}"; do
    echo "Server: $server"
done
```

### 8. Command Substitution
```bash
# Capture command output
DATE=$(date +%Y-%m-%d)
HOSTNAME=$(hostname)
FILES=$(ls -1 | wc -l)

echo "Date: $DATE"
echo "Hostname: $HOSTNAME"
echo "Files: $FILES"
```

### 9. Error Handling
```bash
#!/bin/bash
set -euo pipefail  # Strict mode

# Trap errors
trap 'echo "Error on line $LINENO"' ERR

# Check if command succeeded
if ! command -v docker &>/dev/null; then
    echo "Docker not installed"
    exit 1
fi

# Or use || operator
mkdir /protected/directory || echo "Failed to create directory"

# Custom error function
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Usage
[ -f config.txt ] || error_exit "Config file not found"
```

### 10. String Manipulation
```bash
STRING="Hello World DevOps"

# Length
echo ${#STRING}  # 20

# Substring
echo ${STRING:0:5}   # Hello
echo ${STRING:6}     # World DevOps

# Replace
echo ${STRING/World/Universe}  # Hello Universe DevOps
echo ${STRING//o/O}            # HellO WOrld DevOps (all occurrences)

# Remove pattern
echo ${STRING#Hello }    # World DevOps (from beginning)
echo ${STRING%DevOps}    # Hello World (from end)

# Upper/Lower case
echo ${STRING^^}  # HELLO WORLD DEVOPS
echo ${STRING,,}  # hello world devops
```

## Hands-On Exercises

### Exercise 1: Backup Script
```bash
#!/bin/bash
# backup.sh - Create timestamped backups

BACKUP_DIR="/tmp/backups"
SOURCE_DIR="$HOME/documents"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

if [ -d "$SOURCE_DIR" ]; then
    tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" "$SOURCE_DIR"
    echo "Backup created: backup_$TIMESTAMP.tar.gz"
else
    echo "Source directory not found"
    exit 1
fi
```

### Exercise 2: System Health Check
```bash
#!/bin/bash
# health-check.sh - Monitor system resources

echo "=== System Health Check ==="
echo ""

# Disk usage
echo "📊 Disk Usage:"
df -h / | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 ")"}'
echo ""

# Memory usage
echo "💾 Memory Usage:"
free -h | grep Mem | awk '{print "  Used: " $3 " / " $2}'
echo ""

# Load average
echo "⚡ Load Average:"
uptime | awk -F'load average:' '{print "  " $2}'
echo ""

# Top processes by CPU
echo "🔝 Top 3 CPU Processes:"
ps aux --sort=-%cpu | head -4 | tail -3 | awk '{print "  " $11 " (" $3 "%)"}'
echo ""

echo "✅ Health check complete"
```

### Exercise 3: User Management Script
```bash
#!/bin/bash
# user-manager.sh - Create users with home directories

if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1

if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists"
    exit 1
fi

useradd -m -s /bin/bash "$USERNAME"
if [ $? -eq 0 ]; then
    echo "User $USERNAME created successfully"
    echo "Home directory: /home/$USERNAME"
else
    echo "Failed to create user"
    exit 1
fi
```

### Exercise 4: Log Analyzer
```bash
#!/bin/bash
# log-analyzer.sh - Analyze web server logs

LOG_FILE="${1:-/var/log/nginx/access.log}"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

echo "=== Log Analysis Report ==="
echo "File: $LOG_FILE"
echo ""

echo "Total Requests: $(wc -l < "$LOG_FILE")"
echo ""

echo "Top 5 IP Addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
echo ""

echo "HTTP Status Codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn
echo ""

echo "Requests per Hour:"
awk -F'[' '{print $2}' "$LOG_FILE" | cut -d: -f2 | sort | uniq -c
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

1. **Use `set -euo pipefail`** for strict error handling
2. **Quote variables**: `"$VAR"` not `$VAR`
3. **Use functions** for reusability
4. **Add comments** for complex logic
5. **Validate inputs** before processing
6. **Use meaningful variable names**
7. **Handle errors gracefully**
8. **Test scripts thoroughly**
9. **Use `shellcheck`** for linting
10. **Document usage** with help messages

## Common Pitfalls

| Mistake | Correct Approach |
|---------|-----------------|
| `if [ $VAR = "test" ]` | `if [ "$VAR" = "test" ]` |
| `for i in $(ls)` | `for file in *` or `while read` |
| No error checking | Use `set -e` and check `$?` |
| Hardcoded paths | Use variables or environment |
| No input validation | Check arguments and types |

## Debugging Tips

```bash
# Run with debug output
bash -x script.sh

# Syntax check only
bash -n script.sh

# Add debug in script
set -x  # Enable debug
# ... code ...
set +x  # Disable debug

# Use trap for debugging
trap 'echo "Line $LINENO: $BASH_COMMAND"' DEBUG
```

## Next Steps

- Practice writing daily automation scripts
- Learn about cron jobs for scheduling
- Explore advanced bash features
- Study systemd services (Topic 3)

## Additional Resources

- [ShellCheck](https://www.shellcheck.net/) - Online linter
- [Bash Guide](https://mywiki.wooledge.org/BashGuide) - Comprehensive guide
- [Explainshell](https://explainshell.com/) - Command explanation
