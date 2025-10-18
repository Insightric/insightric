# Agent Instructions

## Commands

### Setup
This is an infrastructure-only repo with empty placeholder files. No package installation required.

### Build
```bash
docker build -t <service-name> services/<service-name>/
```

### Lint
Not configured.

### Test
Not configured.

### Dev Server
Not applicable (infrastructure repo).

## Tech Stack & Architecture

- **Infrastructure**: Terraform (AWS IaC), Kubernetes (orchestration), Docker (containers)
- **CI/CD**: GitHub Actions
- **Monitoring**: CloudWatch, Prometheus, Grafana
- **Structure**: 6 microservices (api-gateway, auth-service, data-ingestion, ml-pipeline, notification-service, analytics-service)

## Code Conventions

- YAML for Kubernetes manifests and GitHub workflows
- Terraform for AWS infrastructure definitions
- Empty placeholder files indicate work in progress
