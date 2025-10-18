# Infrastructure-First Microservice Platform

An infrastructure-first microservice platform for crafting intelligent insights from data using AWS and AI pipelines.

## Tech Stack

- **Terraform** - Infrastructure as Code
- **Kubernetes** - Container orchestration
- **Docker** - Containerization
- **GitHub Actions** - CI/CD automation
- **AWS** - Cloud infrastructure

## Services

- **insightric-auth-service** - Auth & user management in Nest (JWT, roles, Cognito integration)
- **insightric-upload-service** - Dataset uploads & ingestion triggers
- **insightric-processing-service** - Cleansing & aggregation of data
- **insightric-ai-service** - AI summarization and insight generation
- **insightric-insight-hub** - Data access, analytics, visualization API
- **insightric-notifier-service** - SNS/SES message dispatching

## Getting Started

### Prerequisites

- Git
- Docker
- Terraform
- kubectl
- AWS CLI

### Setup

Clone the repository with submodules:

```bash
git clone --recurse-submodules https://github.com/insightric/insightric-infrastructure.git
cd insightric-infrastructure
```

Or if already cloned, initialize submodules:

```bash
./scripts/setup.sh
```

### Submodules

This repository uses Git submodules for each microservice. The services are located in the `services/` directory and are maintained as separate repositories:

- `services/insightric-auth-service` - Authentication and user management
- `services/insightric-upload-service` - Dataset upload and ingestion
- `services/insightric-processing-service` - Data cleansing and aggregation
- `services/insightric-ai-service` - AI-powered insights
- `services/insightric-insight-hub` - Analytics and visualization
- `services/insightric-notifier-service` - Notification dispatching

To update all submodules to their latest commits:

```bash
git submodule update --remote
```

## Infrastructure

Infrastructure configurations are in the `infra/` directory:

- `infra/terraform/` - AWS infrastructure as code
- `infra/kubernetes/` - Kubernetes manifests

## Monitoring

Monitoring configurations are in the `monitoring/` directory:

- `monitoring/prometheus/` - Prometheus metrics
- `monitoring/grafana/` - Grafana dashboards
- `monitoring/cloudwatch/` - AWS CloudWatch alarms

## Scripts

- `scripts/setup.sh` - Initialize submodules and setup
- `scripts/deploy.sh` - Deployment script
- `scripts/test.sh` - Test runner
