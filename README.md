# local-to-cloud-starter

> From a blank Windows laptop → HTML app → Nginx → Docker container → Docker Hub → **Azure Static Web Apps** with GitHub Actions CI/CD. The full local-to-cloud migration arc, one phase at a time.

**Live demo:** 🚀 [ashy-bay-0d76ae90f.7.azurestaticapps.net](https://ashy-bay-0d76ae90f.7.azurestaticapps.net)

**Stack:** WSL2 · Ubuntu 24.04 · Nginx · Docker · Docker Hub · GitHub Actions · Azure Static Web Apps

**Docker image:** [hub.docker.com/r/rajankumar656/my-cloud-app](https://hub.docker.com/r/rajankumar656/my-cloud-app)

---

## Why this project exists

Most cloud tutorials skip the bridge between *"I wrote some code"* and *"it runs on cloud with a public URL."* This repo builds that bridge step by step — each phase is a real deployable artifact, not a slide deck.

Goal: learn by shipping, one phase at a time, until the same app that runs locally serves traffic from Azure with auto-deploy from GitHub.

---

## Architecture

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  Windows 11      │    │  WSL2 Ubuntu     │    │  Docker Hub      │
│  (host)          │───▶│  24.04 LTS       │───▶│  public registry │
│  Browser         │    │  Nginx + Docker  │    │  my-cloud-app:v1 │
└──────────────────┘    └──────────────────┘    └──────────────────┘

                            ┌──────────────────┐    ┌──────────────────┐
                            │  GitHub repo     │───▶│  GitHub Actions  │
                            │  main branch     │    │  build + deploy  │
                            └──────────────────┘    └──────────────────┘
                                                              │
                                                              ▼
                                                   ┌──────────────────┐
                                                   │  Azure Static    │
                                                   │  Web Apps (Free) │
                                                   │  HTTPS + CDN     │
                                                   └──────────────────┘
```

---

## Phases

| Phase | What it ships | Status |
|---|---|---|
| **1** — [WSL2 Dev Environment](phase-1-wsl-setup/README.md) | Ubuntu 24.04 + Docker + Terraform + Nginx on WSL2 | ✅ Done |
| **2** — [First Project: HTML → Container → Registry](phase-2-first-project/README.md) | Nginx serves HTML → Docker image → pushed to Docker Hub | ✅ Done |
| **3** — Azure Static Web Apps Deploy | GitHub push → Actions workflow → live on Azure with HTTPS | ✅ Done |

---

## Quick start (run locally)

**Option A — Docker (recommended)**
```bash
docker pull rajankumar656/my-cloud-app:v1
docker run -d -p 8080:80 --name my-cloud-app rajankumar656/my-cloud-app:v1
# → http://localhost:8080
```

**Option B — Clone + open**
```bash
git clone https://github.com/imrajankumar95/local-to-cloud-starter.git
cd local-to-cloud-starter/phase-2-first-project/app
# Open index.html in browser
```

---

## How the deploy works

1. Push to `main` on GitHub
2. `.github/workflows/azure-static-web-apps-*.yml` triggers
3. Action uploads `phase-2-first-project/app/` to Azure Static Web Apps
4. Azure publishes to global CDN with HTTPS
5. Live in ~40 seconds

No servers to manage. No containers running 24/7. No quota fights.

---

## What I learned

- **WSL2 beats Vagrant** for Docker workflows — native kernel integration, no VM overhead, sub-2-second boot. Originally scaffolded with Vagrant + VirtualBox; switched mid-project after hitting disk/perf ceilings.
- **Azure Student subscription has guardrails** — region policies, zero vCPU quota by default on B-series, F1 App Service also quota-locked. Real cloud engineering problem, not a tutorial bug.
- **Pivot beats perfection** — original plan was Azure B1s VM + `docker run`. Blocked by quota. Pivoted to Static Web Apps in 10 minutes. Shipped same day. *"Ship broken > hoard perfect."*
- **GitHub Actions auto-wire is free CI/CD** — Azure Static Web Apps wrote the workflow file into my repo on creation. Zero manual YAML needed for v1.
- **Docker Hub = poor man's ACR** — free public registry, same `pull`/`push` semantics as Azure Container Registry. Good training ground before paying for cloud registries.
- **`nginx:alpine` base image is ~8 MB** vs ~140 MB for `nginx:latest`. Layer size matters when pulling on constrained cloud free tiers.

---

## Cost

**$0/month.** Azure Static Web Apps Free tier:
- 100 GB bandwidth/mo
- 2 custom domains
- SSL included
- Global CDN

No credit card charge as long as site stays on Free tier.

---

## Part of a larger roadmap

This is Project 1 of 4 on the path to a Cloud/DevOps co-op role by Sep 2026:

1. **local-to-cloud-starter** ← you are here ✅
2. **the-migration-arc** — Flask + GitHub Actions CI/CD → Azure App Service
3. **infrastructure-monitoring** — Prometheus + Grafana observability stack
4. **capstone** — AKS + full stack (Terraform + CI/CD + monitoring + app)

---

## Author

**Rajan Kumar** — Cloud Computing student, George Brown College (T465)
🔗 [LinkedIn](https://linkedin.com/in/imrajankumar95) · [GitHub](https://github.com/imrajankumar95)
