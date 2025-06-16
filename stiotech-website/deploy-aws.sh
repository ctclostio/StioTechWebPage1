#!/bin/bash

# AWS S3 + CloudFront Deployment Script for StioTech

# Configuration
BUCKET_NAME="stiotech.com"
REGION="us-east-1"  # Must be us-east-1 for CloudFront
DIST_DIR="./dist"

echo "🚀 Deploying StioTech to AWS S3..."

# Create S3 bucket for static hosting
echo "Creating S3 bucket..."
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --acl public-read

# Enable static website hosting
echo "Configuring static website hosting..."
aws s3 website s3://$BUCKET_NAME/ \
    --index-document index.html \
    --error-document 404.html

# Create bucket policy for public access
cat > /tmp/bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
        }
    ]
}
EOF

aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy file:///tmp/bucket-policy.json

# Upload files
echo "Uploading website files..."
aws s3 sync $DIST_DIR s3://$BUCKET_NAME \
    --delete \
    --cache-control "public, max-age=3600"

# Create CloudFront distribution
echo "Creating CloudFront distribution..."
cat > /tmp/cloudfront-config.json << EOF
{
    "CallerReference": "stiotech-$(date +%s)",
    "DefaultRootObject": "index.html",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "S3-${BUCKET_NAME}",
                "DomainName": "${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com",
                "CustomOriginConfig": {
                    "HTTPPort": 80,
                    "HTTPSPort": 443,
                    "OriginProtocolPolicy": "http-only"
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "S3-${BUCKET_NAME}",
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
            "Quantity": 2,
            "Items": ["GET", "HEAD"]
        },
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "ForwardedValues": {
            "QueryString": false,
            "Cookies": {
                "Forward": "none"
            }
        },
        "MinTTL": 0,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000
    },
    "Comment": "StioTech Website Distribution",
    "Enabled": true,
    "Aliases": {
        "Quantity": 2,
        "Items": ["stiotech.com", "www.stiotech.com"]
    },
    "ViewerCertificate": {
        "ACMCertificateArn": "YOUR_CERTIFICATE_ARN",
        "SSLSupportMethod": "sni-only"
    }
}
EOF

# Note: You'll need to create ACM certificate first
echo "📌 Next steps:"
echo "1. Request ACM certificate for stiotech.com"
echo "2. Update the certificate ARN in cloudfront-config.json"
echo "3. Create CloudFront distribution"
echo "4. Update Route 53 records to point to CloudFront"

echo ""
echo "🌐 Your S3 website URL: http://${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com"