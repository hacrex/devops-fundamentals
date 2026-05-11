# 🐳 Docker & kubectl Cheatsheet

## Docker — Images
```bash
docker images                    # List images
docker pull nginx                # Pull image
docker build -t myapp:1.0 .      # Build image
docker tag myapp hacrex/myapp    # Tag image
docker push hacrex/myapp         # Push to registry
docker rmi image_id              # Remove image
docker image prune               # Remove unused images
```

## Docker — Containers
```bash
docker run -d -p 80:80 nginx          # Run detached
docker run -it ubuntu bash            # Interactive shell
docker run --name myapp -d myimage    # Named container
docker run -e ENV=prod myimage        # With env vars
docker run -v /host:/container nginx  # Mount volume
docker ps                             # Running containers
docker ps -a                          # All containers
docker stop container_id              # Stop
docker start container_id             # Start
docker restart container_id           # Restart
docker rm container_id                # Remove
docker rm -f $(docker ps -aq)         # Remove all
```

## Docker — Logs & Exec
```bash
docker logs container_id          # View logs
docker logs -f container_id       # Follow logs
docker exec -it container bash    # Enter container
docker inspect container_id       # Full details
docker stats                      # Live resource usage
docker top container_id           # Processes inside
```

## Docker — Volumes & Networks
```bash
docker volume create myvol        # Create volume
docker volume ls                  # List volumes
docker volume rm myvol            # Remove volume
docker network ls                 # List networks
docker network create mynet       # Create network
docker network connect mynet ctr  # Connect container
```

## Docker Compose
```bash
docker compose up -d              # Start services
docker compose down               # Stop & remove
docker compose logs -f            # Follow logs
docker compose ps                 # List services
docker compose build              # Build images
docker compose exec svc bash      # Enter service
docker compose restart svc        # Restart service
```

---

## kubectl — Basics
```bash
kubectl version                   # Client & server version
kubectl cluster-info              # Cluster details
kubectl config get-contexts       # List contexts
kubectl config use-context name   # Switch context
kubectl get nodes                 # List nodes
```

## kubectl — Pods
```bash
kubectl get pods                          # List pods
kubectl get pods -n namespace             # In namespace
kubectl get pods -o wide                  # With node info
kubectl describe pod pod-name             # Pod details
kubectl logs pod-name                     # Pod logs
kubectl logs -f pod-name                  # Follow logs
kubectl exec -it pod-name -- bash         # Enter pod
kubectl delete pod pod-name               # Delete pod
kubectl run nginx --image=nginx           # Quick run
```

## kubectl — Deployments
```bash
kubectl get deployments                          # List
kubectl create deployment app --image=nginx      # Create
kubectl scale deployment app --replicas=3        # Scale
kubectl set image deployment/app nginx=nginx:1.25 # Update image
kubectl rollout status deployment/app            # Rollout status
kubectl rollout undo deployment/app              # Rollback
kubectl delete deployment app                    # Delete
```

## kubectl — Services
```bash
kubectl get svc                                       # List services
kubectl expose deployment app --port=80 --type=NodePort  # Expose
kubectl port-forward svc/app 8080:80                  # Port forward
kubectl delete svc app                                # Delete
```

## kubectl — Config & Namespaces
```bash
kubectl get namespaces                        # List namespaces
kubectl create namespace dev                  # Create namespace
kubectl apply -f manifest.yaml               # Apply manifest
kubectl delete -f manifest.yaml              # Delete from manifest
kubectl get all -n namespace                  # All resources
kubectl top pods                              # Resource usage
kubectl get events --sort-by='.lastTimestamp' # Recent events
```
