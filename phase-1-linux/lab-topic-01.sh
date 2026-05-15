#!/bin/bash

# Topic 1 Lab: Linux Basics Practice Script
# This script provides hands-on exercises for Linux fundamentals

set -e  # Exit on error

echo "=========================================="
echo "🐧 Linux Basics - Hands-On Lab"
echo "=========================================="
echo ""

# Exercise 1: File System Navigation
echo "📁 Exercise 1: File System Navigation"
echo "--------------------------------------"

LAB_DIR="$HOME/devops-lab-$(date +%s)"
mkdir -p "$LAB_DIR"/{scripts,logs,config,data}
echo "✅ Created directory structure at: $LAB_DIR"

cd "$LAB_DIR"
touch config/app.conf logs/app.log scripts/deploy.sh data/sample.txt
echo "✅ Created initial files"

echo ""
echo "Directory structure:"
find . -type f | sort
echo ""

# Exercise 2: Permissions
echo "🔐 Exercise 2: File Permissions"
echo "--------------------------------"

cat > scripts/hello.sh << 'EOF'
#!/bin/bash
echo "Hello from DevOps Lab!"
echo "Current user: $(whoami)"
echo "Date: $(date)"
EOF

echo "Created scripts/hello.sh"
echo "Permissions before chmod:"
ls -l scripts/hello.sh

chmod +x scripts/hello.sh
echo ""
echo "Permissions after chmod +x:"
ls -l scripts/hello.sh

echo ""
echo "Executing the script:"
./scripts/hello.sh
echo ""

# Exercise 3: Text Processing
echo "📝 Exercise 3: Text Processing & Log Analysis"
echo "----------------------------------------------"

cat > logs/application.log << 'EOF'
2024-01-15 10:00:01 INFO Application started successfully
2024-01-15 10:00:02 DEBUG Loading configuration from /etc/app/config.yml
2024-01-15 10:00:03 INFO Database connection established
2024-01-15 10:00:04 WARN High memory usage detected: 85%
2024-01-15 10:00:05 ERROR Failed to connect to external API
2024-01-15 10:00:06 INFO Retrying API connection...
2024-01-15 10:00:07 INFO API connection successful
2024-01-15 10:00:08 DEBUG Processing batch job #1234
2024-01-15 10:00:09 ERROR Timeout waiting for response
2024-01-15 10:00:10 WARN Disk space below 20%
2024-01-15 10:00:11 INFO Batch job completed
2024-01-15 10:00:12 ERROR Authentication failed for user admin
2024-01-15 10:00:13 INFO User guest logged in
2024-01-15 10:00:14 DEBUG Cache cleared
2024-01-15 10:00:15 INFO Application shutdown initiated
EOF

echo "Created sample log file with 15 entries"
echo ""

echo "Total log entries: $(wc -l < logs/application.log)"
echo "ERROR count: $(grep -c 'ERROR' logs/application.log)"
echo "WARN count: $(grep -c 'WARN' logs/application.log)"
echo "INFO count: $(grep -c 'INFO' logs/application.log)"
echo ""

echo "All ERROR lines:"
grep "ERROR" logs/application.log
echo ""

echo "Lines with context (1 before, 1 after) for ERROR:"
grep -A 1 -B 1 "ERROR" logs/application.log | head -20
echo ""

# Exercise 4: Process Management
echo "⚙️  Exercise 4: Process Management"
echo "-----------------------------------"

echo "Starting background processes..."
sleep 30 &
PID1=$!
sleep 60 &
PID2=$!

echo "Started sleep processes with PIDs: $PID1 and $PID2"
echo ""

echo "Current sleep processes:"
ps aux | grep "[s]leep" || echo "No sleep processes found"
echo ""

echo "Killing process $PID1..."
kill $PID1
sleep 1

echo "Remaining sleep processes:"
ps aux | grep "[s]leep" || echo "No sleep processes found"
echo ""

# Cleanup
kill $PID2 2>/dev/null || true

# Exercise 5: Disk Usage
echo "💾 Exercise 5: Disk Usage Analysis"
echo "-----------------------------------"

echo "Disk usage summary:"
df -h | head -5
echo ""

echo "Size of our lab directory:"
du -sh "$LAB_DIR"
echo ""

echo "File sizes in lab directory:"
du -ah "$LAB_DIR" | sort -rh | head -10
echo ""

# Exercise 6: User & Group Info
echo "👤 Exercise 6: User & Group Information"
echo "----------------------------------------"

echo "Current user: $(whoami)"
echo "User ID: $(id -u)"
echo "Group ID: $(id -g)"
echo "Groups: $(id -Gn)"
echo ""

# Exercise 7: Network Basics
echo "🌐 Exercise 7: Network Information"
echo "-----------------------------------"

echo "Hostname: $(hostname)"
echo ""

echo "IP Addresses:"
ip addr show | grep "inet " | awk '{print $2}' | head -5
echo ""

echo "Testing connectivity to google.com..."
if ping -c 2 -W 2 google.com &>/dev/null; then
    echo "✅ Connectivity OK"
else
    echo "⚠️  No internet connectivity (this is OK in some environments)"
fi
echo ""

# Final Summary
echo "=========================================="
echo "✅ Lab Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "- Created directory structure at: $LAB_DIR"
echo "- Practiced file permissions"
echo "- Analyzed log files with grep, awk, and other tools"
echo "- Managed background processes"
echo "- Checked disk usage"
echo "- Reviewed user and network information"
echo ""
echo "To clean up, run: rm -rf $LAB_DIR"
echo ""
echo "Next: Move on to Topic 2 - Shell Scripting"
