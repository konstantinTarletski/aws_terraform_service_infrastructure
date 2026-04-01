> **Architectural Note:** This is a custom-built project developed as part of an in-depth study of Terraform, Terragrunt, and modern DevOps practices. As an evolving educational environment, it is used to experiment with various IaC patterns. You may encounter TODOs, temporary comments, or open MRs intended for refactoring. The goal is continuous learning and hands-on improvement of infrastructure architecture.


# AWS Infrastructure for Java Services (GameSys Project)

Project focused on building a scalable and cost-effective infrastructure in AWS. 
Infrastructure is fully managed as code (IaC) using a modular approach.

Link after "terraform apply" is :
https://game-sys.tarlekon.click/swagger-ui.html

## 🚀 Roadmap

### Phase 0: Foundations (Done ✅)
- [x] **Local Run & Dockerization**  
  Fixed Dockerfile and Java 11 dependencies. Switched to Amazon-optimized Docker images. (other repo)
- [x] **ECR Module**  
  Created Elastic Container Registry (ECR). Configured IAM roles for image pushing.
- [x] **CI/CD via GitHub Actions**  
  Automation via OIDC (no static keys). Two roles: for ECR (push) and for ECS (update).
- [x] **Smart Network Module**  
  Generates 3 types of subnets: `public`, `private` (NAT), and `db` (isolated). "1 AZ = 1 NAT" logic to avoid cross-AZ traffic costs.
- [x] **SG Rule Constructor**  
  Technical module to simplify Security Group management using `for_each` and object maps.
- [x] **ALB Module**  
  Creates Application Load Balancer and Target Groups for each container port.
- [x] **ECS Module**  
  Deploys ECS Fargate service. Configures Task and Execution roles.
- [X] **SSL & Domain**  
  Configure HTTPS via ACM certificates and Route53 and DNS/domain

### Phase 1: Architecture & Refactoring (Current Focus 🎯)
- [X] **Terragrunt Migration**  
  Transition to Terragrunt for better dependency management and DRY code.
- [ ] **Advanced GitHub Actions**  
  Shift to proper updates via `task-definition.json` and Rolling Update logic.
- [ ] **Native S3 State Locking**  
  Enable `use_lockfile = true` (Terraform 1.10+)
- [ ] **VPC Endpoints**  
  Setup private links for ECR, Logs, and S3 to save costs on NAT traffic.
- [ ] **RDS Integration**  
  Move from H2 to PostgreSQL in the isolated DB subnet.
- [ ] **VPN Access to DB**  
  DB will run in subnet without internet, and do access it I need to build VPN
- [ ] **Atlantis for GitOps IaC**  
  Deploy **Atlantis** to automate Terraform/Terragrunt runs via Pull Requests.
- [ ] **IaC Quality Gate**  
  Implement `terraform test`, `TFLint`, and `Checkov`.

### Phase 2: Microservices / Kubernetes
- [ ] **Add Microservice App 1 and 2**
- [ ] **Kubernetes (EKS)**
- [ ] **ArgoCD**
- [ ] **Fargate Kafka / Inter-service communication**

### Phase 3: Frontend & Serverless
- [ ] **React Application**
- [ ] **Cloudfront CDN & CI/CD**
- [ ] **Lambda for background tasks & CI/CD**


