# Docker Cheatsheet

## Quick Reference for Docker Commands

### Images
```bash
docker pull nginx:latest                # Pull image
docker images                           # List images
docker build -t myapp:1.0 .             # Build image
docker build --no-cache -t myapp .      # Build without cache
docker rmi <image-id>                   # Remove image
docker history <image>                  # Image layers
docker tag old:new                      # Tag image
docker push myapp:1.0                   # Push to registry
docker save -o image.tar myapp          # Save to file
docker load -i image.tar                # Load from file
```

### Containers
```bash
docker run -d nginx                     # Run detached
docker run -it ubuntu bash              # Interactive
docker run -p 8080:80 nginx             # Port mapping
docker run -v /data:/app/data nginx     # Volume mount
docker run --name web nginx             # Named container
docker ps                               # Running containers
docker ps -a                            # All containers
docker stop <container>                 # Stop container
docker start <container>                # Start container
docker restart <container>              # Restart container
docker rm <container>                   # Remove container
docker rm -f <container>                # Force remove
docker exec -it <container> bash        # Execute command
docker logs <container>                 # View logs
docker logs -f <container>              # Follow logs
docker inspect <container>              # Inspect details
docker cp file.txt container:/path      # Copy files
docker port <container>                 # Port mappings
docker top <container>                  # Processes in container
docker stats                            # Resource usage
docker diff <container>                 # File changes
```

### Networks
```bash
docker network ls                       # List networks
docker network create mynet             # Create network
docker network inspect mynet            # Network details
docker network connect mynet container  # Connect to network
docker network disconnect mynet container
docker network rm mynet                 # Remove network
```

### Volumes
```bash
docker volume ls                        # List volumes
docker volume create myvol              # Create volume
docker volume inspect myvol             # Volume details
docker volume rm myvol                  # Remove volume
docker volume prune                     # Remove unused volumes
```

### Docker Compose
```bash
docker-compose up                       # Start services
docker-compose up -d                    # Start detached
docker-compose down                     # Stop and remove
docker-compose ps                       # List containers
docker-compose logs                     # View logs
docker-compose logs -f service          # Follow logs
docker-compose build                    # Build images
docker-compose restart                  # Restart services
docker-compose stop                     # Stop services
docker-compose start                    # Start services
docker-compose exec service bash        # Execute in service
docker-compose top                      # Resource usage
docker-compose config                   # Validate config
docker-compose images                   # List images
```

### System & Cleanup
```bash
docker info                             # System information
docker version                          # Version info
docker system df                        # Disk usage
docker system prune                     # Clean up
docker system prune -a                  # Prune all unused
docker container prune                  # Remove stopped containers
docker image prune                      # Remove dangling images
docker volume prune                     # Remove unused volumes
docker network prune                    # Remove unused networks
```

### Security
```bash
docker scan <image>                     # Scan for vulnerabilities
docker trust sign <image>               # Sign image
docker trust inspect <image>            # Check signature
```

### Registry
```bash
docker login                            # Login to registry
docker logout                           # Logout
docker search nginx                     # Search images
```

### Common Patterns
```bash
# Run with environment variables
docker run -e ENV=prod -e DB_HOST=localhost myapp

# Run with resource limits
docker run --memory=512m --cpus=1.0 myapp

# Run with restart policy
docker run --restart=always myapp

# Run as specific user
docker run --user 1000:1000 myapp

# Health check
docker run --health-cmd="curl -f http://localhost/" myapp

# Multi-container with network
docker network create appnet
docker run -d --network appnet --name db postgres
docker run -d --network appnet --name web myapp
```

### Troubleshooting
```bash
# Container won't start
docker logs <container>
docker inspect <container>

# Can't connect to container
docker network inspect bridge
docker exec <container> ping google.com

# Out of disk space
docker system df
docker system prune -a

# Permission denied
docker run --user $(id -u):$(id -g) myapp
```

### Dockerfile Instructions
```dockerfile
FROM ubuntu:20.04           # Base image
LABEL maintainer="me@example.com"
WORKDIR /app                # Set working directory
COPY . .                    # Copy files
ADD archive.tar.gz /data    # Copy and extract
RUN apt-get update && apt-get install -y nginx
ENV NODE_ENV=production     # Set environment
ARG VERSION=1.0             # Build argument
EXPOSE 80                   # Expose port
VOLUME ["/data"]            # Create volume
USER appuser                # Switch user
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/app/start.sh"]
HEALTHCHECK CMD curl -f http://localhost/
STOPSIGNAL SIGTERM
```

### Best Practices
- Use specific image tags (not `latest`)
- Minimize layers in Dockerfile
- Use `.dockerignore` file
- Run as non-root user
- Use multi-stage builds
- Don't store secrets in images
- Scan images for vulnerabilities
- Use health checks
- Set resource limits
