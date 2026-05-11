# 🧪 Lab 1: Deploy a Node.js App with Docker + GitHub Actions

## 🎯 Goal
Build a Node.js app → Dockerize it → Auto-deploy using GitHub Actions CI/CD pipeline.

## 📋 Prerequisites
- GitHub account
- Docker installed locally
- Node.js installed locally

---

## Step 1: Create the Node.js App

```bash
mkdir my-node-app && cd my-node-app
npm init -y
npm install express
```

Create `app.js`:
```javascript
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Hello from DevOps!', version: '1.0.0' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

## Step 2: Dockerize the App

Create `Dockerfile`:
```dockerfile
# Use lightweight Node image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files first (layer caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1

# Run app
CMD ["node", "app.js"]
```

Create `.dockerignore`:
```
node_modules
npm-debug.log
.git
.github
*.md
```

---

## Step 3: Build & Test Locally

```bash
# Build image
docker build -t my-node-app:1.0 .

# Run container
docker run -d -p 3000:3000 --name myapp my-node-app:1.0

# Test
curl http://localhost:3000
curl http://localhost:3000/health

# Check logs
docker logs myapp

# Stop
docker stop myapp && docker rm myapp
```

---

## Step 4: Create Docker Compose

Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

```bash
docker compose up -d
docker compose logs -f
docker compose down
```

---

## Step 5: GitHub Actions CI/CD Pipeline

Create `.github/workflows/ci-cd.yml`:
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

  build:
    name: Build & Push Docker Image
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/my-node-app:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/my-node-app:${{ github.sha }}
```

---

## Step 6: Add GitHub Secrets

In your GitHub repo → Settings → Secrets → Actions:
- `DOCKERHUB_USERNAME` — your Docker Hub username
- `DOCKERHUB_TOKEN` — Docker Hub access token (not password)

---

## ✅ What You Learned
- Containerizing a Node.js app
- Multi-stage Docker best practices
- Docker Compose for local dev
- CI/CD with GitHub Actions
- Pushing images to Docker Hub
