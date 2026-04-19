#!/bin/bash
# ─────────────────────────────────────────────────────────
# install-tools.sh
# Runs automatically inside the VM on first `vagrant up`
# Installs: Docker, Docker Compose, Terraform, Git, curl
# ─────────────────────────────────────────────────────────

set -e  # Stop on any error

echo "==> Updating package list..."
apt-get update -y

echo "==> Installing base utilities..."
apt-get install -y \
  curl \
  wget \
  git \
  unzip \
  gnupg \
  software-properties-common \
  apt-transport-https \
  ca-certificates

# ─── Docker ────────────────────────────────────────────
echo "==> Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Allow the vagrant user to run Docker without sudo
usermod -aG docker vagrant

echo "==> Installing Docker Compose..."
curl -SL "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ─── Terraform ─────────────────────────────────────────
echo "==> Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -y && apt-get install -y terraform

# ─── Nginx ─────────────────────────────────────────────
echo "==> Installing Nginx..."
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# ─── Done ──────────────────────────────────────────────
echo ""
echo "============================================"
echo " Setup complete! Versions installed:"
echo "============================================"
docker --version
docker-compose --version
terraform --version
nginx -v
git --version
echo "============================================"
echo " Run: vagrant ssh   to enter the VM"
echo "============================================"
