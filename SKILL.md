1|---
2|name: linux-app-inventory
3|description: Generate a markdown inventory of all non-stock applications installed on a Linux system (Flatpak, Snap, dnf/apt/pacman, pip, npm, /opt, user-local). Shareable as a reusable prompt.
4|tags: [linux, inventory, system]
5|---
6|
7|# Linux Application Inventory
8|
9|Reusable prompt for enumerating all non-stock software on a Linux system and producing a structured markdown page.
10|
11|## The Prompt
12|
13|Copy the block below and give it to any AI agent with terminal access. It works on Fedora, Ubuntu/Debian, Arch, and derivatives.
14|
15|```markdown
16|Inventory all non-stock software installed on this Linux machine. Produce a single markdown page grouped by category and install method. Include version numbers where available.
17|
18|Run these commands and organize the results:
19|
20|## Package manager packages (third-party only)
21|
22|1. Determine the distro (check /etc/os-release).
23|2. For Fedora/RHEL: `rpm -qa --qf '%{NAME}|%{VENDOR}\n' | grep -v "Fedora Project"` — these are non-Fedora packages.
24|3. For Ubuntu/Debian: List packages from PPAs and third-party repos — `apt list --installed 2>/dev/null` then cross-reference with `apt-cache policy <pkg>` to filter out stock repo packages. Alternatively, check `/etc/apt/sources.list.d/` for added repos and list their packages.
25|4. For Arch/Manjaro: `pacman -Qm` (foreign/AUR packages only).
26|
27|## Flatpak
28|
29|`flatpak list --app --columns=name,application,version,branch,origin` — apps only, skip runtimes.
30|
31|## Snap
32|
33|`snap list` — skip base snaps (bare, core*, gnome-*, gtk-common-themes).
34|
35|## /opt installs
36|
37|`ls /opt/` — list any commercial or standalone installs.
38|
39|## User-local CLI tools (~/.local/bin)
40|
41|`ls ~/.local/bin/` — tools installed via pip --user, uv, cargo, go install, etc.
42|
43|## pip user packages
44|
45|`pip3 list --user 2>/dev/null` — user-installed Python packages.
46|
47|## npm globals
48|
49|`npm list -g --depth=0 2>/dev/null` — global npm packages.
50|
51|## Homebrew (if present)
52|
53|`brew list 2>/dev/null` — Homebrew packages (common on macOS, sometimes on Linux).
54|
55|## Docker containers/images (optional)
56|
57|`docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}'` — running and stopped containers, if Docker is installed.
58|
59|## Output format
60|
61|Group results into these categories:
62|- **Browsers**
63|- **Development** (IDEs, runtimes, databases, containers)
64|- **AI / LLM**
65|- **Communication** (chat, email, video)
66|- **Productivity / Office**
67|- **Media / Creative**
68|- **Utilities** (security, file management, system tools)
69|- **Gaming**
70|- **Other**
71|
72|For each entry, note the install method in parentheses: (dnf), (apt), (Flatpak), (Snap), (/opt), (pip), (npm), (user-local), (AUR), (brew).
73|
74|Include an **Install Counts** summary at the bottom.
75|Include a **Repos Added** section listing any third-party repos/PPAs/Coprs found.
76|
77|## Skip
78|
79|- Stock distro packages (kernel, systemd, coreutils, base libs, etc.)
80|- Flatpak runtimes and platforms (org.freedesktop.Platform.*, org.gnome.Platform, etc.)
81|- Snap base snaps
82|- gpg-pubkey entries
83|- Shell profile dotfiles
84|```
85|
86|## Usage
87|
88|**With an AI agent**: Paste the prompt block above into your chat.
89|
90|**As a file**: Save the prompt block as `inventory-prompt.md` and reference it when starting a session:
91|```
92|hermes chat --prompt inventory-prompt.md
93|```
94|
95|**One-liner for self-run**: If you just want the script without an AI agent, save this as `inventory.sh` and run it:
96|
97|```bash
98|#!/usr/bin/env bash
99|# linux-app-inventory.sh — dump raw data for all non-stock installs
100|set -euo pipefail
101|
102|echo "=== DISTRO ==="
103|cat /etc/os-release 2>/dev/null | head -5
104|
105|echo -e "\n=== FLATPAK APPS ==="
106|flatpak list --app --columns=name,application,version,branch,origin 2>/dev/null || echo "(flatpak not found)"
107|
108|echo -e "\n=== SNAP ==="
109|snap list 2>/dev/null || echo "(snap not found)"
110|
111|echo -e "\n=== /opt ==="
112|ls /opt/ 2>/dev/null || echo "(/opt empty or not found)"
113|
114|echo -e "\n=== ~/.local/bin ==="
115|ls ~/.local/bin/ 2>/dev/null || echo "(~/.local/bin empty)"
116|
117|echo -e "\n=== PIP USER ==="
118|pip3 list --user 2>/dev/null || echo "(pip3 not found)"
119|
120|echo -e "\n=== NPM GLOBAL ==="
121|npm list -g --depth=0 2>/dev/null || echo "(npm not found)"
122|
123|echo -e "\n=== BREW ==="
124|brew list 2>/dev/null || echo "(brew not found)"
125|
126|echo -e "\n=== DOCKER CONTAINERS ==="
127|docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || echo "(docker not found)"
128|
129|# Distro-specific
130|if command -v rpm &>/dev/null; then
131|  echo -e "\n=== NON-FEDORA RPMs ==="
132|  rpm -qa --qf '%{NAME}|%{VENDOR}\n' 2>/dev/null | grep -v "Fedora Project" | grep -v "^gpg-pubkey"
133|elif command -v dpkg &>/dev/null; then
134|  echo -e "\n=== APT MANUAL INSTALLS ==="
135|  apt-mark showmanual 2>/dev/null | head -100
136|elif command -v pacman &>/dev/null; then
137|  echo -e "\n=== AUR / FOREIGN ==="
138|  pacman -Qm 2>/dev/null
139|fi
140|
141|echo -e "\n=== THIRD-PARTY REPOS ==="
142|ls /etc/yum.repos.d/ 2>/dev/null
143|ls /etc/apt/sources.list.d/ 2>/dev/null
144|ls /etc/pacman.d/ 2>/dev/null
145|```
146|
147|## Pitfalls
148|
149|- `dnf list installed` may return 0 results on some Fedora systems due to db issues. Use `rpm -qa` instead.
150|- On apt systems, distinguishing stock from third-party requires checking `apt-cache policy` — there's no single clean command. The AI agent approach handles this better than a shell script.
151|- Flatpak `list` includes runtimes by default. Use `--app` flag to get applications only.
152|- Some apps install via both dnf AND /opt (e.g., Zoom, Vivaldi). Note duplicates.
153|- On Silverblue/Kinoite (ostree), most apps are Flatpaks — `rpm-ostree` is the layered package tool instead of dnf.
154|