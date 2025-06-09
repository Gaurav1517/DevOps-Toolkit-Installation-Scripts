#!/bin/bash

set -e  

echo "📥 Downloading the latest kubectl binary..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "🔐 Making kubectl executable..."
chmod +x kubectl

echo "🚚 Moving kubectl to /usr/local/bin (requires sudo)..."
sudo mv kubectl /usr/local/bin/

echo "✅ Verifying kubectl installation..."
kubectl version --client

echo "🎉 kubectl installation completed successfully!"
