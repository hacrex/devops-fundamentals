# 🐧 Linux Commands Cheatsheet

## File & Directory
```bash
ls -la              # List all files with details
pwd                 # Print working directory
cd /path            # Change directory
mkdir -p dir/sub    # Create nested directories
rm -rf dir          # Remove directory recursively
cp -r src dst       # Copy recursively
mv old new          # Move or rename
find / -name file   # Find file by name
locate filename     # Fast file search
tree                # Show directory tree
```

## File Viewing & Editing
```bash
cat file            # Print file content
less file           # Paginated view
head -n 20 file     # First 20 lines
tail -f file        # Follow file (live logs)
grep -r "text" .    # Search text recursively
sed -i 's/a/b/g'    # Replace text in file
awk '{print $1}'    # Print first column
wc -l file          # Count lines
```

## Permissions
```bash
chmod 755 file      # rwxr-xr-x
chmod +x script.sh  # Make executable
chown user:group f  # Change owner
umask 022           # Default permission mask
ls -l               # View permissions
```

## Process Management
```bash
ps aux              # All running processes
top / htop          # Live process monitor
kill -9 PID         # Force kill process
killall nginx       # Kill by name
jobs                # List background jobs
bg / fg             # Background / foreground
nohup cmd &         # Run after logout
```

## Disk & Memory
```bash
df -h               # Disk usage (human readable)
du -sh dir          # Directory size
free -h             # Memory usage
lsblk               # List block devices
mount /dev/sdb /mnt # Mount disk
fdisk -l            # List partitions
```

## Networking
```bash
ip a                # Show IP addresses
ip r                # Show routing table
ping host           # Test connectivity
curl -I url         # HTTP headers
wget url            # Download file
netstat -tulpn      # Open ports
ss -tulpn           # Modern netstat
traceroute host     # Trace network path
nslookup domain     # DNS lookup
dig domain          # Detailed DNS lookup
```

## Users & Groups
```bash
whoami              # Current user
id                  # User & group IDs
adduser username    # Add user
passwd username     # Change password
usermod -aG grp usr # Add user to group
su - username       # Switch user
sudo cmd            # Run as root
```

## Archive & Compression
```bash
tar -czf out.tar.gz dir   # Compress
tar -xzf file.tar.gz      # Extract
zip -r out.zip dir         # Zip
unzip file.zip             # Unzip
```

## System Info
```bash
uname -a            # Kernel info
hostnamectl         # Hostname details
uptime              # System uptime
lscpu               # CPU info
lsmem               # Memory info
dmesg | tail        # Kernel messages
journalctl -xe      # Systemd logs
```

## SSH
```bash
ssh user@host            # Connect
ssh -i key.pem user@host # Connect with key
scp file user@host:/path # Copy file
ssh-keygen -t rsa        # Generate key pair
ssh-copy-id user@host    # Copy public key
```
