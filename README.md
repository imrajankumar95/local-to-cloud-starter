# local-to-cloud-starter

> From a blank Windows laptop → HTML app → Nginx → Docker container → Docker Hub → Azure VM. The full migration arc, one phase at a time.

**Stack:** WSL2 · Ubuntu 24.04 · Nginx · Docker · Docker Hub · Azure (Phase 3)

**Live image:** [hub.docker.com/r/rajankumar656/my-cloud-app](https://hub.docker.com/r/rajankumar656/my-cloud-app)

---

## Why this project exists

Most cloud tutorials skip the bridge between *"I wrote some code"* and *"it runs on cloud."* This repo builds that bridge step by step — each phase is a real deployable artifact, not a slide deck.

Goal: learn by shipping, one phase at a time, until the same container that runs locally runs in Azure with a public IP.

---

## Architecture

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  Windows 11      │    │  WSL2 Ubuntu     │    │  Docker Hub      │
│  (host)          │───▶│  24.04 LTS       │───▶│  public registry │
│  Browser         │    │  Nginx + Docker  │    │  my-cloud-app:v1 │
└──────────────────┘    └──────────────────┘    └──────────────────┘
                                                          │
                                                          ▼
                                               ┌──────────────────┐
                                               │  Azure VM (B1s)  │
                                               │  docker pull     │
                                               │  Public IP :80   │
                                               └──────────────────┘
                                                    (Phase 3)
```

---

## Phases

| Phase | What it ships | Status |
|---|---|---|
| **1** — [WSL2 Dev Environment](phase-1-wsl-setup/README.md) | Ubuntu 24.04 + Docker + Terraform + Nginx on WSL2 | ✅ Done |
| **2** — [First Project: HTML → Container → Registry](phase-2-first-project/README.md) | Nginx serves HTML → Docker image → pushed to Docker Hub | ✅ Done |
| **3** — Azure VM Deploy | Pull image from Docker Hub on Azure B1s VM, expose port 80 | 🔄 In progress |

---

## Quick start (reproduce locally)

```bash
# 1. Pull the public image
docker pull rajankumar656/my-cloud-app:v1

# 2. Run it
docker run -d -p 8080:80 --name my-cloud-app rajankumar656/my-cloud-app:v1

# 3. Open browser
# → http://localhost:8080
```

---

## What I learned

- **WSL2 beats Vagrant** for Docker workflows — native kernel integration, no VM overhead, sub-2-second boot. Originally scaffolded with Vagrant + VirtualBox; switched mid-project after hitting disk/perf ceilings.
- **Port 80 on Windows** conflicts with IIS — WSL2 auto-forwards `localhost`, but fallback to WSL IP when needed (`hostname -I`).
- **Docker Hub as poor man's ACR** — free public registry, same `pull`/`push` semantics as Azure Container Registry. Good training ground before paying for cloud registries.
- **`nginx:alpine` base image is ~8 MB** vs ~140 MB for `nginx:latest`. Layer size matters when pulling on constrained cloud free tiers.

---

## Part of a larger roadmap

This is Project 1 of 4 on the path to a Cloud/DevOps co-op role:

1. **local-to-cloud-starter** ← you are here
2. **the-migration-arc** — Flask + GitHub Actions CI/CD → Azure App Service
3. **infrastructure-monitoring** — Prometheus + Grafana observability stack
4. **capstone** — AKS + full stack (Terraform + CI/CD + monitoring + app)

---

## Author

**Rajan Kumar** — Cloud Computing student, George Brown College (T465)
🔗 [LinkedIn](https://linkedin.com/in/imrajankumar95) · [GitHub](https://github.com/imrajankumar95)
