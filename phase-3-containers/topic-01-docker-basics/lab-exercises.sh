#!/bin/bash
# Docker Basics Lab Exercises
# Run each section to practice Docker commands

set -e

echo "========================================="
echo "Docker Basics Lab Exercises"
echo "========================================="

# Exercise 1: Pull and Run NGINX
echo -e "\n[Exercise 1] Pull and Run NGINX Container"
echo "Pulling nginx:alpine image..."
docker pull nginx:alpine

echo "Running nginx container on port 8080..."
docker run -d -p 8080:80 --name lab-nginx nginx:alpine

echo "Waiting for container to start..."
sleep 2

echo "Testing connection..."
if curl -s http://localhost:8080 > /dev/null; then
    echo "✓ NGINX is running successfully!"
else
    echo "✗ Failed to connect to NGINX"
fi

echo "Container logs:"
docker logs --tail 5 lab-nginx

# Exercise 2: Inspect Container
echo -e "\n[Exercise 2] Inspect Container Details"
echo "Container IP address:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lab-nginx

echo "Container ports mapping:"
docker port lab-nginx

# Exercise 3: Execute Commands Inside Container
echo -e "\n[Exercise 3] Execute Commands Inside Container"
echo "NGINX version inside container:"
docker exec lab-nginx nginx -v

echo "Listing files in html directory:"
docker exec lab-nginx ls -la /usr/share/nginx/html/

# Exercise 4: Create Custom Image
echo -e "\n[Exercise 4] Build Custom Image"
mkdir -p /tmp/docker-lab
cd /tmp/docker-lab

echo '<!DOCTYPE html><html><head><title>Lab</title></head><body><h1>Hello from Custom Docker Image!</h1></body></html>' > index.html

cat > Dockerfile << 'DOCKERFILE'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/custom.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
DOCKERFILE

echo "Building custom-image..."
docker build -t custom-nginx .

echo "Running custom image on port 8081..."
docker run -d -p 8081:80 --name custom-lab custom-nginx

sleep 2

echo "Testing custom page..."
if curl -s http://localhost:8081/custom.html | grep -q "Hello from Custom"; then
    echo "✓ Custom image working correctly!"
else
    echo "✗ Custom page not found"
fi

# Exercise 5: Resource Limits
echo -e "\n[Exercise 5] Run Container with Resource Limits"
docker run -d --cpus="0.5" --memory="128m" --name limited-nginx nginx:alpine

echo "Container with CPU limit: 0.5 cores"
echo "Container with Memory limit: 128MB"

echo "Viewing resource usage..."
docker stats --no-stream limited-nginx

# Cleanup
echo -e "\n[Cleanup] Removing all lab containers..."
docker stop lab-nginx custom-lab limited-nginx 2>/dev/null || true
docker rm lab-nginx custom-lab limited-nginx 2>/dev/null || true
docker rmi custom-nginx 2>/dev/null || true

rm -rf /tmp/docker-lab

echo -e "\n========================================="
echo "Lab Exercises Completed Successfully!"
echo "========================================="
