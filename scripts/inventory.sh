1|#!/usr/bin/env bash
2|# linux-app-inventory.sh — dump raw data for all non-stock installs
3|# Output is unstructured; pipe to an AI agent for categorization.
4|set -euo pipefail
5|
6|echo "=== DISTRO ==="
7|cat /etc/os-release 2>/dev/null | head -5
8|
9|echo -e "\n=== FLATPAK APPS ==="
10|flatpak list --app --columns=name,application,version,branch,origin 2>/dev/null || echo "(flatpak not found)"
11|
12|echo -e "\n=== SNAP ==="
13|snap list 2>/dev/null || echo "(snap not found)"
14|
15|echo -e "\n=== /opt ==="
16|ls /opt/ 2>/dev/null || echo "(/opt empty or not found)"
17|
18|echo -e "\n=== ~/.local/bin ==="
19|ls ~/.local/bin/ 2>/dev/null || echo "(~/.local/bin empty)"
20|
21|echo -e "\n=== PIP USER ==="
22|pip3 list --user 2>/dev/null || echo "(pip3 not found)"
23|
24|echo -e "\n=== NPM GLOBAL ==="
25|npm list -g --depth=0 2>/dev/null || echo "(npm not found)"
26|
27|echo -e "\n=== BREW ==="
28|brew list 2>/dev/null || echo "(brew not found)"
29|
30|echo -e "\n=== DOCKER CONTAINERS ==="
31|docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' 2>/dev/null || echo "(docker not found)"
32|
33|# Distro-specific
34|if command -v rpm &>/dev/null; then
35|  echo -e "\n=== NON-FEDORA RPMs ==="
36|  rpm -qa --qf '%{NAME}|%{VENDOR}\n' 2>/dev/null | grep -v "Fedora Project" | grep -v "^gpg-pubkey"
37|elif command -v dpkg &>/dev/null; then
38|  echo -e "\n=== APT MANUAL INSTALLS ==="
39|  apt-mark showmanual 2>/dev/null | head -100
40|elif command -v pacman &>/dev/null; then
41|  echo -e "\n=== AUR / FOREIGN ==="
42|  pacman -Qm 2>/dev/null
43|fi
44|
45|echo -e "\n=== THIRD-PARTY REPOS ==="
46|ls /etc/yum.repos.d/ 2>/dev/null
47|ls /etc/apt/sources.list.d/ 2>/dev/null
48|ls /etc/pacman.d/ 2>/dev/null
49|