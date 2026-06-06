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
