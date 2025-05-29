# Terraform Technical Exercise – Level‑Up Edition

*"Infrastructure is poetry written in HCL – make every block count."*

## Context

This exercise builds upon existing Azure infrastructure components. The current repository provisions:

- A resource group in Central India
- One flat VNet with two subnets
- An Ubuntu virtual machine
- A Storage Account with Private Endpoint and Private DNS configuration

The objective is to enhance this foundation with enterprise-grade security, modularity, and operational excellence principles suitable for production banking environments.

## Objective

Extend the existing Terraform configuration within 60 minutes to create a production-ready, network-segmented, and security-conscious platform that meets enterprise banking standards.

**Key Principle:** Small, well-structured commits demonstrate better engineering practices than monolithic changes.

## Technical Requirements

### 1. Network Modularization
Create a reusable network module that provisions:
- Virtual Network (VNet)
- Three segmented subnets: `workloads`, `endpoints`, `bastion`
- Network Security Groups (NSGs) with appropriate associations
- Security rules: SSH access restricted to your IP address for bastion subnet; outbound internet access blocked from workloads subnet

### 2. Identity and Access Management
- Provision a System-Assigned Managed Identity for the virtual machine
- Deploy Azure Key Vault with enterprise security configuration
- Store a secret named `app-config` in the Key Vault
- Grant the VM's managed identity **Get** permissions to the secret via Azure RBAC (not access policies)

### 3. Operational Excellence
- Enable boot diagnostics on the virtual machine, utilizing the existing Storage Account (use data source to avoid hard-coding)

### 4. Configuration Management
- Replace hard-coded values (location, environment, prefix, tags) with variables and sensible defaults
- Implement `locals.tf` with a canonical `common_tags` map
- Apply consistent tagging across all resources

### 5. Infrastructure Outputs
Expose the following outputs for downstream consumption:
- Virtual machine private IP address
- Key Vault URI
- Storage Account blob endpoint
- Managed Identity resource ID

### 6. Bonus Objectives (Time Permitting)
- Configure remote state backend using Azure Storage (same Storage Account, different container)
- Deploy bastion host VM and disable SSH access on workload VM entirely

## Acceptance Criteria

| ID | Requirement | Validation Method |
|----|-------------|-------------------|
| A | Code plans and applies without manual intervention | `terraform plan` & `terraform apply -auto-approve` |
| B | Networking encapsulated in reusable module | Directory structure includes `/modules/network` |
| C | VM authenticates to Key Vault via Managed Identity | Azure CLI: `az keyvault secret show --vault-name ... --name app-config --query value` succeeds from VM |
| D | Internet egress blocked from workloads subnet | `curl https://example.com` from VM returns connection failure |
| E | All resources carry mandatory tags | `az resource list --tag environment` returns all provisioned resources |

**Note:** Failure of any must-have requirement results in test failure.

## Getting Started

1. **Repository Setup**
   ```bash
   git checkout -b feature/<your-name>
   cp terraform.tfvars.example terraform.tfvars
   # Configure your Azure credentials in terraform.tfvars
   ```

2. **Infrastructure Deployment**
   ```bash
   terraform init
   terraform plan -out tf.plan
   terraform apply tf.plan
   ```

## Deliverables

1. Committed and pushed code changes
2. Pull request with concise description covering:
   - Key design decisions
   - Any incomplete requirements
   - Assumptions made

## Resource Cleanup

Execute `terraform destroy` upon completion to avoid unnecessary cloud costs.

## Evaluation Criteria

This assessment prioritizes **clarity of thought over resource quantity**. Demonstrate:

- **Idempotence**: Consistent results across multiple executions
- **Security-first mindset**: Principle of least privilege throughout
- **Simplicity**: Elegant solutions with minimal complexity

## Support

For clarification on requirements, commit your current progress and include explanatory comments. Ambiguity resolution is part of this technical assessment.

---

*Best of luck with your implementation. Remember: even production infrastructure should reflect thoughtful engineering.*
