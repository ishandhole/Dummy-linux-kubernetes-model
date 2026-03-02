# Interactive Kubernetes Live Demo 🚀

This project provides a comprehensive, interactive Kubernetes demonstration environment designed to easily showcase the core capabilities of modern container orchestration. At its heart lies a custom-built, lightweight Node.js web application, containerized via Docker, serving as the live testing ground. 

The repository includes everything required to instantly launch a local cluster using Minikube. A streamlined `setup.sh` script completely automates environment configuration, initial image building, and the application of declarative YAML manifests (Deployments and Services). 

Once deployed, the project provides a highly visual, hands-on learning experience. The real magic happens through the `DEMO_COMMANDS.sh` presentation tool—an intuitive command-line menu that guides presenters through three powerful live scenarios: 

1. **Self-Healing:** Recovering from intentional, simulated container crashes in seconds.
2. **Auto-Scaling:** Dynamically expanding and shrinking pod replicas to safely handle simulated traffic spikes.
3. **Rolling Updates:** Deploying a "v2" application version with zero service architecture interruption.

Perfect for educational sessions, live technical presentations, or developers new to the ecosystem, this project effectively contrasts modern Kubernetes automation with legacy server management by letting users directly interact with and break a live system without consequences.

## 🛠️ Prerequisites

Before you start, ensure you have the following installed on your machine (Linux/macOS):
- [Docker](https://docs.docker.com/get-docker/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## 🚀 Getting Started

The project is split into two phases: **Setup** and **Live Demos**.

### Phase 1: Environment Setup

Run the automated setup script. This script will start Minikube, build the Docker images directly inside the Minikube registry, deploy the initial Kubernetes manifests (`deployment.yaml` and `service.yaml`), and open the live web app in your browser.

```bash
bash setup.sh
```

### Phase 2: Live Demos

Once the setup is complete and the application is running, launch the interactive demo script:

```bash
bash DEMO_COMMANDS.sh
```

This presents a menu with the following live scenarios to execute and present:

*   **1) Self-Healing (Auto-Restart):** Watch Kubernetes automatically detect a simulated container crash and spin up a healthy replacement pod in under 30 seconds, demonstrating zero manual intervention.
*   **2) Auto-Scaling:** See how the platform handles traffic spikes by scaling the application footprint from 3 up to 6 replicas instantly, then safely winding back down with zero service interruption.
*   **3) Zero-Downtime Rolling Updates:** Follow a complete application version swap (`v1` to `v2`) where Kubernetes strategically swaps out old pods for new ones one by one, ensuring continuous availability for users.

## 📁 Repository Structure

*   **/app**: Contains the lightweight Node.js web server (`server.js`) and its `Dockerfile`.
*   **/k8s**: Holds the core Kubernetes YAML manifests:
    *   `deployment.yaml` (Base v1 deployment)
    *   `deployment-v2.yaml` (Updated v2 deployment for the rolling update demo)
    *   `service.yaml` (LoadBalancer/NodePort service expose)
*   **`setup.sh`**: The automated environment bootstrapper.
*   **`DEMO_COMMANDS.sh`**: The interactive presentation menu & script.
*   **`Practical_Implementation_Guide.docx`**: Additional project documentation/guide.
