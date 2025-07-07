# Infrastructure

#  Ruby on Rails Application Deployment on AWS ECS using Terraform

This project demonstrates end-to-end deployment of a **Dockerized Ruby on Rails (RoR) application** to **AWS ECS (Fargate)** using **Terraform**. The app connects to **Amazon RDS (PostgreSQL)** and integrates with **Amazon S3** for file storage.


## Tech Stack

- **Ruby on Rails**
- **Docker**
- **AWS ECS (Fargate)**
- **Amazon RDS (PostgreSQL)**
- **Amazon S3**
- **Terraform**

---

## Environment Variables (Used by ECS Container)

| Variable Name       | Purpose                         |
|---------------------|---------------------------------|
| `DATABASE_HOST`     | Endpoint of RDS PostgreSQL      |
| `DATABASE_USERNAME` | DB user (e.g., `postgres`)      |
| `DATABASE_PASSWORD` | DB password                     |
| `AWS_REGION`        | AWS region (e.g., `ap-south-1`) |
| `S3_BUCKET`         | Name of the S3 bucket           |

All of the above are configured in Terraform’s `terraform.tfvars`.

---

## Project Structure

```bash
.
├── terraform-ror-app/         # Infrastructure as Code (Terraform)
│   ├── ecs.tf
│   ├── rds.tf
│   ├── iam.tf
│   ├── vpc.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── provider.tf
│   └── ...
├── DevOps-ROR-App/            # Ruby on Rails App Dockerized
│   └── Dockerfile
├── diagram.png                # Architecture Diagram
└── README.md


Commands to Provision and Build .

-----.-----------------------------------------------------------------------------------------

cd DevOps-ROR-App

# Build image
docker build -t ror-app .

# Authenticate to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 993082532003.dkr.ecr.ap-south-1.amazonaws.com

# Tag image
docker tag ror-app:latest 993082532003.dkr.ecr.ap-south-1.amazonaws.com/ror-app:v1

# Push to ECR
docker push 993082532003.dkr.ecr.ap-south-1.amazonaws.com/ror-app:v1

---------------------------------------------------------------------------------------------

cd terraform-ror-app


terraform init
terraform plan
terraform apply


----------------------------------------------------------------------------------------------



The full deployment guide, architecture diagram, and screenshots are available in the document below:

 [Download InterviewProject.docx](https://github.com/JayaAravindh/Infrastructure/raw/main/InterviewProject.docx)
