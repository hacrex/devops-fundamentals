# Topic 3: Kubernetes Architecture

## Introduction
Kubernetes (K8s) is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications.

## Core Architecture Components

### Control Plane (Master Node)
The brain of the cluster that makes global decisions and detects/responds to cluster events.

```
┌─────────────────────────────────────────────────────┐
│                 Control Plane                        │
│  ┌──────────────┐  ┌──────────────┐                │
│  │  kube-apiserver │  │ etcd        │                │
│  │  - API endpoint │  │ - Key-value │                │
│  │  - Auth/Authz   │  │   store     │                │
│  └──────────────┘  └──────────────┘                │
│  ┌──────────────┐  ┌──────────────┐                │
│  │kube-scheduler│  │kube-controller│                │
│  │- Pod placement│  │- Reconciliation│               │
│  │- Resource fit │  │  loops       │                │
│  └──────────────┘  └──────────────┘                │
│         │              │                            │
│         └──────┬───────┘                            │
│                ▼                                   │
│        ┌──────────────┐                            │
│        │ cloud-controller │                         │
│        │ - Cloud integration│                        │
│        └──────────────┘                            │
└─────────────────────────────────────────────────────┘
```

#### 1. kube-apiserver
- Frontend for Kubernetes control plane
- Validates and configures data for API objects
- Serves REST operations
- Only component that communicates with etcd

#### 2. etcd
- Consistent, highly-available key-value store
- Stores all cluster data and state
- Backup regularly for disaster recovery

#### 3. kube-scheduler
- Watches for newly created Pods
- Selects optimal node for Pod placement
- Considers resource requirements, constraints, affinity

#### 4. kube-controller-manager
- Runs controller processes
- Node controller, replication controller, endpoints controller
- Ensures desired state matches current state

#### 5. cloud-controller-manager
- Links cluster to cloud provider's API
- Handles cloud-specific control loops

### Worker Nodes
Where application workloads actually run.

```
┌─────────────────────────────────────────────────────┐
│                  Worker Node                         │
│  ┌──────────────┐  ┌──────────────┐                │
│  │   kubelet    │  │  kube-proxy  │                │
│  │ - Agent      │  │ - Networking │                │
│  │ - Pod lifecycle│ - Load balancing│               │
│  └──────────────┘  └──────────────┘                │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │           Container Runtime                   │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐        │  │
│  │  │Container│ │Container│ │Container│        │  │
│  │  │  Pod A  │ │  Pod B  │ │  Pod C  │        │  │
│  │  └─────────┘ └─────────┘ └─────────┘        │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

#### 1. kubelet
- Primary node agent
- Registers node with API server
- Ensures containers are running in Pods
- Reports node status

#### 2. kube-proxy
- Network proxy on each node
- Maintains network rules
- Enables communication within/across nodes
- Implements Services abstraction

#### 3. Container Runtime
- Software responsible for running containers
- Options: containerd, CRI-O, Docker Engine (deprecated)
- Must implement Kubernetes CRI (Container Runtime Interface)

## Key Objects

### Pod
- Smallest deployable unit
- One or more containers sharing storage/network
- Ephemeral by nature

### Deployment
- Declarative updates for Pods and ReplicaSets
- Manages rolling updates and rollbacks
- Ensures desired number of replicas

### Service
- Abstract way to expose application
- Stable IP address and DNS name
- Load balances across Pods

### Namespace
- Virtual cluster within physical cluster
- Resource isolation and access control
- Default, kube-system, kube-public

## Communication Flow

```
User/Admin
    │
    ▼
kubectl apply -f deployment.yaml
    │
    ▼
┌─────────────────┐
│  kube-apiserver │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐  ┌──────────┐
│ etcd  │  │scheduler │
└───────┘  └────┬─────┘
                │
                ▼
         ┌──────────────┐
         │   kubelet    │
         │  (on Node)   │
         └──────┬───────┘
                │
                ▼
         ┌──────────────┐
         │Container Runt│
         │   Creates    │
         │   Container  │
         └──────────────┘
```

## High Availability Setup

### Production Control Plane
```
                    Load Balancer
                         │
        ┌────────────────┼────────────────┐
        │                │                │
   ┌────▼────┐     ┌────▼────┐     ┌────▼────┐
   │ Master 1│     │ Master 2│     │ Master 3│
   │ etcd +  │     │ etcd +  │     │ etcd +  │
   │  API    │     │  API    │     │  API    │
   └─────────┘     └─────────┘     └─────────┘
        │                │                │
        └────────────────┼────────────────┘
                         │
              ┌──────────┼──────────┐
              │          │          │
         ┌────▼───┐ ┌────▼───┐ ┌────▼───┐
         │ Worker │ │ Worker │ │ Worker │
         │ Node 1 │ │ Node 2 │ │ Node 3 │
         └────────┘ └────────┘ └────────┘
```

## Best Practices

1. **Multiple Masters**: Always run 3+ control plane nodes for HA
2. **etcd Separation**: Run etcd on dedicated nodes for large clusters
3. **Resource Reservations**: Reserve resources for system components
4. **Network Policies**: Implement zero-trust networking
5. **Regular Updates**: Keep Kubernetes version current
6. **Monitoring**: Monitor all control plane components
7. **Backup etcd**: Regular automated backups critical

## Common Commands

```bash
# Check cluster info
kubectl cluster-info

# List nodes
kubectl get nodes

# Describe node details
kubectl describe node <node-name>

# Check component status
kubectl get componentstatuses

# View API resources
kubectl api-resources

# Check version
kubectl version --short
```

## Troubleshooting

| Issue | Command | Solution |
|-------|---------|----------|
| Node NotReady | `kubectl describe node` | Check kubelet logs |
| Pod pending | `kubectl describe pod` | Insufficient resources |
| API server down | `systemctl status kube-apiserver` | Restart service |
| etcd issues | `etcdctl member list` | Check etcd health |

## Next Steps
- Learn about Pods and Deployments
- Study Services and Networking
- Explore storage options with PersistentVolumes

## Resources
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes Architecture](https://kubernetes.io/docs/concepts/architecture/)
- [Visual Guide to Kubernetes](https://github.com/xiaopu-dev/kubernetes-full-diagram)
