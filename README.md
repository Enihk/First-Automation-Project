# First Automation Project: Using Vagrant 
### Dahboard & Counting Services

Automating services (dashboard and Counting) using Vagrant for Apple Silicon (M-series) MAcs.

---

## 1. Install a Hypervisor (VM)

This project uses **VirtualBox** as the hypervisor. Since the environment is Apple Silicon (M1-M5), download the **Developer Preview for macOS/Arm64** from the official site:

https://www.virtualbox.org/wiki/Downloads

---

## 2. Install Vagrant

```bash
brew install --cask hashicorp/tap/hashicorp-vagrant
```

---

## 3. Project Structure

```
dashboard-counting-automation
├── Vagrantfile
├── .ssh/
    ├── dc_rsa
    └── dc_rsa.pub
├── counting-service.sh
├── dashboard-service.sh
└── Vagrantfile
```

---

## 4. Provisioning Shell Scripts

The shell scripts ('counting-service.sh' & 'dashboard-service.sh') are invoked by the "Vagrant" on the first boot. In shell scripts:

1. Update the package manager and install required tools.
2. Download the binary files using 'curl' or 'wget' from the Hashicorp demo GitHub release. (make sure Linux ARM64)
3. Unzip the binary, remove zip files, rename & move to 'usr/bin'.
4. Sets the file permissions ('755') and ownerships ('vagrant:vagrant') on the binary. 
5. Create systemd service file.
6. Reload the systemd daemon, enable service and start.

---

## 5. Running the Project

Start the VMs:

```bash
vagrant up
```

SSH into each nodes:

```bash
vagrant ssh dashboard
vagrant ssh counting
```

Check the service are running inside the VMs:

```bash
sudo systemctl status dashboard
sudo systemctl status counting
```

Check the service is running on Web:

http://192.168.56.11:9002

---

## 6. Project Workflow Diagram 

![Project Workflow Diagram] (images/Workflow.png)

---

## 7. Troubleshooting

**`203/EXEC` error on service start**
- Make sure binaries are Linux ARM64, not Darwin. Recompile with `GOOS=linux GOARCH=arm64` if needed.
- Ensure binaries have execute permission: `chmod +x ./dashboard ./counting`
- If you edited a service file, run `sudo systemctl daemon-reload` inside the VM.

---

## 8. Useful Commands

- 'vagrant up' - Start and provision all VMs
- 'vagrant status' - Check curent VM state
- 'vagrant reload' - Restart and apply Vagrantfile changes
- 'vagrant destroy' - Delete all VMs and free disk space
