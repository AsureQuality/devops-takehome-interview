# Setup — macOS

## 1. Install Docker Desktop

Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/).

Start Docker Desktop and wait for it to show "Engine running" in the menu bar icon.

## 2. Install Terraform

Using Homebrew:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -version  # should be >= 1.5
```

## 3. Install LocalStack CLI and tooling

Install the LocalStack CLI via Homebrew:

```bash
brew install localstack/tap/localstack-cli
```

Create and activate a Python virtual environment for the LocalStack Python tools:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Then install the tooling into the virtual environment:

```bash
pip3 install awscli-local terraform-local
```

> **Note:** You will need to activate the virtual environment at the start of each new terminal
> session before using `awslocal` or `tflocal`:
> ```bash
> source .venv/bin/activate
> ```

Verify:

```bash
localstack --version
awslocal --version
tflocal --version
```

## 4. Authenticate with LocalStack

Sign up at [localstack.cloud](https://localstack.cloud) and copy your auth token from
[app.localstack.cloud/workspace/auth-token](https://app.localstack.cloud/workspace/auth-token).

```bash
localstack auth set-token <your-token>
```

## 5. Configure your `.env` file

```bash
cp starter/.env.example starter/.env
```

Open `starter/.env` and set `LOCALSTACK_AUTH_TOKEN=your-token-here`.

## 6. Start LocalStack

```bash
cd starter
docker compose up -d
```

Wait ~15 seconds, then verify:

```bash
awslocal s3 ls
```

No output and no error means LocalStack is running correctly.

## 7. Install LocalStack Desktop

Download and install the [LocalStack Desktop app](https://app.localstack.cloud/download).

Open it, set the endpoint to `http://localhost:4566`, and you should see a connected status. Use
the **Resource Browser** tab to inspect resources you deploy (VPCs, Lambda functions, IAM roles,
etc.).

> **Note:** Do not use the LocalStack web app at `app.localstack.cloud` in your browser as a
> substitute — it cannot connect to a local instance due to browser security restrictions.

## 8. Run Terraform

Use `tflocal` for all Terraform commands (it configures LocalStack endpoints automatically):

```bash
cd starter/environments/dev
tflocal init
tflocal plan
tflocal apply
```

## Stopping LocalStack

```bash
cd starter
docker compose down
```

To also remove the stored state volume:

```bash
docker compose down -v
```
