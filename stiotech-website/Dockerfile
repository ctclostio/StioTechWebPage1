# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci || npm install

# Copy all source files
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine-slim

# Copy built static files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration for AWS App Runner
COPY nginx.conf /etc/nginx/nginx.conf

# AWS App Runner expects port 8080
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]