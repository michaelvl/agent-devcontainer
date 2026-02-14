## Prerequisites

This feature requires the following DevContainer features to be installed **before** this feature:

- **ghcr.io/devcontainers/features/node** - Provides Node.js and npm for installing the AI agents
- **ghcr.io/devcontainers/features/git** - Version control system
- **ghcr.io/devcontainers/features/github-cli** - GitHub command-line tool

**Important:** You must add these features to your `devcontainer.json` alongside this feature. See the example below.

## What Gets Installed

This feature installs:
- ✅ **OpenCode** (latest version by default)
- ✅ **Claude-Code** (latest version by default)
- ✅ **OpenCode configuration** at `~/.config/opencode/opencode.jsonc`

The following are **required prerequisites** that you must add to your devcontainer.json:
- **Node.js and npm** - Required for installing the AI agents
- **git** - Version control system
- **GitHub CLI (gh)** - GitHub command-line tool

## Complete Usage Example

Here's a complete `devcontainer.json` with all required features:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node": {},
    "ghcr.io/devcontainers/features/git": {},
    "ghcr.io/devcontainers/features/github-cli": {},
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {}
  }
}
```

## Usage Examples

### Install only OpenCode

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node": {},
    "ghcr.io/devcontainers/features/git": {},
    "ghcr.io/devcontainers/features/github-cli": {},
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {
      "installClaudeCode": false
    }
  }
}
```

### Install only Claude-Code

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node": {},
    "ghcr.io/devcontainers/features/git": {},
    "ghcr.io/devcontainers/features/github-cli": {},
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {
      "installOpencode": false
    }
  }
}
```

### Pin to specific versions

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node": {},
    "ghcr.io/devcontainers/features/git": {},
    "ghcr.io/devcontainers/features/github-cli": {},
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {
      "opencodeVersion": "1.2.0",
      "claudeCodeVersion": "stable"
    }
  }
}
```

## OpenCode Configuration

OpenCode is pre-configured with the following settings:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.5",
  "permission": "allow",
  "share": "disabled",
  "theme": "tokyonight"
}
```

**Configuration location:** `~/.config/opencode/opencode.jsonc`

You can modify this file after container creation to customize your OpenCode settings.

## Required Dependencies

This feature requires the following features to be added to your `devcontainer.json`:

- **ghcr.io/devcontainers/features/node** - Provides Node.js and npm for installing the AI agents
- **ghcr.io/devcontainers/features/git** - Version control system for development
- **ghcr.io/devcontainers/features/github-cli** - GitHub command-line tool

These features use the `installsAfter` property to ensure they are installed in the correct order, but you must explicitly add them to your configuration.

## Implementation Notes

- Both agents are installed globally and available on the PATH
- The installation script runs as root but sets proper permissions for the container user
- Configuration files are owned by the container user (typically `vscode`, `node`, or `codespace`)
- If neither agent is selected for installation, the script will skip with a warning
