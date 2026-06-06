#!/usr/bin/env bash
# linux-app-inventory.sh — dump raw data for all non-stock installs
# Output is unstructured; pipe to an AI agent for categorization.
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
