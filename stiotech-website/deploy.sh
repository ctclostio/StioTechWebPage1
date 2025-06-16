#!/bin/bash

# StioTech Deployment Script

echo "🚀 Building StioTech website..."
npm run build

echo "📦 Build complete! Files in ./dist"
echo ""
echo "📋 Next steps:"
echo "1. Run 'vercel' to deploy"
echo "2. Or push to GitHub for auto-deploy"
echo ""
echo "🌐 Domain Setup Checklist:"
echo "[ ] DNS A record: @ → 76.76.21.21"
echo "[ ] DNS CNAME: www → cname.vercel-dns.com"
echo "[ ] Add domain in Vercel dashboard"
echo "[ ] Wait 5-30 mins for DNS propagation"
echo ""
echo "✅ Your site will be live at https://stiotech.com"