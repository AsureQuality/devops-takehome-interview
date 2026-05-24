# Setup — Windows

**Recommended approach: WSL2 + Ubuntu**, then follow the [Linux setup guide](setup-linux.md) inside
your WSL2 terminal. This gives the most reliable Docker networking experience with LocalStack.

If you prefer native Windows (PowerShell), a native path is described at the bottom of this page.

---

## Recommended: WSL2 + Ubuntu

### 1. Enable WSL2 and install Ubuntu

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

Restart when prompted. Ubuntu will be installed by default. Open the Ubuntu app to complete setup.

### 2. Install Docker Desktop

Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/).

During installation, ensure **"Use WSL 2 based engine"** is selected.

In Docker Desktop settings → Resources → WSL Integration, enable integration for your Ubuntu
distribution.

Verify Docker is accessible from WSL2:

```bash
# Inside your Ubuntu terminal
docker run --rm hello-world
```

### 3. Follow the Linux setup guide

Open your Ubuntu terminal and follow [docs/setup-linux.md](setup-linux.md) from step 2 onwards
(Terraform, LocalStack, tooling, auth token, `.env` file, start LocalStack).

All `tflocal`, `awslocal`, and `docker compose` commands must be run from the Ubuntu terminal.

---

## Alternative: Native Windows (PowerShell)

> Docker networking with LocalStack is less reliable on native Windows. WSL2 is strongly recommended.

### 1. Install Docker Desktop

Download and install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
with the WSL2 backend enabled.

### 2. Install Terraform

Download the Windows binary from [developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
and add it to your `PATH`.

Or use Chocolatey:

```powershell
choco install terraform
```

### 3. Install Python and LocalStack tooling

Create and activate a Python virtual environment:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

> If `Activate.ps1` is blocked, first run:
> `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

Then install the tooling into the virtual environment:

```powershell
pip install localstack awscli-local terraform-local
```

> **Note:** You will need to activate the virtual environment at the start of each new PowerShell
> session before using `awslocal` or `tflocal`:
> ```powershell
> .venv\Scripts\Activate.ps1
> ```

### 4. Authenticate with LocalStack

```powershell
localstack auth set-token <your-token>
```

### 5. Configure your `.env` file

```powershell
Copy-Item starter\.env.example starter\.env
```

Edit `starter\.env` and set `LOCALSTACK_AUTH_TOKEN=your-token-here`.

### 6. Start LocalStack

```powershell
cd starter
docker compose up -d
```

Verify (in PowerShell):

```powershell
awslocal s3 ls
```

### 7. Install LocalStack Desktop

Download the LocalStack Desktop app from [app.localstack.cloud/download](https://app.localstack.cloud/download).
Choose the **Windows** installer (`.exe`).

Run the installer, open the app, set the endpoint to `http://localhost:4566`, and you should see
a connected status. Use the **Resource Browser** tab to inspect resources you deploy.

> **Note:** Do not use the LocalStack web app at `app.localstack.cloud` in your browser as a
> substitute — it cannot connect to a local instance due to browser security restrictions.

### 8. Run Terraform

```powershell
cd starter\environments\dev
tflocal init
tflocal plan
tflocal apply
```
