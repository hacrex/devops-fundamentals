# 🐧 Topic 1: Linux Basics

## Overview
Linux is the foundation of DevOps. Most servers, containers, and cloud infrastructure run on Linux. Mastering Linux fundamentals is essential for any DevOps engineer.

## Key Concepts

### 1. File System Hierarchy
```
/           # Root directory
├── bin     # Essential binaries (commands)
├── boot    # Boot loader files
├── dev     # Device files
├── etc     # Configuration files
├── home    # User home directories
├── lib     # Shared libraries
├── media   # Removable media mount point
├── mnt     # Temporary mount point
├── opt     # Optional/additional software
├── proc    # Process information (virtual)
├── root    # Root user's home directory
├── run     # Runtime data
├── sbin    # System binaries (admin commands)
├── srv     # Service data
├── sys     # System information (virtual)
├── tmp     # Temporary files
├── usr     # User programs and data
└── var     # Variable data (logs, databases)
```

### 2. Essential Commands

#### Navigation
```bash
pwd                 # Print working directory
ls -la              # List all files with details
cd /path/to/dir     # Change directory
cd ..               # Go up one level
cd ~                # Go to home directory
```

#### File Operations
```bash
touch file.txt              # Create empty file
mkdir directory             # Create directory
cp source dest              # Copy file/directory
mv source dest              # Move/rename file/directory
rm file.txt                 # Remove file
rm -rf directory            # Remove directory recursively
cat file.txt                # Display file content
less file.txt               # View file page by page
head -n 10 file.txt         # Show first 10 lines
tail -f file.log            # Follow log file in real-time
```

#### Permissions
```bash
chmod 755 file      # rwxr-xr-x (owner: all, group: rx, others: rx)
chmod +x script.sh  # Make executable
chown user:group file  # Change owner and group
```

Permission bits:
- `r` = read (4)
- `w` = write (2)
- `x` = execute (1)

### 3. User Management
```bash
whoami                  # Current user
id                      # User and group IDs
sudo command            # Execute as root
su - username           # Switch user
adduser newuser         # Create new user (Debian/Ubuntu)
useradd -m newuser      # Create new user (RHEL/CentOS)
passwd username         # Change user password
deluser username        # Delete user
```

### 4. Process Management
```bash
ps aux                  # Show all running processes
top                     # Interactive process viewer
htop                    # Enhanced top (if installed)
kill PID                # Terminate process
kill -9 PID             # Force kill process
pkill process_name      # Kill by name
bg                      # Resume job in background
fg                      # Bring job to foreground
jobs                    # List background jobs
```

### 5. Disk Usage
```bash
df -h                   # Disk space (human readable)
du -sh directory        # Directory size
du -ah | sort -rh       # Find largest files
```

### 6. Text Processing
```bash
grep "pattern" file     # Search for pattern
grep -r "pattern" dir   # Recursive search
awk '{print $1}' file   # Print first column
cut -d: -f1 /etc/passwd # Cut first field using : delimiter
sed 's/old/new/g' file  # Replace text
wc -l file              # Count lines
sort file.txt           # Sort lines
uniq file.txt           # Remove duplicates
```

### 7. Networking Basics
```bash
ip addr show            # Show IP addresses
ip route show           # Show routing table
ping google.com         # Test connectivity
curl https://example.com # HTTP request
wget url                # Download file
netstat -tulpn          # Show listening ports (deprecated)
ss -tulpn               # Show listening ports (modern)
nslookup domain.com     # DNS lookup
dig domain.com          # Detailed DNS info
```

### 8. Package Management

#### Debian/Ubuntu (APT)
```bash
sudo apt update
sudo apt upgrade
sudo apt install package_name
sudo apt remove package_name
sudo apt search keyword
```

#### RHEL/CentOS (YUM/DNF)
```bash
sudo yum update
sudo yum install package_name
sudo yum remove package_name
sudo yum search keyword
```

## Hands-On Exercises

### Exercise 1: File System Navigation
```bash
# Create a directory structure
mkdir -p ~/devops-lab/{scripts,logs,config}
cd ~/devops-lab

# Create some files
touch config/app.conf
touch logs/app.log
touch scripts/deploy.sh

# List the structure
tree .  # or use: find . -type f
```

### Exercise 2: Permission Practice
```bash
# Create a script
echo '#!/bin/bash\necho "Hello DevOps!"' > hello.sh

# Try to run it (will fail)
./hello.sh

# Make it executable
chmod +x hello.sh

# Run it successfully
./hello.sh
```

### Exercise 3: Log Analysis
```bash
# Create sample log
cat > /tmp/sample.log << EOF
2024-01-15 10:00:01 INFO Application started
2024-01-15 10:00:02 ERROR Database connection failed
2024-01-15 10:00:03 WARN Retrying connection
2024-01-15 10:00:04 INFO Connected successfully
2024-01-15 10:00:05 ERROR Timeout occurred
EOF

# Find all errors
grep "ERROR" /tmp/sample.log

# Count errors
grep -c "ERROR" /tmp/sample.log

# Show context around errors
grep -A 2 -B 2 "ERROR" /tmp/sample.log
```

### Exercise 4: Process Management
```bash
# Start a long-running process
sleep 1000 &

# Find its PID
ps aux | grep sleep

# Kill the process
kill <PID>

# Verify it's gone
ps aux | grep sleep
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Permission denied | Check permissions with `ls -l`, use `chmod` or `sudo` |
| Command not found | Install package or check PATH |
| No space left on device | Use `df -h` to check, clean with `du` |
| Too many open files | Check with `ulimit -n`, increase if needed |

## Best Practices

1. **Never run `rm -rf /`** - This will destroy your system
2. **Use `sudo` wisely** - Only when necessary
3. **Backup before deleting** - Especially in production
4. **Check disk space regularly** - Use monitoring tools
5. **Log rotation** - Prevent logs from filling disk
6. **Use meaningful filenames** - Avoid spaces, use underscores

## Next Steps

- Practice daily with Linux commands
- Learn shell scripting (Topic 2)
- Understand systemd services (Topic 3)
- Explore filesystem management (Topic 4)

## Additional Resources

- [Linux Journey](https://linuxjourney.com/) - Interactive learning
- [OverTheWire Bandit](https://overthewire.org/wargames/bandit/) - Security wargame
- [Explainshell](https://explainshell.com/) - Command explanation tool
