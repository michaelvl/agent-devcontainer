
# AI Coding Agents (OpenCode & Claude-Code) (ai-coding-agents)

Installs AI coding agents (OpenCode and/or Claude-Code) with git and GitHub CLI dependencies, including OpenCode configuration

## Example Usage

```json
"features": {
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installOpencode | Install OpenCode AI coding agent | boolean | true |
| opencodeVersion | Version of OpenCode to install | string | latest |
| installClaudeCode | Install Claude-Code AI coding agent | boolean | true |
| claudeCodeVersion | Version of Claude-Code to install | string | latest |

## What Gets Installed

This will install:
- ✅ **OpenCode** (latest version)
- ✅ **Claude-Code** (latest version)
- ✅ **Node.js** (via dependency)
- ✅ **git** (via dependency)
- ✅ **GitHub CLI** (gh) (via dependency)
- ✅ **OpenCode configuration** at `~/.config/opencode/opencode.jsonc`

## Usage Examples

### Install only OpenCode

```json
{
  "features": {
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

## Dependencies

This feature automatically installs the following dependencies (you don't need to add them separately):

- **Node.js and npm** - Required for installing the AI agents
- **git** - Version control system
- **GitHub CLI (gh)** - GitHub command-line tool

These are installed via the `dependsOn` property using official devcontainer features.

## Implementation Notes

- Both agents are installed globally and available on the PATH
- The installation script runs as root but sets proper permissions for the container user
- Configuration files are owned by the container user (typically `vscode`, `node`, or `codespace`)
- If neither agent is selected for installation, the script will skip with a warning


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michaelvl/agent-devcontainer/blob/main/src/ai-coding-agents/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
