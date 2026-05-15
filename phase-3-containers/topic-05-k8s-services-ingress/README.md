# Topic 5: Kubernetes Services and Ingress

## Introduction
Services and Ingress provide networking capabilities in Kubernetes, enabling communication between pods and external access to applications.

## Services

### What is a Service?
- Abstract way to expose application running on pods
- Stable IP address and DNS name
- Load balances traffic across pods
- Decouples frontend from backend

### Service Types

#### 1. ClusterIP (Default)
Exposes service on internal cluster IP:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
```

#### 2. NodePort
Exposes service on each node's IP at static port:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30007
```

#### 3. LoadBalancer
Exposes service externally using cloud provider's load balancer:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
```

#### 4. ExternalName
Maps service to external DNS name:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ExternalName
  externalName: my.database.example.com
```

### Service Discovery
```bash
# By DNS name (within same namespace)
http://<service-name>.<namespace>.svc.cluster.local

# Within same namespace
http://<service-name>

# Get service details
kubectl get services
kubectl describe service <service-name>
```

## Ingress

### What is Ingress?
- API object that manages external access
- Provides HTTP/HTTPS routing
- Single entry point for multiple services
- Requires Ingress Controller

### Basic Ingress Example
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### Path-Based Routing
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-service-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8000
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### TLS Configuration
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
spec:
  tls:
  - hosts:
    - myapp.example.com
    secretName: tls-secret
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### Common Annotations (NGINX)
```yaml
annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /$1
  nginx.ingress.kubernetes.io/ssl-redirect: "true"
  nginx.ingress.kubernetes.io/proxy-body-size: "50m"
  nginx.ingress.kubernetes.io/rate-limit: "100"
  nginx.ingress.kubernetes.io/cors-allow-origin: "*"
```

## Hands-On Lab

### Exercise: Expose Application

1. Create deployment and service:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

2. Create ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: local.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

3. Apply and test:
```bash
kubectl apply -f app.yaml
kubectl get ingress
curl -H "Host: local.example.com" http://<ingress-ip>
```

## Best Practices

1. Use ClusterIP for internal services
2. Implement Ingress for external HTTP/HTTPS
3. Always use TLS in production
4. Set resource limits on Ingress Controller
5. Use network policies for security
6. Monitor ingress traffic

## Troubleshooting

| Issue | Command | Solution |
|-------|---------|----------|
| Service not accessible | `kubectl get endpoints` | Check selector labels |
| Ingress pending | `kubectl describe ingress` | Check Ingress Controller |
| 502 Bad Gateway | `kubectl logs <pod>` | Check backend health |

## Resources
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
