# Topic 2: Docker Compose

**Difficulty:** 🟡 Intermediate | **Time:** ⏱️ 75 min


## Introduction
Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services, networks, and volumes.

## Key Concepts

### What is Docker Compose?
- Tool for orchestrating multiple containers
- Define entire application stack in single file
- Start/stop all services with single command
- Ideal for development environments and testing

### Compose File Structure
```yaml
version: '3.8'

services:
  web:
    # Service configuration
  db:
    # Service configuration
  cache:
    # Service configuration

volumes:
  # Volume definitions

networks:
  # Network definitions
```

## Essential Commands

```bash
# Start all services
docker-compose up

# Start in detached mode
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs

# View logs for specific service
docker-compose logs web

# List running containers
docker-compose ps

# Build images
docker-compose build

# Rebuild and restart
docker-compose up --build

# Scale services
docker-compose up --scale web=3

# Execute command in service
docker-compose exec web bash

# View resource usage
docker-compose top
```

## Complete Example: Full Stack Application

### docker-compose.yml
```yaml
version: '3.8'

services:
  # Frontend - React App
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://backend:8000
    depends_on:
      - backend
    networks:
      - app-network
    volumes:
      - ./frontend/src:/app/src
      - frontend_node_modules:/app/node_modules

  # Backend - Node.js API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:password@db:5432/appdb
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    networks:
      - app-network
    volumes:
      - ./backend/src:/app/src

  # Database - PostgreSQL
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: appdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Cache - Redis
  cache:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Reverse Proxy - Nginx
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - frontend
      - backend
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
  frontend_node_modules:
```

### Environment Files (.env)
```bash
# .env.example
NODE_ENV=development
DATABASE_URL=postgresql://user:password@db:5432/appdb
REDIS_URL=redis://cache:6379
POSTGRES_USER=user
POSTGRES_PASSWORD=secure_password_here
POSTGRES_DB=appdb
```

### Backend Dockerfile (backend/Dockerfile)
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 8000

CMD ["npm", "run", "dev"]
```

### Frontend Dockerfile (frontend/Dockerfile)
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

### Nginx Configuration (nginx.conf)
```nginx
events {
    worker_connections 1024;
}

http {
    upstream frontend {
        server frontend:3000;
    }

    upstream backend {
        server backend:8000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://frontend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        location /api {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

## Development vs Production

### Development Override (docker-compose.override.yml)
```yaml
version: '3.8'

services:
  backend:
    volumes:
      - ./backend:/app
    command: npm run dev
    ports:
      - "8000:8000"
      - "9229:9229"  # Debug port

  frontend:
    volumes:
      - ./frontend:/app
    command: npm start
    ports:
      - "3000:3000"
```

### Production Configuration (docker-compose.prod.yml)
```yaml
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.prod
    environment:
      - NODE_ENV=production

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.prod
    environment:
      - NODE_ENV=production
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  db:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
```

## Hands-On Lab

### Exercise: Deploy WordPress with MySQL

1. Create directory structure:
```bash
mkdir wordpress-lab && cd wordpress-lab
```

2. Create docker-compose.yml:
```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpresspass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wp_data:/var/www/html
    depends_on:
      db:
        condition: service_healthy
    networks:
      - wp-network

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpresspass
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - wp-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  wp_data:
  db_data:

networks:
  wp-network:
```

3. Run the stack:
```bash
docker-compose up -d
```

4. Access WordPress at http://localhost:8080

5. View logs:
```bash
docker-compose logs -f
```

6. Clean up:
```bash
docker-compose down -v
```

## Best Practices

1. **Use Specific Versions**: Pin image versions instead of using `latest`
2. **Environment Variables**: Store secrets in `.env` files, never commit them
3. **Health Checks**: Always define health checks for dependent services
4. **Named Volumes**: Use named volumes for persistent data
5. **Networks**: Create custom networks for service isolation
6. **Build Context**: Optimize build context with `.dockerignore`
7. **Resource Limits**: Set CPU and memory limits in production

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Services can't communicate | Ensure they're on same network |
| Database connection refused | Add health check and depends_on |
| Port already in use | Change host port mapping |
| Volume permissions | Use named volumes or fix UID/GID |
| Slow builds | Optimize Dockerfile layers, use multi-stage |

## Next Steps
- Learn about Docker networking modes
- Explore Docker Swarm for orchestration
- Study Kubernetes for production deployments

## Resources
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Awesome Compose Examples](https://github.com/docker/awesome-compose)
