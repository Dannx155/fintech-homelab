# fintech-homelab

A personal learning project exploring Kubernetes and Terraform through a fintech lens.

The application is a churn risk API — a REST service that scores bank customers by their likelihood to leave. The domain logic is drawn from real experience: seven years in DNB, including a role on a cross-functional customer retention team where behavioral data was used to identify at-risk customers and intervene before they left.

The infrastructure side explores three deployment approaches for the same application, from raw Kubernetes manifests to Terraform IaC to a combined workflow where each tool does what it does best.

---

## Application

The API exposes a single prediction endpoint. It takes five behavioral signals and returns a risk score and level.

**Risk factors:**
- `months_since_login` — inactivity is the strongest churn signal in retail banking
- `num_products` — customers with a single product are far easier to lose
- `has_mortgage` — home loans are the strongest retention factor
- `num_complaints` — escalated dissatisfaction, drawn directly from customer retention experience
- `age_years` — newer customers churn more often than established ones

**Example request:**
```json
POST /predict
{
  "months_since_login": 5,
  "num_products": 1,
  "has_mortgage": false,
  "num_complaints": 2,
  "age_years": 1
}
```

**Example response:**
```json
{
  "risk_level": "high",
  "risk_score": 100
}
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Application | Python, Flask |
| Container | Docker |
| Orchestration | Kubernetes (Docker Desktop) |
| IaC | Terraform (hashicorp/kubernetes provider) |
| Scripting | PowerShell |
| Version control | Git |

---

## Prerequisites

- Docker Desktop with Kubernetes enabled
- Terraform installed
- `kubectl` available in PATH
- PowerShell

---

## Deployment

This project intentionally implements three deployment approaches to explore how the tools differ and where each fits.

### Approach 1: Kubernetes (kubectl)

Deploys directly using raw Kubernetes manifests. Terraform plays no role here.

```powershell
.\scripts\deploy-k8s.ps1
```

This builds the Docker image, applies the namespace, deployment and service, waits for rollout, and starts port-forwarding on `localhost:5000`.

To tear down:
```powershell
.\scripts\destroy-k8s.ps1
```

### Approach 2: Terraform

Deploys the full stack — namespace, deployment and service — through the Terraform Kubernetes provider.

```powershell
.\scripts\deploy-terraform.ps1
```

To tear down:
```powershell
.\scripts\destroy-terraform.ps1
```

### Approach 3: Combined (Terraform + Kubernetes)

The most production-representative approach. Terraform creates the namespace (infrastructure), Kubernetes manifests deploy the application into it. Each tool owns what it does best.

```powershell
.\combined\deploy_com.ps1
```

---

## What I learned

Setting this up on WSL with no external network access forced a deeper understanding of how Kubernetes pulls images, how Terraform resolves providers, and what actually happens under the hood when a namespace gets stuck in `Terminating` for 90 minutes.

The combined approach clarified something that wasn't obvious initially: Terraform and kubectl aren't alternatives. In production, Terraform provisions the platform, Kubernetes runs the workloads. Using them as alternatives here was a stepping stone to understanding why they belong together.

---

## Project Structure

```
fintech-homelab/
├── app/
│   ├── app.py                  # Flask churn risk API
│   ├── Dockerfile
│   └── requirements.txt
├── k8s/                        # Raw Kubernetes manifests
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/                  # Terraform deploys full stack
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
├── combined/                   # Terraform (infra) + kubectl (app)
│   ├── terraform/
│   │   └── main.tf
│   ├── k8s/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── deploy_com.ps1
└── scripts/
    ├── deploy-k8s.ps1
    ├── destroy-k8s.ps1
    ├── deploy-terraform.ps1
    └── destroy-terraform.ps1
```