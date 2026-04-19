# Phase 1 — Dev Environment Setup (WSL2)

## What you're building
A local Ubuntu 24.04 environment on Windows using **WSL2** (Windows Subsystem for Linux 2), with Docker, Terraform, and Nginx installed. This is your "mini cloud" on your Windows laptop — lighter and faster than a full VirtualBox VM.

> **Note:** This project originally used Vagrant + VirtualBox. Switched to WSL2 for lower overhead, native filesystem access, and faster container startup. Same end result — a Linux box ready for Docker workflows.

---

## Step 1 — Enable WSL2

Open **PowerShell as Administrator**:

```powershell
wsl --install
```

This installs WSL2 + the default Ubuntu distribution. Reboot if prompted.

Verify:
```powershell
wsl -l -v
```
You should see `Ubuntu` with `VERSION 2`.

---

## Step 2 — Install Ubuntu 24.04

From Microsoft Store (or PowerShell):
```powershell
wsl --install -d Ubuntu-24.04
```

Launch Ubuntu, create your Linux username + password when prompted.

Verify version inside Ubuntu:
```bash
lsb_release -a
# Expect: Ubuntu 24.04.x LTS (noble)
```

---

## Step 3 — Install Docker

Inside WSL Ubuntu:
```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
```

Close + reopen WSL terminal for group change to apply. Verify:
```bash
docker --version
# Expect: Docker version 29.x or similar
```

Start Docker daemon (WSL doesn't use systemd by default on older configs):
```bash
sudo service docker start
```

---

## Step 4 — Install Terraform

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
terraform --version
# Expect: Terraform v1.x
```

---

## Step 5 — Install Nginx

```bash
sudo apt-get install -y nginx
sudo service nginx start
nginx -v
# Expect: nginx version: nginx/1.24.x (Ubuntu)
```

---

## Step 6 — Project folder

WSL auto-mounts your Windows drives at `/mnt/c/`. Your project lives at:
```bash
cd /mnt/c/Users/<your-user>/Documents/Claude/Projects/Planning\ to\ get\ Tech\ job/repo-changes/local-to-cloud-starter
```

Or copy it into WSL's native filesystem for faster I/O:
```bash
mkdir -p ~/projects && cp -r /mnt/c/path/to/local-to-cloud-starter ~/projects/
cd ~/projects/local-to-cloud-starter
```

---

## Useful WSL commands (run from Windows PowerShell)

| Command | What it does |
|---|---|
| `wsl` | Enter default distro |
| `wsl -d Ubuntu-24.04` | Enter specific distro |
| `wsl --shutdown` | Stop all WSL distros |
| `wsl -l -v` | List distros + versions |
| `wsl --unregister Ubuntu-24.04` | Delete distro completely |

---

## Why WSL2 over Vagrant + VirtualBox

| | Vagrant + VirtualBox | WSL2 |
|---|---|---|
| Disk usage | ~5–10 GB VM image | ~1–2 GB |
| Boot time | 30–60 sec | <2 sec |
| Filesystem | Shared folder hack | Native `/mnt/c/` |
| Docker | Inside VM | Direct kernel integration |
| Resource use | Fixed RAM allocation | Dynamic |

---

## Ready for Phase 2?

Once `docker --version`, `terraform --version`, and `nginx -v` all work inside WSL → Phase 1 done. Move to `phase-2-first-project/`.
