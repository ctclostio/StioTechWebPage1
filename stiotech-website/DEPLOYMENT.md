# AWS App Runner Deployment Guide

This Astro application has been dockerized and configured for deployment on AWS App Runner.

## Prerequisites

- AWS CLI installed and configured
- Docker installed locally (for testing)
- AWS App Runner access in your AWS account

## Local Testing

1. Build the Docker image:
   ```bash
   docker build -t stiotech-website:latest .
   ```

2. Run the container locally:
   ```bash
   docker run -p 8080:8080 stiotech-website:latest
   ```

3. Visit http://localhost:8080 to test the application

## Deployment to AWS App Runner

### Option 1: Deploy from Source Code (GitHub)

1. Push your code to a GitHub repository
2. In AWS Console, navigate to App Runner
3. Create a new service
4. Select "Source code repository" as the source
5. Connect your GitHub account and select your repository
6. App Runner will automatically detect the Dockerfile and build configuration

### Option 2: Deploy from Container Registry (ECR)

1. Create an ECR repository:
   ```bash
   aws ecr create-repository --repository-name stiotech-website --region us-east-1
   ```

2. Build and tag the image:
   ```bash
   docker build -t stiotech-website:latest .
   docker tag stiotech-website:latest <your-ecr-uri>/stiotech-website:latest
   ```

3. Push to ECR:
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-ecr-uri>
   docker push <your-ecr-uri>/stiotech-website:latest
   ```

4. Create App Runner service from ECR image

## Configuration Details

- **Port**: The application runs on port 8080 (AWS App Runner default)
- **Health Check**: Available at `/` endpoint
- **Static Files**: Served by nginx with optimized caching headers
- **Build**: Multi-stage Docker build for minimal image size

## Environment Variables

No environment variables are required for basic operation. The application is configured to run on port 8080 by default.

## Custom Domain

To add a custom domain:
1. In App Runner console, go to your service
2. Navigate to "Custom domains" tab
3. Add your domain and follow the DNS configuration instructions

## Monitoring

App Runner provides built-in monitoring through CloudWatch. You can view:
- Request count
- Request latency
- CPU/Memory utilization
- Application logs