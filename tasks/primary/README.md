# Primary Tasks — Core Infrastructure

**Time limit:** ~2 hours (stop when time is up, even if not finished)

## Context

You are provisioning the foundational infrastructure for a simple API service. The architecture
consists of a VPC and a Lambda function (provided as a pre-built package).

Work in the `starter/` directory. All stub files are there to get you started — read the comments
carefully before implementing.

---

## Task 1 — Build a reusable VPC module

Implement the Terraform module in `starter/modules/vpc/`.

The module must provision:

- A **VPC** with a configurable CIDR block
- **Public subnets** across at least 2 availability zones
- **Private subnets** across at least 2 availability zones
- An **Internet Gateway** attached to the VPC
- **Route tables** — public subnets route to the IGW; private subnets have a local route only
- *(Bonus)* A **NAT Gateway** in one public subnet, enabled via the `enable_nat_gateway` variable

The variable interface is already defined in `starter/modules/vpc/variables.tf` — do not change the
variable names. Implement the resources in `main.tf` and wire up the outputs in `outputs.tf`.

---

## Task 2 — Consume the module

In `starter/environments/dev/main.tf`, call your VPC module with appropriate values for a
development environment. The commented-out example block shows the expected shape.

---

## Task 3 — Lambda + IAM

A pre-built Lambda package is provided at `starter/lambda/handler.zip`. You do not need to modify
the application code — your job is to wire up the infrastructure.

Deploy the Lambda function into your VPC:

1. Create an **IAM execution role** for Lambda with least-privilege permissions:
   - Allow Lambda to assume the role
   - Attach `AWSLambdaBasicExecutionRole` (CloudWatch Logs access)
   - Attach `AWSLambdaVPCAccessExecutionRole` (required for VPC-deployed functions)
2. Deploy the **Lambda function** into a private subnet of your VPC:
   - Runtime: `python3.12`
   - Handler: `handler.handler`
   - Filename: `starter/lambda/handler.zip`

Verify the function works:

```bash
awslocal lambda invoke \
  --function-name <your-function-name> \
  /tmp/response.json && cat /tmp/response.json
```

---

## Submission Checklist

- [ ] VPC module provisions a VPC, public and private subnets across 2+ AZs, IGW, and route tables
- [ ] Module is called in `environments/dev/main.tf` with appropriate values
- [ ] Lambda IAM execution role uses least-privilege permissions
- [ ] Lambda function deploys successfully into a private subnet
- [ ] `tflocal apply` completes with no errors
- [ ] `awslocal lambda invoke` returns a successful response
- [ ] No `.terraform/` directories or `*.tfstate` files are committed
- [ ] Commit history is clean — meaningful messages, logical progression
