# Terraform Enterprise (TFE) / HCP Terraform

Deploys the Task Manager API to AWS ECS Fargate behind an ALB. Written to run as a **VCS-driven workspace in Terraform Enterprise / HCP Terraform**, with a Sentinel policy enforced on every run.

## Files
- `backend.tf` — `cloud` block configuring the TFE/HCP Terraform organization, hostname, and workspace tags (swap `hostname` for your self-hosted TFE server if applicable).
- `main.tf` — VPC lookup, security groups, ALB + target group + listener, ECS cluster/task/service.
- `variables.tf` / `outputs.tf` — inputs (region, image, replica count, tags) and outputs (ALB DNS name).
- `sentinel/enforce-mandatory-tags.sentinel` + `sentinel.hcl` — Sentinel policy that blocks any run where taggable resources are missing `Project`, `Owner`, or `Environment` tags.

## Setting this up in Terraform Enterprise
1. In TFE, create a workspace and connect it to this repository (VCS-driven workflow), pointing the working directory at `/terraform`.
2. Set workspace variables for `app_image` and any AWS credentials (or use dynamic provider credentials / OIDC).
3. Attach the `enforce-mandatory-tags` policy set (from `sentinel.hcl`) to the workspace or organization policy set.
4. Push to the connected branch — TFE will queue a remote plan, run the Sentinel check, and (on approval) apply.

## Local dry run (no cloud backend, no apply)
```bash
cd terraform
terraform init -backend=false
terraform validate
terraform fmt -check
```

Demonstrates: TFE remote/`cloud` backend configuration, VCS-driven workspace workflow, Sentinel policy-as-code for governance, and standard module structure (variables/outputs/tags).
