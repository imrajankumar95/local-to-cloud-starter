# Phase 2 — First Real Project: Local → Docker → Cloud

## The story of this project
You have an HTML app. You serve it with Nginx on a local VM.
Then you containerize it. Then you push it to a registry.
Then it runs the same way anywhere — Azure, AWS, your laptop.
That's the core idea behind every cloud migration.

---

## Prerequisites
- Phase 1 complete (VM is running, `vagrant ssh` works)
- Docker Hub account (free): https://hub.docker.com

---

## Part A — Serve the app with Nginx on the VM

### Step 1 — Get into your VM
On Windows PowerShell (from the `phase-1-vagrant-setup` folder):
```powershell
vagrant ssh
```

### Step 2 — Copy the HTML file into the VM
The `~/vagrant-projects` folder on Windows is automatically shared at `/vagrant`
inside the VM. So your files are already there.

```bash
# Inside the VM:
sudo cp /vagrant/../phase-2-first-project/app/index.html /var/www/html/index.html
```

Or just create it directly:
```bash
sudo nano /var/www/html/index.html
# Paste the contents of app/index.html, then Ctrl+X → Y → Enter to save
```

### Step 3 — Apply the Nginx config
```bash
sudo cp /vagrant/../phase-2-first-project/nginx.conf /etc/nginx/sites-available/default
sudo nginx -t          # Test the config — should say "ok"
sudo systemctl reload nginx
```

### Step 4 — Find your VM's IP address
```bash
hostname -I
# Will output something like: 10.0.2.15  192.168.x.x
```

Use the second IP (the `192.168.x.x` one). Open your **Windows browser** and go to:
```
http://192.168.x.x
```
You should see the app. **Phase A done ✅**

---

## Part B — Containerize with Docker

### Step 5 — Copy project files into VM and build
```bash
# Inside the VM — create a working directory
mkdir ~/my-app && cd ~/my-app

# Copy files from the shared folder
cp /vagrant/../phase-2-first-project/app/index.html .
cp /vagrant/../phase-2-first-project/app/Dockerfile .

ls
# Should show: Dockerfile  index.html
```

### Step 6 — Build the Docker image
```bash
docker build -t my-app:v1 .
```

**What's happening:** Docker reads the Dockerfile, takes `nginx:alpine` as the
base, copies your `index.html` into it, and creates an image called `my-app:v1`.

Verify the image exists:
```bash
docker images
# Should show my-app   v1   ...
```

### Step 7 — Run the container locally
```bash
docker run -d -p 8080:80 --name my-app my-app:v1
```

**Flags explained:**
- `-d` → run in background (detached)
- `-p 8080:80` → map port 8080 on VM to port 80 inside container
- `--name my-app` → give the container a readable name

Check it's running:
```bash
docker ps
curl http://localhost:8080
```

On Windows browser (port 8080 is forwarded via Vagrantfile):
```
http://localhost:8080
```
Same app, now running inside a container. **Phase B done ✅**

### Useful Docker commands
```bash
docker logs my-app          # See container logs
docker stop my-app          # Stop the container
docker start my-app         # Start it again
docker rm my-app            # Delete the container
docker rmi my-app:v1        # Delete the image
```

---

## Part C — Push to Docker Hub

### Step 8 — Log in to Docker Hub
```bash
# Replace YOUR_USERNAME with your Docker Hub username
docker login
# Enter your Docker Hub username and password when prompted
```

### Step 9 — Tag the image for Docker Hub
```bash
# Replace YOUR_USERNAME with your actual Docker Hub username
docker tag my-app:v1 YOUR_USERNAME/my-app:v1
```

### Step 10 — Push the image
```bash
docker push YOUR_USERNAME/my-app:v1
```

Go to https://hub.docker.com → your profile → you'll see `my-app` repository.
Your image is now publicly accessible from anywhere in the world.

---

## Part D — "Cloud deploy" simulation

### Step 11 — Pull and run as if you were a cloud VM
Stop and remove the local container:
```bash
docker stop my-app && docker rm my-app
docker rmi my-app:v1               # Remove local image
docker rmi YOUR_USERNAME/my-app:v1  # Remove local tagged image
```

Now pull from Docker Hub (simulating a fresh cloud VM):
```bash
docker pull YOUR_USERNAME/my-app:v1
docker run -d -p 8080:80 --name my-app YOUR_USERNAME/my-app:v1
curl http://localhost:8080
```

This is exactly what a cloud service (Azure Container Instances, AWS ECS,
a Kubernetes pod) does when deploying your app. **Phase C done ✅**

---

## What you've proven
| Stage | What ran it |
|---|---|
| Raw HTML | Nginx on Ubuntu VM |
| Containerized | Docker on the same VM |
| Registry | Docker Hub |
| "Cloud" pull | Same image, pulled from registry |

The Migration Arc project does this same flow — but with a real Flask API,
GitHub Actions CI/CD, and actual Azure/AWS Kubernetes clusters.

---

## Next step → the-migration-arc
Once you're comfortable with this flow, the migration-arc project applies
the same thinking at production scale:
- Flask API instead of static HTML
- GitHub Actions instead of manual commands
- ACR/ECR instead of Docker Hub
- AKS/EKS instead of a local container
