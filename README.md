# Internal Developer Platform (AWS)

## Overview

This project implements a self-service Internal Developer Platform (IDP) on AWS.

It enables developers to:
- Create services on demand
- Provision tenants
- Deploy infrastructure automatically
- Use a centralized developer portal

---

## Architecture

Developer → Portal (CloudFront + S3)
        → API Gateway
        → Service Factory (Lambda)
        → DynamoDB (Service Catalog)
        → Terraform Modules
        → AWS Infrastructure

---

## Features

- Self-service API:
  - POST /platform/create-service
  - POST /platform/create-tenant

- Developer Portal UI
- Platform CLI
- CI/CD Pipelines (CodePipeline + CodeBuild)
- Infrastructure-as-Code (Terraform)
- Service catalog (DynamoDB)

---

## Project Structure

- portal/ → React UI
- terraform/ → Infrastructure
- service-factory/ → Backend logic
- platform-cli/ → CLI tool

---

## Deployment

```bash
cd terraform/platform
terraform init
terraform apply
