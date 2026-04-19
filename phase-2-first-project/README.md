# Phase 2 — First Real Project: Local → Docker → Cloud

## The story of this project
You have an HTML app. You serve it with Nginx on WSL2 Ubuntu.
Then you containerize it with Docker. Then you push it to Docker Hub.
Then it runs the same way anywhere — Azure, AWS, any laptop.
That's the core idea behind every cloud migration.

---

## Prerequisites
- Phase 1 complete (WSL2 Ubuntu running, Docker + Nginx installed)
- Docker Hub account (free): https://hub.docker.com

---

## Part A — Serve the app with Nginx on WSL

### Step 1 — Open WSL terminal
From Windows, launch **Ubuntu** (Start menu) or run `wsl` in PowerShell.

### Step 2 — Copy the HTML file
From your project folder (mounted at `/mnt/c/...` or copied to `~/projects/`):

```bash
sudo cp app/index.html /var/www/html/index.html
```

### Step 3 — Apply the Nginx config
```bash
sudo cp nginx.conf /etc/nginx/sites-available/default
sudo nginx -t          # Test config — should say "ok"
sudo service nginx reload
```

### Step 4 — Open the app in your Windows browser
WSL2 auto-forwards ports to Windows `localhost`. Open:
```
http://localhost
```
You should see the app. **Part A done ✅**

If port 80 conflicts with IIS or another service on Windows:
```bash
hostname -I        # Get WSL IP (e.g., 172.x.x.x)
# Then browse: http://<that-ip>
```

---

## Part B — Containerize with Docker

### Step 5 — Build the image
From the `phase-2-first-project/app/` directory:
```bash
cd app
docker build -t my-cloud-app:v1 .
```

**What's happening:** Docker reads the Dockerfile, takes `nginx:alpine` as base, copies `index.html` in, creates image `my-cloud-app:v1`.

Verify:
```bash
docker images | grep my-cloud-app
```

### Step 6 — Run the container
```bash
docker run -d -p 8080:80 --name my-cloud-app my-cloud-app:v1
```

**Flags:**
- `-d` → detached (background)
- `-p 8080:80` → map host 8080 → container 80
- `--name` → readable container name

Verify:
```bash
docker ps
curl http://localhost:8080
```

Windows browser:
```
http://localhost:8080
```
Same app, now in a container. **Part B done ✅**

### Useful Docker commands
```bash
docker logs my-cloud-app
docker stop my-cloud-app
docker start my-cloud-app
docker rm my-cloud-app
docker rmi my-cloud-app:v1
```

---

## Part C — Push to Docker Hub

### Step 7 — Log in
```bash
docker login
# Enter Docker Hub username + password
```

### Step 8 — Tag for Docker Hub
```bash
docker tag my-cloud-app:v1 rajankumar656/my-cloud-app:v1
```
(Replace `rajankumar656` with your Docker Hub username.)

### Step 9 — Push
```bash
docker push rajankumar656/my-cloud-app:v1
```

Go to https://hub.docker.com → your profile → `my-cloud-app` repo now public. Image is accessible anywhere in the world.

**Live image:** [hub.docker.com/r/rajankumar656/my-cloud-app](https://hub.docker.com/r/rajankumar656/my-cloud-app)

---

## Part D — "Cloud deploy" simulation

### Step 10 — Clean slate + pull from registry
```bash
docker stop my-cloud-app && docker rm my-cloud-app
docker rmi my-cloud-app:v1 rajankumar656/my-cloud-app:v1
```

Now pull as if from a fresh cloud VM:
```bash
docker pull rajankumar656/my-cloud-app:v1
docker run -d -p 8080:80 --name my-cloud-app rajankumar656/my-cloud-app:v1
curl http://localhost:8080
```

This is exactly what a cloud service (Azure Container Instances, AWS ECS, Kubernetes pod) does when deploying your app. **Part D done ✅**

---

## What you've proven

| Stage | Runs on |
|---|---|
| Raw HTML | Nginx on WSL2 Ubuntu |
| Containerized | Docker on WSL2 |
| Registry | Docker Hub (public) |
| "Cloud" pull | Same image, pulled from registry |

---

## Next step → Phase 3 (Azure deploy)
Take the same image, run it on an **Azure B1s VM**. Same `docker pull` + `docker run` commands — now on real cloud infrastructure with a public IP.

After that → **the-migration-arc** project applies this flow at production scale:
- Flask API instead of static HTML
- GitHub Actions instead of manual pushes
- Azure Container Registry (ACR) instead of Docker Hub
- Azure App Service / AKS instead of a single VM
