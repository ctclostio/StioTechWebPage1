#\!/bin/bash
echo "=== Checking AWS Identity ==="
aws sts get-caller-identity

echo -e "\n=== Checking IAM Permissions ==="
aws iam get-user 2>/dev/null || echo "No IAM user access"

echo -e "\n=== Checking if you can list access keys ==="
aws iam list-access-keys 2>/dev/null || echo "Cannot list access keys"

echo -e "\n=== Checking if you're using temporary credentials ==="
aws sts get-session-token 2>/dev/null || echo "Not using session token"

echo -e "\n=== Checking ECR permissions ==="
aws ecr describe-repositories 2>/dev/null || echo "Cannot list ECR repositories"

echo -e "\n=== Checking App Runner permissions ==="
aws apprunner list-services 2>/dev/null || echo "Cannot list App Runner services"
EOF < /dev/null
