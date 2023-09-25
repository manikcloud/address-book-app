# Enterprise Application Deployment Workflow

## Overview
This document describes the streamlined workflow for deploying Java applications across various teams in our organization. The process leverages multiple Git repositories, each serving a specific purpose in the CI/CD pipeline.

## Repositories

### 1. Infrastructure Repository
- **Repository**: [Azure-k8s-infra-ops](https://github.com/manikcloud/Azure-k8s-infra-ops)
- **Managed By**: Platform Engineering Team
- **Description**: This repository is responsible for orchestrating the entire infrastructure on AKS and its associated ecosystem using Terraform.
- **Access**: Centralized and exclusive to the Platform Engineering team.

### 2. DevOps Repository
- **Description**: This repository serves all LBUs and is managed by a dedicated DevOps individual. The primary role of this repository is to create and manage Docker images as required by the development teams.
- **Access**: DevOps personnel only; no access for teams using the Infrastructure Repository. Development teams only have access to their respective application repositories.

### 3. Application Repositories
Development teams, or LBUs, maintain their application code in these repositories:
- [microservices-calculator-1](https://github.com/manikcloud/microservices-calculator-1)
- [microservices-calculator-2](https://github.com/manikcloud/microservices-calculator-2)
- [address-book-app](https://github.com/manikcloud/address-book-app)
  
## Directory Structure
Each application repository contains a standardized directory structure, including:
- Dockerfile: For creating the application's Docker image.
- `golden-chart`: Contains Helm chart files for Kubernetes deployments.
- `prd`: This directory is named after the artifact in the application's `pom.xml`. Inside it, a `values.yaml` file is used to customize the Helm chart for different environments.

## CI/CD Integration
The CI (`ci-Jenkinsfile`) and CD (`cd-Jenkinsfile`) pipelines are standardized across all application repositories. Developers only need to specify the repository name to integrate seamlessly. The setup is compatible with any Java Maven application. To adapt a new application, ensure that the name of the `prd` directory matches the artifact name in the application's `pom.xml`.
