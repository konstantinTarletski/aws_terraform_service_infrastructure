## 📅 Roadmap (Q1 2026)

This roadmap covers the planned infrastructure enhancements for the next 1-2 weeks.

### Phase 1: Architecture & Refactoring (Current Focus)
- [ ] **Terragrunt Integration**: Migrate the entire stack to Terragrunt to manage cross-module dependencies (`dependency` blocks) and eliminate code duplication (DRY).
- [ ] **State Management**: Refactor S3 backend configuration using Terragrunt's remote state auto-generation.

### Phase 2: Security & Networking (Deep Dive)
- [ ] **HTTPS Implementation**: Provision SSL/TLS certificates via AWS Certificate Manager (ACM) and configure HTTPS listeners on ALB.
- [ ] **Private Connectivity**: Validate NAT Gateway traffic flow and tighten Security Group rules by replacing 0.0.0.0/0 with specific SG-to-SG references.
- [ ] **Non-Root Execution**: Refactor Dockerfiles and ECS Task Definitions to run application processes as non-root users for enhanced container security.

### Phase 3: Data & Automation
- [ ] **Database Deployment**: Provision an RDS Instance (PostgreSQL/MySQL) within the dedicated `db_subnets` with Multi-AZ enabled.
- [ ] **Full CI/CD Pipeline**: Enhance GitHub Actions to automate the "Build-Push-Deploy" cycle (ECR push + ECS Task Definition update).
- [ ] **Static Analysis**: Integrate `Trivy` for vulnerability scanning and `TFLint` for Terraform code quality checks in the CI pipeline.

---
*Status: In Progress - [Build -> Test -> Destroy] cycle active.*
