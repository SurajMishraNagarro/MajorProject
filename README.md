
---

# 🧩 Python To-Do Application – Production-Ready Kubernetes Deployment on AWS

This repository contains the complete infrastructure and application setup for deploying a Python-based To-Do web application on a **highly available, production-grade Kubernetes cluster** on AWS, provisioned using **Kops** and managed via **Terraform**.

It incorporates essential DevOps practices including **secure Docker image management**, **Helm-based deployment**, and **real-time monitoring using Prometheus and Grafana**.

---

## 📁 Repository Structure

```
.
├── Dockerfile                         # Container specification
├── run.py                             # Application entry point
├── requirements.txt                   # Python dependencies
├── instance/users.db                  # SQLite database (for development/demo)
├── app/                               # Application logic (Flask)
│   ├── auth.py, forms.py, routes.py   # Auth, routing, form handlers
│   ├── static/, templates/            # CSS, JS, HTML templates
├── helm/                              # Helm chart for Kubernetes deployment
│   └── python_proj/
│       ├── Chart.yaml, values.yaml    # Helm configuration
│       └── templates/                 # K8s manifests: deployment, service, etc.
├── kops-cluster/
│   └── kubernetes.tf                  # Terraform script to provision Kops cluster
└── README.md
```

---

## 🔧 Infrastructure Overview

### ✅ Kubernetes Provisioning with Kops (via Terraform)

* **1 master + 1 worker** configuration for demonstration and testing purposes.
* Cluster created and managed using **Terraform** for reproducibility and IaC (Infrastructure as Code).
* AWS resources used: EC2, VPC, Route53 (DNS), S3 (Kops state store).

### ✅ Docker Image Security

* Application containerized using a custom **Dockerfile**.
* Image scanned using **Trivy** to detect vulnerabilities before deployment.
* All critical/high vulnerabilities are addressed during the build process.

### ✅ Helm-Based Application Deployment

* Helm chart located under `helm/python_proj/`.
* Supports configuration overrides using `values.yaml`.
* Application is deployed into a **dedicated namespace** to ensure isolation and resource control.

### ✅ Monitoring Stack

* Prometheus and Grafana deployed via the official **Kube Prometheus Stack** Helm chart.
* Application-specific `ServiceMonitor` configured for metrics scraping.
* Grafana dashboards created to monitor key application and pod-level metrics.

---

## 🚀 Deployment Workflow

### 1. Provision Kubernetes Cluster

Navigate to `kops-cluster/`:

```bash
terraform init
terraform apply
```

Ensure required AWS IAM policies, DNS setup (Route53), and S3 state bucket for Kops are pre-configured.

### 2. Deploy Application via Helm

```bash
helm install todo-app ./helm/python_proj --namespace todo --create-namespace
```

To upgrade:

```bash
helm upgrade todo-app ./helm/python_proj --namespace todo
```

### 3. Deploy Monitoring Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitor prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

---

## 📊 Observability & Metrics

* Prometheus scrapes application metrics via `ServiceMonitor`.
* Grafana dashboards can be imported or customized via UI.
* Supports pod-level, node-level, and application-specific metrics.

---

## 🛡️ Security Best Practices Implemented

* Docker image vulnerability scan integrated using **Trivy**
* Namespace-based resource isolation
* No hardcoded secrets; sensitive values to be stored in **Kubernetes Secrets**
* Infrastructure versioned and reproducible via Terraform

---

## 🧑‍💼 Maintained By

**Suraj Mishra**
DevOps Trainee
Nagarro
[LinkedIn](https://www.linkedin.com/in/suraj-mishra07/) • [GitHub](https://github.com/SurajMishraNagarro)

---
