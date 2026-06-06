1|Inventory all non-stock software installed on this Linux machine. Produce a single markdown page grouped by category and install method. Include version numbers where available.
2|
3|Run these commands and organize the results:
4|
5|## Package manager packages (third-party only)
6|
7|1. Determine the distro (check /etc/os-release).
8|2. For Fedora/RHEL: `rpm -qa --qf '%{NAME}|%{VENDOR}\n' | grep -v "Fedora Project"` — these are non-Fedora packages.
9|3. For Ubuntu/Debian: List packages from PPAs and third-party repos — `apt list --installed 2>/dev/null` then cross-reference with `apt-cache policy <pkg>` to filter out stock repo packages. Alternatively, check `/etc/apt/sources.list.d/` for added repos and list their packages.
10|4. For Arch/Manjaro: `pacman -Qm` (foreign/AUR packages only).
11|
12|## Flatpak
13|
14|`flatpak list --app --columns=name,application,version,branch,origin` — apps only, skip runtimes.
15|
16|## Snap
17|
18|`snap list` — skip base snaps (bare, core*, gnome-*, gtk-common-themes).
19|
20|## /opt installs
21|
22|`ls /opt/` — list any commercial or standalone installs.
23|
24|## User-local CLI tools (~/.local/bin)
25|
26|`ls ~/.local/bin/` — tools installed via pip --user, uv, cargo, go install, etc.
27|
28|## pip user packages
29|
30|`pip3 list --user 2>/dev/null` — user-installed Python packages.
31|
32|## npm globals
33|
34|`npm list -g --depth=0 2>/dev/null` — global npm packages.
35|
36|## Homebrew (if present)
37|
38|`brew list 2>/dev/null` — Homebrew packages (common on macOS, sometimes on Linux).
39|
40|## Docker containers/images (optional)
41|
42|`docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}'` — running and stopped containers, if Docker is installed.
43|
44|## Output format
45|
46|Group results into these categories:
47|- **Browsers**
48|- **Development** (IDEs, runtimes, databases, containers)
49|- **AI / LLM**
50|- **Communication** (chat, email, video)
51|- **Productivity / Office**
52|- **Media / Creative**
53|- **Utilities** (security, file management, system tools)
54|- **Gaming**
55|- **Other**
56|
57|For each entry, note the install method in parentheses: (dnf), (apt), (Flatpak), (Snap), (/opt), (pip), (npm), (user-local), (AUR), (brew).
58|
59|Include an **Install Counts** summary at the bottom.
60|Include a **Repos Added** section listing any third-party repos/PPAs/Coprs found.
61|
62|## Skip
63|
64|- Stock distro packages (kernel, systemd, coreutils, base libs, etc.)
65|- Flatpak runtimes and platforms (org.freedesktop.Platform.*, org.gnome.Platform, etc.)
66|- Snap base snaps
67|- gpg-pubkey entries
68|- Shell profile dotfiles
69|