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

- Inside the `prd` directory, the directory name should match the artifact name in the `pom.xml` file.
```
pom.xml ├── **prd**
│   └── addressbook
│       └── values.yaml

```
- artifact name in the `pom.xml` 

```
    <artifactId>addressbook</artifactId>
```
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

# Address Book & CALC Application Deployment Process

The given code represents a Continuous Integration and Continuous Deployment (CI/CD) pipeline, designed to automate the processes of code checkout, build, test, package, and deployment for the `address-book-app`. This pipeline is defined using a Jenkins declarative pipeline syntax and is configured to run within a Kubernetes cluster.

## Pipeline Stages

### 1. **Git Checkout**:
   - The pipeline checks out the source code of `address-book-app` from its repository on GitHub.
   - It then reads the `pom.xml` to fetch the `artifactId`, `version` and prepares the `IMAGE_NAME` for later stages.

### 2. **Build**:
   - Executes a Maven build (`mvn clean install`) to compile the source code, and perform initial testing.

### 3. **Test**:
   - Runs unit tests using Maven (`mvn test`).

### 4. **Package**:
   - Packages the compiled code into a JAR file (`mvn package`).

### 5. **Checkstyle Scan**:
   - Runs a Checkstyle scan to ensure the code adheres to coding standards and guidelines.

### 6. **SonarQube Scan**:
   - Performs a SonarQube scan to measure and analyze code quality.

### 7. **Docker Login to ACR**:
   - Logs into Azure Container Registry (ACR) using provided credentials.

### 8. **Build Docker Image**:
   - Builds a Docker image of the application, tagging it with the earlier prepared `IMAGE_NAME`.

### 9. **Push Docker Image to ACR**:
   - Pushes the newly built Docker image to the Azure Container Registry.

## Environment Variables

- `APP_REPO_NAME`: Specifies the name of the application repository.
- `ACR_REPO`: Specifies the Azure Container Registry repository where Docker images are stored.
- `APP_NAME`, `ENVIRONMENT`, `APP_VERSION`, `IMAGE_NAME`, `DOCKER_IMAGE`: These variables are derived from the application's `pom.xml` and repository configuration, used in naming and tagging the Docker image.

## Kubernetes Configuration

The pipeline is configured to run on a Kubernetes agent, with a custom pod specification that includes two containers: one for Maven (`maven:jdk-11-slim`) and one for Docker (`docker:dind`). This allows the pipeline to have all the necessary tools available for building, packaging, and dockerizing the application.

## Comments on Skipped Stages

There are some commented-out stages in the pipeline:
- **Quality Gate**: This stage would typically wait for a response from SonarQube to ensure the code passes all defined quality gates before proceeding.
- **List Files**: This stage would list all files in the current directory, perhaps for diagnostic or logging purposes.

## Integration with README

To add this pipeline explanation to your `README.md`, copy the markdown content from this document and append it to your `README.md`. This will provide a detailed explanation of how the CI/CD pipeline works, and how it is structured to automate the deployment process of the `address-book-app`.


