# Setup — Linux

These instructions are written for Debian/Ubuntu. Adjust package manager commands for your distro.

## 1. Install Docker Engine

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Add your user to the `docker` group so you can run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Verify:

```bash
docker run --rm hello-world
```

## 2. Install Terraform

```bash
sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get install -y terraform
terraform -version  # should be >= 1.5
```

## 3. Install LocalStack CLI and tooling

Create and activate a Python virtual environment to keep the LocalStack tools isolated:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Then install the tooling:

```bash
pip3 install localstack awscli-local terraform-local
```

> If `pip3` is not available: `sudo apt-get install -y python3-pip`

> **Note:** You will need to activate the virtual environment at the start of each new terminal
> session before using `localstack`, `awslocal`, or `tflocal`:
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

Download the LocalStack Desktop app from [app.localstack.cloud/download](https://app.localstack.cloud/download).
Choose the **Linux** build (`.AppImage` or `.deb` depending on your distro).

For the `.AppImage`:

```bash
chmod +x LocalStack-*.AppImage
./LocalStack-*.AppImage
```

For the `.deb`:

```bash
sudo dpkg -i localstack-desktop_*.deb
```

Open the app, set the endpoint to `http://localhost:4566`, and you should see a connected status.
Use the **Resource Browser** tab to inspect resources you deploy.

> **Note:** Do not use the LocalStack web app at `app.localstack.cloud` in your browser as a
> substitute — it cannot connect to a local instance due to browser security restrictions.

## 8. Run Terraform

```bash
cd starter/environments/dev
tflocal init
tflocal plan
tflocal apply
```

## Stopping LocalStack

```bash
cd starter
docker compose down        # stop containers
docker compose down -v     # stop and remove the state volume
```
