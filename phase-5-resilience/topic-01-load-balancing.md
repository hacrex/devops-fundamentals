# ⚖️ Topic 1: Load Balancing

## Overview
Load balancing distributes network traffic across multiple servers to ensure no single server bears too much demand, improving responsiveness and availability.

## Key Concepts

### 1. Load Balancing Algorithms

**Round Robin:** Distributes requests sequentially
**Least Connections:** Sends to server with fewest active connections
**IP Hash:** Routes based on client IP address
**Weighted:** Assigns different weights to servers based on capacity

### 2. Health Checks

Regular probes to determine if backend servers are healthy:
- **HTTP checks:** Request specific endpoints
- **TCP checks:** Verify port connectivity
- **Interval:** How often to check (e.g., 10s)
- **Timeout:** Maximum wait time for response
- **Unhealthy threshold:** Consecutive failures before marking down

### 3. Types of Load Balancers

| Type | Layer | Examples | Use Case |
|------|-------|----------|----------|
| L4 (Transport) | TCP/UDP | HAProxy, NGINX | High performance, simple routing |
| L7 (Application) | HTTP/HTTPS | ALB, Traefik | Content-based routing, SSL termination |

## Hands-On Exercises

### Exercise 1: NGINX Load Balancer
```nginx
upstream backend {
    least_conn;
    server backend1:8080 weight=3;
    server backend2:8080;
    server backend3:8080 backup;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

## Best Practices

1. Implement health checks for all backends
2. Use sticky sessions when needed
3. Monitor load balancer metrics
4. Configure appropriate timeouts
5. Plan for failover scenarios

## Additional Resources
- [NGINX Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/)
- [HAProxy Documentation](http://www.haproxy.org/)
