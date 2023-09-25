# Enterprise Application Deployment Workflow

## Overview
This document describes the streamlined workflow for deploying Java applications across various teams in our organization. The process leverages multiple Git repositories, each serving a specific purpose in the CI/CD pipeline.

## Assumptions and Prerequisites

### Assumptions

1. **Team Structure**: The organization comprises three distinct teams:
   - Platform Team
   - DevOps Team 
   - Development Team

2. **Github Access**: Due to FSI (Financial Services Institution) regulations, the organization uses a private GitHub instance. All necessary modules, code repositories, and configurations are stored and maintained here.

3. **Security Oversight**: The security team oversees the secure coding and deployment practices and provides tools and configurations such as SonarQube details for CI/CD pipelines.

### Prerequisites

#### Platform Team

1. **Terraform**: 
   - The team possesses expertise in Terraform and is responsible for maintaining Terraform scripts and modules.
   - Necessary plugins and extensions for Terraform are installed and updated.

2. **Azure Access**: 
   - The team has the required permissions and access rights to manage and configure Azure resources.
   - They are also responsible for creating and maintaining Azure policies, ensuring resource compliance with the organization's standards.

3. **Github Management**:
   - As the organization operates with a private Github instance, the platform team is responsible for managing repositories, permissions, and access controls.
   - The team ensures that all Terraform modules and configurations are version-controlled and available on this Github.

#### DevOps Team 

1. **Jenkins Access**:
   - The team has permissions and access rights to their LBUs (Logical Business Units) Jenkins job configurations and management.
   - Responsible for setting up, configuring, and maintaining Jenkins pipelines specific to their LBUs.

2. **Azure Container Registry (ACR) Access**:
   - Team2 has the necessary permissions to push Docker images to the Azure Container Registry (ACR).
   - They manage and maintain the Docker repositories in ACR relevant to their LBUs.

3. **SonarQube Configuration**:
   - The security team provides the details and configurations necessary for integrating SonarQube into Jenkins pipelines.
   - Team2 ensures the proper integration of these details into the CI/CD pipelines, promoting secure coding practices.

#### Development Team

*Specific prerequisites and responsibilities can be further detailed based on the tasks and expectations from this team.*

---

**Note**: Effective communication and collaboration between these teams are paramount to ensure the smooth operation of CI/CD processes and the overall development lifecycle.

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

---

# Address Book Application Deployment on AKS

The given code describes a Jenkins CI/CD pipeline that manages the deployment of the `address-book-app` on an Azure Kubernetes Service (AKS) cluster using Helm. The pipeline is structured to run within a Kubernetes pod to handle application details extraction, image selection, and deployment operations.

## Pipeline Stages

### 1. **APP Details**:
   - The pipeline checks out the source code of `address-book-app` from its GitHub repository to access the application's details.

### 2. **App Image Selection**:
   - This stage operates inside a `kbctl-helm` container.
   - It reads the `pom.xml` file to extract the `artifactId` and `version` of the application.
   - Constructs the `IMAGE_NAME` and `DOCKER_IMAGE` using environment information, application name, and version. 

### 3. **Deployment on AKS**:
   - Again, this stage utilizes the `kbctl-helm` container.
   - Uses Helm to upgrade (or install if not already deployed) the application on the AKS cluster.
   - Deploys the application using the `golden-chart` Helm chart.
   - Overrides default values using the `values.yaml` file found within the environment's directory, and sets image repository and tag information.
   - Lastly, lists all deployed Helm releases to verify the deployment.

## Environment Variables

- `APP_REPO_NAME`: The name of the application repository, in this case, `address-book-app`.
- `ACR_REPO`: Specifies the Azure Container Registry where the Docker image of the application resides.
- `APP_NAME`, `ENVIRONMENT`, `APP_VERSION`, `IMAGE_NAME`, `DOCKER_IMAGE`: These variables hold application details derived from the `pom.xml` and are used throughout the pipeline.

## Kubernetes Configuration

The pipeline uses a Kubernetes agent with a custom pod configuration. This pod contains a container `kbctl-helm`, which seems to be a custom image equipped with tools like `kubectl` and `helm`. This container is crucial for interacting with the AKS cluster and deploying the application using Helm.

---

- Dockerfile + Terraform + K8s - Take any sample java / application from the internet or build a simple one of your own. Write a docker file and package it into a docker image. Build the docker image and push it to the Azure ACR using terraform.
- Write a terraform code to create a 3-tier Network and its components, create a K8s cluster.
- Jenkins CI is running on a separate Cluster with Build agents. ( Also write Docker files for build agent required for above project)
- Scan the code for Standards and Vulnerabilities.
- Do scan the package before creating the image.
- Pipeline should be reusable in future (modular) and parameterized.
- Separate Pipeline for CI & CD. CI to be triggered when a Pull is Merged in SCM. CD to be triggered from JIRA release task.
- Do list all the ID that are required before this setup can be run also prepare a Readme for the DevOps team to implement this project and list all the assumption in the same. Code should be well documented and all the Variables used should be documented as well.
- Upload all the files in appropriate folders onto a GIT repo and share the link.
Cloud platform  is Azure