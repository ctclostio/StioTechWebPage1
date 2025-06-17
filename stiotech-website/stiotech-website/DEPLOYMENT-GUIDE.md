# StioTech Site Deployment Guide

## Quick Reference
```bash
# Environment Variables (add to your ~/.bashrc or ~/.zshrc)
export AWS_REGION=us-west-2
export AWS_ACCOUNT_ID=154208992633
export ECR_REPO=stiotech-site
export APP_RUNNER_ARN="arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670"
export ECR_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO
```

## Deploy Updates - Step by Step

### 1. Navigate to Project
```bash
cd /path/to/stiotech-website
```

### 2. Make Your Code Changes
Edit your files, test locally with:
```bash
npm run dev
```

### 3. Build Docker Image
```bash
docker build -t stiotech-site .
```

### 4. Login to ECR
```bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 154208992633.dkr.ecr.us-west-2.amazonaws.com
```

### 5. Tag Image
```bash
docker tag stiotech-site:latest 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest
```

### 6. Push to ECR
```bash
docker push 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest
```

### 7. Deploy to App Runner
```bash
aws apprunner start-deployment \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2
```

### 8. Check Deployment Status
```bash
aws apprunner describe-service \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2 \
    --query 'Service.Status' \
    --output text
```

## One-Line Deploy Script
Save this as `deploy.sh`:
```bash
#!/bin/bash
set -e

echo "🚀 Building Docker image..."
docker build -t stiotech-site .

echo "🔐 Logging into ECR..."
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 154208992633.dkr.ecr.us-west-2.amazonaws.com

echo "🏷️  Tagging image..."
docker tag stiotech-site:latest 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest

echo "📤 Pushing to ECR..."
docker push 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest

echo "🚢 Deploying to App Runner..."
aws apprunner start-deployment \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2

echo "✅ Deployment started! Check status with:"
echo "aws apprunner describe-service --service-arn 'arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670' --region us-west-2 --query 'Service.Status' --output text"
```

Make it executable:
```bash
chmod +x deploy.sh
```

Then deploy with:
```bash
./deploy.sh
```

## Deploy with Git Commit Hash (Recommended)
For better version tracking:
```bash
#!/bin/bash
set -e

COMMIT_HASH=$(git rev-parse --short HEAD)
IMAGE_TAG="154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:$COMMIT_HASH"

echo "🚀 Building Docker image with tag: $COMMIT_HASH"
docker build -t stiotech-site:$COMMIT_HASH .

echo "🔐 Logging into ECR..."
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 154208992633.dkr.ecr.us-west-2.amazonaws.com

echo "🏷️  Tagging image..."
docker tag stiotech-site:$COMMIT_HASH $IMAGE_TAG
docker tag stiotech-site:$COMMIT_HASH 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest

echo "📤 Pushing to ECR..."
docker push $IMAGE_TAG
docker push 154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest

echo "🚢 Deploying to App Runner..."
aws apprunner start-deployment \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2

echo "✅ Deployed version: $COMMIT_HASH"
```

## Useful Commands

### View Deployment Logs
```bash
aws apprunner list-operations \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2
```

### Get Service Details
```bash
aws apprunner describe-service \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --region us-west-2
```

### List All ECR Images
```bash
aws ecr list-images \
    --repository-name stiotech-site \
    --region us-west-2
```

### Delete Old ECR Images (Keep last 5)
```bash
aws ecr list-images --repository-name stiotech-site --region us-west-2 \
    --query 'imageIds[:-5]' --output json | \
    jq '.[] | {imageDigest: .imageDigest}' | \
    jq -s '.' | \
    aws ecr batch-delete-image --repository-name stiotech-site --region us-west-2 --image-ids file:///dev/stdin
```

## Troubleshooting

### Docker Login Failed
```bash
# Make sure you're in the right region
aws configure get region

# Try explicit region
AWS_REGION=us-west-2 aws ecr get-login-password | docker login --username AWS --password-stdin 154208992633.dkr.ecr.us-west-2.amazonaws.com
```

### Push Failed - Repository Not Found
```bash
# Check if repository exists
aws ecr describe-repositories --region us-west-2

# Create if missing
aws ecr create-repository --repository-name stiotech-site --region us-west-2
```

### App Runner Not Updating
```bash
# Force new deployment
aws apprunner update-service \
    --service-arn "arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/2d900e125d384547b799db122167c670" \
    --source-configuration '{
        "ImageRepository": {
            "ImageIdentifier": "154208992633.dkr.ecr.us-west-2.amazonaws.com/stiotech-site:latest",
            "ImageConfiguration": {"Port": "8080"},
            "ImageRepositoryType": "ECR"
        },
        "AutoDeploymentsEnabled": false,
        "AuthenticationConfiguration": {
            "AccessRoleArn": "arn:aws:iam::154208992633:role/AppRunnerECRAccessRole"
        }
    }' \
    --region us-west-2
```

## Important URLs
- **Live Site**: https://smgpxv4xcs.us-west-2.awsapprunner.com
- **AWS Console - App Runner**: https://us-west-2.console.aws.amazon.com/apprunner/home?region=us-west-2#/services
- **AWS Console - ECR**: https://us-west-2.console.aws.amazon.com/ecr/repositories?region=us-west-2

## Local Development vs Production

### Local Development
```bash
npm run dev          # Start dev server on port 4321
npm run build        # Build static files
npm run preview      # Preview production build
```

### Production (Docker)
```bash
docker build -t stiotech-site .
docker run -p 8080:8080 stiotech-site
# Visit http://localhost:8080
```

## Security Notes
- Never commit AWS credentials to git
- Use IAM roles when possible
- Rotate access keys regularly
- Use CloudShell for sensitive operations

## Cost Optimization
- App Runner charges per vCPU hour + requests
- Consider setting auto-scaling min instances to 0 for dev/test
- Delete old ECR images regularly
- Monitor costs in AWS Cost Explorer

---
Last Updated: 2025-06-17
Service ARN: arn:aws:apprunner:us-west-2:154208992633:service/stiotech-site/99001d0e25c6401781478f4916e96e77