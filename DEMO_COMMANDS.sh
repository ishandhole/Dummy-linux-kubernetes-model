#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# THE 3 LIVE DEMOS — Run AFTER setup.sh
# Show these ONE BY ONE to sir, explaining each demo
# ═══════════════════════════════════════════════════════════════════════════════


# ╔══════════════════════════════════════════════════════════════╗
# ║  DEMO 1: SELF-HEALING (Auto-Restart)                         ║
# ║  Shows: Kubernetes detects a crash and restarts it           ║
# ╚══════════════════════════════════════════════════════════════╝
demo1_self_healing() {
  echo ""
  echo "════════════════════════════════════════════"
  echo " DEMO 1: SELF-HEALING (Auto-Restart)"
  echo "════════════════════════════════════════════"
  echo ""
  echo "SAY TO SIR:"
  echo '  "Before Kubernetes — if an app crashed at 3am,'
  echo '   an engineer had to wake up and restart it manually.'
  echo '   Now watch what Kubernetes does automatically."'
  echo ""
  echo "STEP 1 — Watch pods in real time (keep this terminal open):"
  echo "  kubectl get pods --watch"
  echo ""
  echo "STEP 2 — In ANOTHER terminal, delete a pod to simulate a crash:"
  echo "  kubectl delete pod \$(kubectl get pod -l app=k8s-demo -o jsonpath='{.items[0].metadata.name}')"
  echo ""
  echo "STEP 3 — OR go to browser and click the RED 'CRASH this app' button"
  echo ""
  echo "WHAT SIR WILL SEE:"
  echo "  Pod status: Running → Terminating → ContainerCreating → Running"
  echo "  Time taken: Under 30 seconds — completely automatic!"
  echo ""
  echo "Starting watch mode now..."
  kubectl get pods --watch
}


# ╔══════════════════════════════════════════════════════════════╗
# ║  DEMO 2: AUTO-SCALING                                        ║
# ║  Shows: Kubernetes adds more copies when needed              ║
# ╚══════════════════════════════════════════════════════════════╝
demo2_scaling() {
  echo ""
  echo "════════════════════════════════════════════"
  echo " DEMO 2: AUTO-SCALING"
  echo "════════════════════════════════════════════"
  echo ""
  echo "SAY TO SIR:"
  echo '  "Before Kubernetes — scaling during a traffic spike'
  echo '   took hours of manual server setup. Now watch:"'
  echo ""
  echo "STEP 1 — See current pods (3 running):"
  kubectl get pods
  echo ""
  echo "STEP 2 — Scale UP to 6 copies with ONE command:"
  kubectl scale deployment k8s-demo-app --replicas=6
  echo ""
  echo "STEP 3 — Watch new pods appear instantly:"
  kubectl get pods --watch &
  WATCH_PID=$!
  sleep 8
  kill $WATCH_PID 2>/dev/null
  echo ""
  echo "STEP 4 — Scale back DOWN to 2 copies:"
  kubectl scale deployment k8s-demo-app --replicas=2
  sleep 3
  kubectl get pods
  echo ""
  echo "WHAT SIR WILL SEE:"
  echo "  Pods appear/disappear in under 30 seconds"
  echo "  Zero downtime — service never stopped!"
}


# ╔══════════════════════════════════════════════════════════════╗
# ║  DEMO 3: ZERO-DOWNTIME ROLLING UPDATE                        ║
# ║  Shows: Update app version without any downtime              ║
# ╚══════════════════════════════════════════════════════════════╝
demo3_rolling_update() {
  echo ""
  echo "════════════════════════════════════════════"
  echo " DEMO 3: ROLLING UPDATE — Zero Downtime"
  echo "════════════════════════════════════════════"
  echo ""
  echo "SAY TO SIR:"
  echo '  "Before Kubernetes — updating an app meant shutting'
  echo '   it down first, causing downtime. Now watch K8s'
  echo '   swap the version live, one pod at a time:"'
  echo ""
  echo "STEP 1 — Current version (v1), 3 pods running:"
  kubectl get pods
  echo ""
  echo "STEP 2 — Build v2 image first:"
  eval $(minikube docker-env)
  cd app && docker build -t k8s-demo:v2 . && cd ..
  echo ""
  echo "STEP 3 — Apply the v2 deployment (scaled to 5, new image):"
  kubectl apply -f k8s/deployment-v2.yaml
  echo ""
  echo "STEP 4 — Watch the rolling update happen:"
  kubectl rollout status deployment/k8s-demo-app
  echo ""
  echo "STEP 5 — See all pods now running v2:"
  kubectl get pods
  echo ""
  echo "STEP 6 — If something went wrong, rollback instantly:"
  echo "  kubectl rollout undo deployment/k8s-demo-app"
  echo ""
  echo "WHAT SIR WILL SEE:"
  echo "  Old pods removed one at a time, new pods added one at a time"
  echo "  App was NEVER fully down — users saw zero interruption!"
}


# ─── MENU ────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  KUBERNETES LIVE DEMO — Choose a demo:      ║"
echo "║                                              ║"
echo "║  1. Self-Healing (auto-restart after crash)  ║"
echo "║  2. Auto-Scaling (add/remove pods)           ║"
echo "║  3. Rolling Update (zero downtime deploy)    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
read -p "Enter demo number (1/2/3): " choice

case $choice in
  1) demo1_self_healing ;;
  2) demo2_scaling ;;
  3) demo3_rolling_update ;;
  *) echo "Run: bash DEMO_COMMANDS.sh and enter 1, 2, or 3" ;;
esac
