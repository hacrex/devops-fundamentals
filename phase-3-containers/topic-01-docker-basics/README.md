# Topic 1: Docker Basics

## Introduction
Docker is a platform for developing, shipping, and running applications in containers. Containers package code and dependencies together, ensuring consistency across environments.

## Key Concepts

### What is a Container?
- Lightweight, standalone executable package
- Includes everything needed to run software: code, runtime, system tools, libraries, settings
- Isolated from host system but shares the OS kernel

### Docker Architecture
```
┌─────────────────────────────────────┐
│           Docker Client             │
└──────────────┬──────────────────────┘
               │ REST API
┌──────────────▼──────────────────────┐
│           Docker Daemon             │
│  ┌──────────┐  ┌──────────┐        │
│  │  Images  │  │ Containers│        │
│  └──────────┘  └──────────┘        │
│  ┌──────────┐  ┌──────────┐        │
│  │ Volumes  │  │ Networks  │        │
│  └──────────┘  └──────────┘        │
└─────────────────────────────────────┘
```

### Images vs Containers
- **Image**: Read-only template with instructions for creating a container
- **Container**: Runnable instance of an image

## Essential Commands

### Image Management
```bash
# Pull an image
docker pull nginx:latest

# List images
docker images

# Build an image
docker build -t myapp:1.0 .

# Remove an image
docker rmi myapp:1.0
```

### Container Management
```bash
# Run a container
docker run -d -p 8080:80 --name webserver nginx

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop webserver

# Start a stopped container
docker start webserver

# Remove a container
docker rm webserver

# View logs
docker logs webserver

# Execute command in running container
docker exec -it webserver bash
```

### Resource Management
```bash
# Limit CPU and memory
docker run -d --cpus="1.5" --memory="512m" nginx

# View container stats
docker stats

# Inspect container details
docker inspect webserver
```

## Creating a Dockerfile

### Example: Node.js Application
```dockerfile
# Use official Node.js runtime as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application source
COPY . .

# Expose port
EXPOSE 3000

# Define default command
CMD ["node", "server.js"]
```

### Best Practices
1. Use specific base image versions (not `latest`)
2. Minimize layers by combining commands
3. Use `.dockerignore` to exclude unnecessary files
4. Run as non-root user when possible
5. Use multi-stage builds for smaller images

## Hands-On Lab

### Exercise 1: Run Your First Container
```bash
# Pull and run NGINX
docker pull nginx:alpine
docker run -d -p 8080:80 --name my-nginx nginx:alpine

# Verify it's running
curl http://localhost:8080

# Clean up
docker stop my-nginx
docker rm my-nginx
```

### Exercise 2: Build Custom Image
1. Create a simple HTML file:
```bash
echo '<h1>Hello from Docker!</h1>' > index.html
```

2. Create Dockerfile:
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

3. Build and run:
```bash
docker build -t hello-docker .
docker run -d -p 8080:80 hello-docker
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Port already in use | Change host port: `-p 8081:80` |
| Container exits immediately | Check logs: `docker logs <container>` |
| Permission denied | Run as non-root or fix file permissions |
| Out of disk space | Prune unused resources: `docker system prune` |

## Next Steps
- Learn Docker Compose for multi-container applications
- Explore Docker networking and volumes
- Study container security best practices

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Play with Docker](https://labs.play-with-docker.com/)
