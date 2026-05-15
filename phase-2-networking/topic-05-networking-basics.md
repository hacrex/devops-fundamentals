# 🌐 Topic 5: Networking Basics

## Overview
Networking is fundamental to DevOps. Understanding how systems communicate enables you to design, troubleshoot, and optimize distributed systems.

## Key Concepts

### 1. OSI Model

The Open Systems Interconnection model has 7 layers:

```
Layer 7: Application    - HTTP, FTP, SMTP, DNS (User interface)
Layer 6: Presentation   - Encryption, compression, formatting
Layer 5: Session        - Connection management, authentication
Layer 4: Transport      - TCP, UDP (End-to-end communication)
Layer 3: Network        - IP, ICMP, Routing (Path determination)
Layer 2: Data Link      - Ethernet, MAC addresses (Node-to-node)
Layer 1: Physical       - Cables, hubs, signals (Physical connection)
```

**Mnemonic:** "All People Seem To Need Data Processing"

### 2. TCP/IP Model

Simplified 4-layer model:
- **Application Layer** (OSI 5-7): HTTP, FTP, SSH
- **Transport Layer** (OSI 4): TCP, UDP
- **Internet Layer** (OSI 3): IP, ICMP
- **Network Access Layer** (OSI 1-2): Ethernet, WiFi

### 3. IP Addressing

#### IPv4
- 32-bit address: `192.168.1.1`
- Classes: A (1-126), B (128-191), C (192-223)
- Private ranges:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16

#### IPv6
- 128-bit address: `2001:0db8:85a3::8a2e:0370:7334`
- Solves IPv4 exhaustion
- Built-in security (IPsec)

### 4. Subnetting

Subnet masks divide networks:
- `/24` = `255.255.255.0` = 254 hosts
- `/16` = `255.255.0.0` = 65,534 hosts
- `/8` = `255.0.0.0` = 16,777,214 hosts

**Example:** `192.168.1.0/24`
- Network: 192.168.1.0
- First host: 192.168.1.1
- Last host: 192.168.1.254
- Broadcast: 192.168.1.255

### 5. TCP vs UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | Best effort |
| Ordering | Ordered packets | No ordering |
| Speed | Slower (overhead) | Faster |
| Use Cases | Web, email, files | Video, VoIP, gaming |
| Ports | Same port range | Same port range |

### 6. Common Ports

| Port | Protocol | Service |
|------|----------|---------|
| 21 | TCP | FTP |
| 22 | TCP | SSH |
| 25 | TCP | SMTP |
| 53 | UDP/TCP | DNS |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 6379 | TCP | Redis |
| 8080 | TCP | HTTP Alt |

### 7. Routing

- **Default Gateway:** Route for unknown destinations
- **Static Routes:** Manually configured
- **Dynamic Routes:** Learned via protocols (OSPF, BGP)

```bash
# View routing table
ip route show
route -n

# Add static route
sudo ip route add 10.0.0.0/8 via 192.168.1.1

# Delete route
sudo ip route del 10.0.0.0/8
```

### 8. NAT (Network Address Translation)

Allows private IPs to access public internet:
- **SNAT:** Source NAT (outbound)
- **DNAT:** Destination NAT (inbound/port forwarding)
- **PAT:** Port Address Translation (many-to-one)

### 9. Firewalls

Filter network traffic:
- **iptables:** Legacy Linux firewall
- **nftables:** Modern replacement
- **ufw:** Ubuntu firewall (simplified)
- **firewalld:** RHEL/CentOS firewall

```bash
# UFW examples
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw deny 80/tcp
sudo ufw status
```

## Hands-On Exercises

### Exercise 1: Network Configuration
```bash
# View all interfaces
ip addr show

# View specific interface
ip addr show eth0

# Bring interface up/down
sudo ip link set eth0 down
sudo ip link set eth0 up
```

### Exercise 2: Connectivity Testing
```bash
# Ping test
ping -c 4 google.com

# Trace route
traceroute google.com
tracepath google.com

# Test specific port
nc -zv google.com 443
```

### Exercise 3: DNS Troubleshooting
```bash
# Query DNS
nslookup google.com
dig google.com
dig @8.8.8.8 google.com
```

### Exercise 4: Packet Capture
```bash
# Capture with tcpdump
sudo tcpdump -i eth0 -n port 80

# Save to file
sudo tcpdump -i eth0 -w capture.pcap

# Read capture file
tcpdump -r capture.pcap
```

## Common Issues & Solutions

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| No connectivity | `ping gateway` | Check cable/WiFi, restart network |
| DNS failure | `nslookup google.com` | Check /etc/resolv.conf |
| Port blocked | `nc -zv host port` | Check firewall rules |
| Slow network | `mtr host` | Check bandwidth, latency |

## Best Practices

1. **Document network topology** - Keep diagrams updated
2. **Use private IPs internally** - Never expose internal services
3. **Implement least privilege** - Only open necessary ports
4. **Monitor network traffic** - Use monitoring tools
5. **Test failover** - Ensure redundancy works
6. **Segment networks** - Separate prod, dev, management

## Essential Commands Reference

```bash
# Interface management
ip addr show          # Show IP addresses
ip link show          # Show interfaces
ip neigh show         # Show ARP table

# Routing
ip route show         # Show routing table
ip route get 8.8.8.8  # Show route to destination

# Statistics
ss -tulpn             # Show listening ports

# Diagnostics
ping host             # ICMP echo
traceroute host       # Path tracing
tcpdump -i iface      # Packet capture
```

## Next Steps

- Study HTTP internals (Topic 6)
- Learn TLS/SSL certificates (Topic 7)
- Master DNS configuration (Topic 8)
- Explore load balancing (Topic 20)

## Additional Resources

- [Wireshark](https://www.wireshark.org/) - Packet analyzer
- [NetworkLessons](https://networklessons.com/) - Free networking courses
- [RFC 791](https://tools.ietf.org/html/rfc791) - IP specification
