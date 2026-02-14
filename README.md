# DevContainer Features for AI Coding Agents

A collection of [Dev Container Features](https://containers.dev/implementors/features/) for installing AI coding agents and related development tools.

## Features

### ai-coding-agents

Installs AI coding agents (OpenCode and/or Claude-Code).

**What's included:**
- 🤖 OpenCode - Open source AI coding agent
- 🤖 Claude-Code - Anthropic's AI coding agent  
- ⚙️ Pre-configured OpenCode settings

**Prerequisites (must be added to your devcontainer.json):**
- 📦 Node.js - JavaScript runtime (for agent installation)
- 📝 git - Version control
- 🐙 GitHub CLI (gh) - GitHub command-line tool

**Quick Start:**

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

📖 [Full documentation](./src/ai-coding-agents/README.md)

## Usage

Add features to your `devcontainer.json`:

```json
{
  "name": "My Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node": {},
    "ghcr.io/devcontainers/features/git": {},
    "ghcr.io/devcontainers/features/github-cli": {},
    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {
      "installOpencode": true,
      "installClaudeCode": true,
      "opencodeVersion": "latest",
      "claudeCodeVersion": "stable"
    }
  }
}
```

## Repository Structure

```
.
├── src/
│   └── ai-coding-agents/           # AI coding agents feature
│       ├── devcontainer-feature.json
│       ├── install.sh
│       ├── opencode.jsonc
│       └── README.md
└── test/
    └── ai-coding-agents/           # Feature tests
        └── test.sh
```

## Development

### Testing Locally

To test features locally, use the [devcontainer CLI](https://github.com/devcontainers/cli):

```bash
# Test a feature
devcontainer features test -f ai-coding-agents

# Build a devcontainer using the feature
devcontainer build --workspace-folder .
```

## License

MIT - See [LICENSE](LICENSE) for details.

## References

- [Dev Container Features specification](https://containers.dev/implementors/features/)
- [OpenCode](https://github.com/anomalyco/opencode)
- [Claude-Code](https://www.npmjs.com/package/@anthropic-ai/claude-code)
