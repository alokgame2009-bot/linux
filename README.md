# Zyren Tech Linux Toolkit

**Version:** `1.0.0`  
**Maintained by:** Zyren Tech

A menu-driven Bash toolkit for selected Linux server setup and utilities. The interface uses purple, cyan and yellow terminal colours.

> **Important:** This repository contains scripts that can change SSH settings, install software, alter MOTD/PAM configuration, or configure services. Read the scripts before running them. Test on a disposable server first and keep backups. The toolkit is not a substitute for a server backup.

## Supported environment

- Debian/Ubuntu-based Linux for most installers (individual scripts may have narrower requirements).
- Bash 4+ recommended.
- Root/sudo access for system-level installation actions.
- Internet access for installers that download packages or binaries.

Some bundled tools are specific to Proxmox VE or Ubuntu. Do not run them on an incompatible host.

## Quick start — clone from GitHub

After uploading this repository to your GitHub account, run:

```bash
sudo apt update
sudo apt install -y git
 git clone https://github.com/YOUR-USERNAME/zyren-tech-linux-toolkit.git
cd zyren-tech-linux-toolkit
chmod +x ./*.sh
sudo ./install.sh
```

Replace `YOUR-USERNAME` with your GitHub username and adjust the repository name if you choose another one.

The installer copies the repository to `/opt/zyren-tech`, creates the `/usr/local/bin/zyren-tech` command, and launches the menu. You can then start it with:

```bash
sudo zyren-tech
```

## Run without installing

```bash
git clone https://github.com/YOUR-USERNAME/zyren-tech-linux-toolkit.git
cd zyren-tech-linux-toolkit
sudo bash zyren-tech.sh
```

## Main menu

```text
[1] Install
[2] Uninstall
[3] Update
[0] Exit
```

- **Install:** opens the toolkit's individual installer/utility menu.
- **Uninstall:** removes only the toolkit copy in `/opt/zyren-tech` and its launcher symlink. It does not remove software or system changes made by individual tools.
- **Update:** pulls fast-forward updates when `/opt/zyren-tech` is a Git checkout. If installed from a source ZIP, replace it with a newer release manually.

## Included scripts

| Script | Purpose |
|---|---|
| `proxmox-installer.sh` | Proxmox VE installer |
| `root.sh` | Ubuntu 22.04 PRoot/root filesystem setup |
| `ssh.sh` | SSH setup utility |
| `ssh-zyren-tech.sh` | SSH setup with Zyren Tech branding |
| `zyren-tech-motd.sh` | Premium Zyren Tech MOTD installer |
| `zyren-tech-motd-simple.sh` | Simple Zyren Tech MOTD installer |
| `fastfetch.sh` | Fastfetch installer |
| `fxtunnel-installer.sh` | fxTunnel installer |
| `localtonet.sh` | LocaltoNet installer |
| `detect-server.sh` | Server/virtualization detection |
| `rdp.sh` | Reserved/empty script; currently does nothing |
| `proxmox-installer-legacy.sh` | Legacy Proxmox installer; not exposed in the main menu |

## Update

From the installed Git checkout:

```bash
sudo zyren-tech
# Select 3 (Update)
```

Or update manually:

```bash
sudo git -C /opt/zyren-tech pull --ff-only
```

## Uninstall toolkit

Run `sudo zyren-tech`, select **2 (Uninstall)** and confirm. This removes the toolkit files and command symlink only. Review and remove any separately installed components yourself.

## Repository layout

```text
zyren-tech-linux-toolkit/
├── .gitignore
├── LICENSE
├── README.md
├── install.sh
├── zyren-tech.sh
└── *.sh
```

## Safety notes

- Inspect scripts before executing them, especially `proxmox-installer.sh`, `ssh.sh`, `ssh-zyren-tech.sh`, `zyren-tech-motd.sh`, and `fxtunnel-installer.sh`.
- The premium MOTD script changes PAM and MOTD configuration. Keep a console session open while testing SSH/PAM changes so you do not lock yourself out.
- Do not run Proxmox installation scripts on a production host without checking the official Proxmox requirements and backing up data.
- Only install software from sources you trust.

## License

MIT. See [LICENSE](LICENSE).
