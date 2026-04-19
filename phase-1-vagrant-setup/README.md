# Phase 1 — Dev Environment Setup (Windows)

## What you're building
A local Ubuntu 22.04 virtual machine with Docker, Terraform, and Nginx
pre-installed. This is your "mini cloud" on your Windows laptop.

---

## Step 1 — Install VirtualBox

1. Go to https://www.virtualbox.org/wiki/Downloads
2. Click **Windows hosts** under "VirtualBox platform packages"
3. Run the installer → click through defaults → Finish
4. Restart your computer if prompted

---

## Step 2 — Install Vagrant

1. Go to https://developer.hashicorp.com/vagrant/downloads
2. Click **AMD64** under Windows
3. Run the `.msi` installer → click through defaults → Finish
4. Open **PowerShell** and verify:
   ```
   vagrant --version
   ```
   You should see something like: `Vagrant 2.4.x`

---

## Step 3 — Create your project folder

Open **PowerShell** (search for it in Start menu):

```powershell
mkdir ~/vagrant-projects
cd ~/vagrant-projects
```

---

## Step 4 — Copy this folder into vagrant-projects

Copy the `phase-1-vagrant-setup` folder (this folder) into `~/vagrant-projects`.
Your structure should look like:

```
vagrant-projects/
└── phase-1-vagrant-setup/
    ├── Vagrantfile
    ├── scripts/
    │   └── install-tools.sh
    └── README.md
```

Then `cd` into it:
```powershell
cd ~/vagrant-projects/phase-1-vagrant-setup
```

---

## Step 5 — Start the VM

```powershell
vagrant up
```

**What happens:**
- Vagrant downloads the Ubuntu 22.04 image (~1GB, one time only)
- VirtualBox creates the VM with 2GB RAM, 2 CPUs
- The `install-tools.sh` script runs automatically — installs Docker, Terraform, Nginx
- Takes about 5–10 minutes on first run

You'll see a lot of output — that's normal. When it finishes you'll see the
"Setup complete!" banner.

---

## Step 6 — Enter the VM

```powershell
vagrant ssh
```

You're now inside the Ubuntu VM. Verify everything works:

```bash
docker --version
terraform --version
nginx -v
```

---

## Useful Vagrant commands (run from Windows PowerShell, not inside VM)

| Command | What it does |
|---|---|
| `vagrant up` | Start the VM |
| `vagrant ssh` | Enter the VM |
| `vagrant halt` | Shut down the VM (keeps your files) |
| `vagrant destroy` | Delete the VM completely |
| `vagrant status` | Check if VM is running |

---

## Ready for Phase 2?

Once you can `vagrant ssh` and see Docker/Terraform versions → Phase 1 is done.
Move to `phase-2-first-project/` for the actual app deployment.
