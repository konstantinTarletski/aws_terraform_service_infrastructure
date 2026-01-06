## Run project using Terraform.

### Phase 0: Done
- [ ] **Make "gamesys-test-task" work locally**
Fix **Dokerfile**, fix some Java problems
- [ ] **Create ECR module**
Create Elastic Container Repository (ECR) where to store docker files.
Create role for pushhing image
- [ ] **CI/CD using GitHub Actions**
Create GitHub Actions deploying to AWS ECS using OIDC and 2 different roles
- For deploying to ECR
- For updateing ECS
- [ ] **Create network module**
This modute can generate 3 different types of subnets
- public
- private (have internet access thouhg NAT)
- isolated (do not have internet access, used for DB)
This module is "smart" and can create for one AZ -- one NAT to avoid cross AZ trafic.
Number of subnets is not limited with number of AZ.
And some other "smart" things to awoid some trafic and costs problems.
- [ ] **Create SG rule constructor module**
To simplify creating Security Groups (SG) with different parameters.
- [ ] **Create ALB module**
This module creates Application Load Balancer and Target Groups (TG) for each port in Docker conatainer (if more then 1)
Creates needed SG and make it works.
- [ ] **Create ECS module**
Crerates Elastic Container Service (ECS).
Creates Roles neede for deploy (used in Github Actions)
Creates needed SG


### Phase 1: Architecture & Refactoring (Current Focus)
- [ ] **Terragrunt**
- [ ] **Improve GithubActions** use Task Difinition update
- [ ] **Use lockfile** not forgot to put "terraform backend use_lockfile = true" :)
- [ ] **SSL and domain**
- [ ] **Good readme, documentation and variables description**
- [ ] **CI/CD for terraform/trragrunt** TFLint, Checkov, Atlantis, terraform test ...
- [ ] **VPC Endpoints** for Docker (ECR), Logs, DB
- [ ] **Rid of H2 DB** USe RDS Postgress in other closed subnet using VPC Endpoints
- [ ] **Prometheus/Grafana**

### Phase 2: Microservices/Kubernetes
- [ ] **Add some other application 1**
- [ ] **Kubernetes**
- [ ] **ArgoCD**
- [ ] **Add some other application 2**
- [ ] **Fargate Kafka** 
- [ ] **Microservice communcation**

### Phase 3: Frontend
- [ ] **Write Some React Application :)**
- [ ] **Cloudfront**
- [ ] **Cloudfront CI/CD**
- [ ] **Lambda**
- [ ] **Lambda CI/CD**
- [ ] **...**





