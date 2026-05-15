# 🔒 DevSecOps Security Cheatsheet

## Security Scanning Commands

### Container Security (Trivy)
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Scan image
trivy image nginx:latest

# Scan with severity filter
trivy image --severity HIGH,CRITICAL myapp:latest

# Generate report
trivy image -f table -o report.txt myapp:latest

# Scan filesystem
trivy fs /path/to/code
```

### Infrastructure as Code (Checkov)
```bash
# Install
pip install checkov

# Scan Terraform
checkov -d terraform/

# Scan with output
checkov -d . -o junitxml -o report.xml

# Skip specific checks
checkov -d . --skip-check CKV_AWS_20
```

### SAST (Semgrep)
```bash
# Install
pip install semgrep

# Run scan
semgrep --config auto .

# Specific language
semgrep --lang python .

# Output formats
semgrep --json --output results.json .
```

## Secrets Management

### HashiCorp Vault CLI
```bash
# Login
vault login

# Read secret
vault read secret/data/myapp

# Write secret
vault write secret/data/myapp password=secret123

# List secrets
vault list secret/data/

# Enable KV engine
vault secrets enable -path=secret kv-v2
```

### AWS Secrets Manager
```bash
# Get secret value
aws secretsmanager get-secret-value \
  --secret-id my-secret \
  --query SecretString --output text

# Create secret
aws secretsmanager create-secret \
  --name my-secret \
  --secret-string '{"password":"secret123"}'
```

## Network Security

### Firewall Rules (UFW)
```bash
# Enable firewall
sudo ufw enable

# Allow specific ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 443/tcp   # HTTPS

# Deny IP
sudo ufw deny from 192.168.1.100

# Status
sudo ufw status verbose
```

### iptables Basics
```bash
# List rules
sudo iptables -L -n -v

# Allow port
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Drop IP
sudo iptables -A INPUT -s 192.168.1.100 -j DROP

# Save rules
sudo iptables-save > /etc/iptables/rules.v4
```

## SSL/TLS

### OpenSSL Commands
```bash
# Generate private key
openssl genrsa -out server.key 2048

# Create CSR
openssl req -new -key server.key -out server.csr

# Self-signed certificate
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout server.key -out server.crt

# View certificate
openssl x509 -in server.crt -text -noout

# Check SSL connection
openssl s_client -connect example.com:443
```

### Let's Encrypt (Certbot)
```bash
# Install
sudo apt install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d example.com

# Auto-renew
sudo certbot renew --dry-run
```

## Security Best Practices Checklist

- [ ] Enable MFA on all accounts
- [ ] Rotate credentials regularly
- [ ] Use least privilege principle
- [ ] Scan containers before deployment
- [ ] Enable encryption at rest and in transit
- [ ] Implement network segmentation
- [ ] Monitor and log security events
- [ ] Keep systems updated
- [ ] Backup critical data
- [ ] Test incident response plan

## Common CVEs to Watch

| CVE | Description | Mitigation |
|-----|-------------|------------|
| Log4Shell | Remote code execution in Log4j | Update to 2.17+ |
| Shellshock | Bash vulnerability | Patch bash |
| Heartbleed | OpenSSL memory leak | Update OpenSSL |

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CIS Benchmarks](https://www.cisecurity.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
