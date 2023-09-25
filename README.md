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

## Use Cases

### 1. Infrastructure Scaling
**Scenario**: The platform engineering team recognizes the need to scale up the AKS infrastructure due to increasing loads.
**Steps**:
   - The team makes necessary modifications in the `Azure-k8s-infra-ops` repository using Terraform scripts.
   - Terraform is executed to apply these changes.
   - AKS infrastructure scales up to handle the increased load.

### 2. New Service Deployment by Dev Team
**Scenario**: A development team has built a new microservice and wishes to deploy it.
**Steps**:
   - The team pushes the application code to their respective application repository (e.g., `microservices-calculator-1`).
   - A Docker image is created using the provided Dockerfile.
   - The Helm chart from the `golden-chart` directory is customized using the `values.yaml` file in the `prd` directory.
   - CI/CD pipelines are triggered to deploy the new service to AKS.

### 3. Application Update by DevOps
**Scenario**: A security vulnerability has been discovered in a library used by multiple applications.
**Steps**:
   - The DevOps individual updates the Docker image to include the patched library version.
   - The updated image is pushed to the container registry.
   - CD pipeline is initiated to roll out the updated image across all affected services.

### 4. Role-Based Access Control (RBAC)
**Scenario**: A new developer joins one of the LBUs and needs access to the application code without gaining privileges on the infrastructure.
**Steps**:
   - The platform engineering team ensures the new developer only has access to the specific application repository (e.g., `address-book-app`).
   - The developer can now push code changes, but cannot modify infrastructure or Docker images.

---

