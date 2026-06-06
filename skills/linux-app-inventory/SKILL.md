---
name: linux-app-inventory
description: Generate a markdown inventory of all non-stock applications installed on a Linux system (Flatpak, Snap, dnf/apt/pacman, pip, npm, /opt, user-local). Shareable as a reusable prompt.
tags: [linux, inventory, system]
---

# Linux Application Inventory

Reusable prompt for enumerating all non-stock software on a Linux system and producing a structured markdown page.

## The Prompt

Copy the block below and give it to any AI agent with terminal access. It works on Fedora, Ubuntu/Debian, Arch, and derivatives.

```markdown
Inventory all non-stock software installed on this Linux machine. Produce a single markdown page grouped by category and install method. Include version numbers where available.

Run these commands and organize the results:

## Package manager packages (third-party only)

1. Determine the distro (check /etc/os-release).
2. For Fedora/RHEL: `rpm -qa --qf '%{NAME}|%{VENDOR}\n' | grep -v "Fedora Project"` — these are non-Fedora packages.
3. For Ubuntu/Debian: List packages from PPAs and third-party repos — `apt list --installed 2>/dev/null` then cross-reference with `apt-cache policy <pkg>` to filter out stock repo packages. Alternatively, check `/etc/apt/sources.list.d/` for added repos and list their packages.
4. For Arch/Manjaro: `pacman -Qm` (foreign/AUR packages only).

## Flatpak

`flatpak list --app --columns=name,application,version,branch,origin` — apps only, skip runtimes.

## Snap

`snap list` — skip base snaps (bare, core*, gnome-*, gtk-common-themes).

## /opt installs

`ls /opt/` — list any commercial or standalone installs.

## User-local CLI tools (~/.local/bin)

`ls ~/.local/bin/` — tools installed via pip --user, uv, cargo, go install, etc.

## pip user packages

`pip3 list --user 2>/dev/null` — user-installed Python packages.

## npm globals

`npm list -g --depth=0 2>/dev/null` — global npm packages.

## Homebrew (if present)

`brew list 2>/dev/null` — Homebrew packages (common on macOS, sometimes on Linux).

## Docker containers/images (optional)

`docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}'` — running and stopped containers, if Docker is installed.

## Output format

Group results into these categories:
- **Browsers**
- **Development** (IDEs, runtimes, databases, containers)
- **AI / LLM**
- **Communication** (chat, email, video)
- **Productivity / Office**
- **Media / Creative**
- **Utilities** (security, file management, system tools)
- **Gaming**
- **Other**

For each entry, note the install method in parentheses: (dnf), (apt), (Flatpak), (Snap), (/opt), (pip), (npm), (user-local), (AUR), (brew).

Include an **Install Counts** summary at the bottom.
Include a **Repos Added** section listing any third-party repos/PPAs/Coprs found.

## Skip

- Stock distro packages (kernel, systemd, coreutils, base libs, etc.)
- Flatpak runtimes and platforms (org.freedesktop.Platform.*, org.gnome.Platform, etc.)
- Snap base snaps
- gpg-pubkey entries
- Shell profile dotfiles
```

## Usage

**With an AI agent**: Paste the prompt block above into your chat.

**As a file**: Save the prompt block as `inventory-prompt.md` and reference it when starting a session:
```
hermes chat --prompt inventory-prompt.md
```

**One-liner for self-run**: If you just want the script without an AI agent, save this as `inventory.sh` and run it:

```bash
#!/usr/bin/env bash
# linux-app-inventory.sh — dump raw data for all non-stock installs
set -euo pipefail

echo "=== DISTRO ==="
cat /etc/os-release 2>/dev/null | head -5

echo -e "\n=== FLATPAK APPS ==="
flatpak list --app --columns=name,application,version,branch,origin 2>/dev/null || echo "(flatpak not found)"

echo -e "\n=== SNAP ==="
snap list 2>/dev/null || echo "(snap not found)"

echo -e "\n=== /opt ==="
ls /opt/ 2>/dev/null || echo "(/opt empty or not found)"

echo -e "\n=== ~/.local/bin ==="
ls ~/.local/bin/ 2>/dev/null || echo "(~/.local/bin empty)"

echo -e "\n=== PIP USER ==="
pip3 list --user 2>/dev/null || echo "(pip3 not found)"

echo -e "\n=== NPM GLOBAL ==="
npm list -g --depth=0 2>/dev/null || echo "(npm not found)"

echo -e "\n=== BREW ==="
brew list 2>/dev/null || echo "(brew not found)"

echo -e "\n=== DOCKER CONTAINERS ==="
docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || echo "(docker not found)"

# Distro-specific
if command -v rpm &>/dev/null; then
  echo -e "\n=== NON-FEDORA RPMs ==="
  rpm -qa --qf '%{NAME}|%{VENDOR}\n' 2>/dev/null | grep -v "Fedora Project" | grep -v "^gpg-pubkey"
elif command -v dpkg &>/dev/null; then
  echo -e "\n=== APT MANUAL INSTALLS ==="
  apt-mark showmanual 2>/dev/null | head -100
elif command -v pacman &>/dev/null; then
  echo -e "\n=== AUR / FOREIGN ==="
  pacman -Qm 2>/dev/null
fi

echo -e "\n=== THIRD-PARTY REPOS ==="
ls /etc/yum.repos.d/ 2>/dev/null
ls /etc/apt/sources.list.d/ 2>/dev/null
ls /etc/pacman.d/ 2>/dev/null
```

## Pitfalls

- `dnf list installed` may return 0 results on some Fedora systems due to db issues. Use `rpm -qa` instead.
- On apt systems, distinguishing stock from third-party requires checking `apt-cache policy` — there's no single clean command. The AI agent approach handles this better than a shell script.
- Flatpak `list` includes runtimes by default. Use `--app` flag to get applications only.
- Some apps install via both dnf AND /opt (e.g., Zoom, Vivaldi). Note duplicates.
- On Silverblue/Kinoite (ostree), most apps are Flatpaks — `rpm-ostree` is the layered package tool instead of dnf.
