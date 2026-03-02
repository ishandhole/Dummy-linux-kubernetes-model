#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# KUBERNETES + LINUX PRACTICAL DEMO SCRIPT
# Srishti (L001) & Akshada Jangam (L025)
# Run these commands ONE BY ONE while explaining to sir
# ═══════════════════════════════════════════════════════════════════════════════

echo "
╔══════════════════════════════════════════════════════════════╗
║         KUBERNETES + LINUX — LIVE DEMO                       ║
║         Ishan (L016), Vivaan (L014), Dhvanish (L015)         ║
╚══════════════════════════════════════════════════════════════╝
"

# ─────────────────────────────────────────────────────────────
# STEP 1: PREREQUISITES CHECK
# ─────────────────────────────────────────────────────────────
echo "── STEP 1: Check tools are installed ──────────────────────────"
docker --version
minikube version
kubectl version --client
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 2: START MINIKUBE (Local Kubernetes on Linux)
# ─────────────────────────────────────────────────────────────
echo "── STEP 2: Start Minikube (local Kubernetes cluster) ──────────"
echo "SAY TO SIR: Minikube creates a real Kubernetes cluster on your laptop using Linux"
echo ""
minikube start
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 3: BUILD DOCKER IMAGE
# ─────────────────────────────────────────────────────────────
echo "── STEP 3: Build Docker container image ──────────────────────"
echo "SAY TO SIR: We package our app into a Docker container — this is Layer 2 of our architecture"
echo ""
cd app
eval $(minikube docker-env)   # Use Minikube's Docker
docker build -t k8s-demo:v1 .
echo "✅ Image built! Let's see it:"
docker images | grep k8s-demo
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 4: DEPLOY TO KUBERNETES
# ─────────────────────────────────────────────────────────────
echo "── STEP 4: Deploy app to Kubernetes ──────────────────────────"
echo "SAY TO SIR: One command deploys 3 copies of our app across Linux servers"
echo ""
cd ../k8s
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
echo ""
echo "Waiting for pods to start..."
kubectl rollout status deployment/k8s-demo-app
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 5: SHOW RUNNING PODS
# ─────────────────────────────────────────────────────────────
echo "── STEP 5: See all 3 running pods ────────────────────────────"
echo "SAY TO SIR: Kubernetes is running 3 copies of our app, each in its own Linux container"
echo ""
kubectl get pods -o wide
echo ""
kubectl get services
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 6: OPEN IN BROWSER
# ─────────────────────────────────────────────────────────────
echo "── STEP 6: Open app in browser ───────────────────────────────"
echo "SAY TO SIR: Here is our live app running inside Kubernetes on Linux!"
echo ""
minikube service k8s-demo-service
echo ""

echo "
╔══════════════════════════════════════════════════════════════╗
║  NOW DO THE 3 LIVE DEMOS IN BROWSER + TERMINAL              ║
║  See DEMO_COMMANDS.sh for each demo separately               ║
╚══════════════════════════════════════════════════════════════╝
"
