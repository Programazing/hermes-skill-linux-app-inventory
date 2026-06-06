# hermes-skill-linux-app-inventory

A [Hermes Agent](https://hermes-agent.nousresearch.com/) skill for inventorying all non-stock software on a Linux machine.

## What it does

Enumerates applications installed via every common method on a Linux system:
- dnf/apt/pacman (third-party packages only)
- Flatpak
- Snap
- /opt installs
- ~/.local/bin (user-local CLI tools)
- pip user packages
- npm globals
- Homebrew
- Docker containers

Produces a categorized markdown page with install counts and repos added.

## Install

```bash
hermes skills install https://raw.githubusercontent.com/Programazing/hermes-skill-linux-app-inventory/main/SKILL.md
```

## Use without Hermes

The prompt in `templates/prompt.md` works with any AI agent that has terminal access (Claude Code, Codex, ChatGPT, etc.). Just paste it into your chat.

For a no-agent approach, run `scripts/inventory.sh` directly — it dumps raw data you can categorize yourself.

## Files

- `SKILL.md` — skill definition (loads into Hermes automatically)
- `templates/prompt.md` — the standalone reusable prompt
- `scripts/inventory.sh` — bare shell script for raw data collection

## Distro support

- Fedora / RHEL (rpm)
- Ubuntu / Debian (apt)
- Arch / Manjaro (pacman/AUR)
- Silverblue / Kinoite (ostree)
