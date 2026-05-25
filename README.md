# DevOps Engineer Technical Interview

Welcome. This repository contains the technical take-home exercise for the DevOps Engineer position.

## Overview

You will use **Terraform** and **LocalStack** to design, build, and deploy infrastructure on a simulated AWS environment — no real AWS account or costs required.

There are two sets of tasks:

- **Primary Tasks** — Core infrastructure (~2 hours)
- **Extended Tasks** — Additional scope for candidates who move through the primary tasks quickly

Start with the Primary Tasks. If you finish with time to spare, continue into the Extended Tasks.

## Time expectation

**Please do not spend more than 2 hours on this.** Work through as much as you can in that time and stop — even if you haven't finished.

We are not scoring you on how much you complete. We are interested in your thought process and how you approach problems. If you get stuck or make a trade-off, leave a comment in the code explaining your thinking. That is more valuable to us than a finished solution.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine on Linux)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- Python 3 (for LocalStack tooling)
- A free LocalStack account — sign up at [localstack.cloud](https://localstack.cloud)
- [LocalStack Desktop](https://app.localstack.cloud/download) — gives you a resource browser UI to inspect what you've deployed

Setup instructions for your OS:

- [macOS](docs/setup-macos.md)
- [Linux](docs/setup-linux.md)
- [Windows](docs/setup-windows.md)

## Getting Started

### 1. Fork and clone this repository

Click **Fork** on this GitHub page, then clone your fork:

```bash
git clone https://github.com/<your-username>/devops-takehome-interview.git
cd devops-takehome-interview
git checkout -b my-submission
```

### 2. Configure your LocalStack auth token

Copy the example env file and add your token (from [app.localstack.cloud](https://app.localstack.cloud/workspace/auth-token)):

```bash
cp starter/.env.example starter/.env
# Edit starter/.env and set LOCALSTACK_AUTH_TOKEN=your-token-here
```

### 3. Start LocalStack

```bash
cd starter
docker compose up -d
```

Wait for LocalStack to be healthy, then verify:

```bash
awslocal s3 ls
```

No output (and no error) means it is working.

### 4. Use `tflocal` instead of `terraform`

All Terraform commands must be run using `tflocal`, which automatically configures the LocalStack endpoints:

```bash
tflocal init
tflocal plan
tflocal apply
```

### 5. Your task brief

- [Primary Tasks — Core Infrastructure](tasks/primary/README.md)
- [Extended Tasks](tasks/extended/README.md)

Work from the `starter/` directory. All your implementation goes there.

## Submission

When you are done (or when time is up), push your branch and email us the link to your fork.

Your commit history is part of the assessment — commit regularly with meaningful messages.

## Questions

If anything is unclear, please reach out rather than making assumptions.
