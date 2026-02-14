#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Michael Vittrup Larsen. All rights reserved.
# Licensed under the MIT License. See https://github.com/michaelvl/agent-devcontainer/blob/main/LICENSE for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/michaelvl/agent-devcontainer/tree/main/src/ai-coding-agents
# Maintainer: Michael Vittrup Larsen

set -e

# Parse options (converted to uppercase environment variables by devcontainer spec)
INSTALL_OPENCODE="${INSTALLOPENCODE:-"true"}"
OPENCODE_VERSION="${OPENCODEVERSION:-"latest"}"
INSTALL_CLAUDE_CODE="${INSTALLCLAUDECODE:-"true"}"
CLAUDE_CODE_VERSION="${CLAUDECODEVERSION:-"latest"}"

# User detection variables provided by devcontainer spec
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
USER_HOME="${_REMOTE_USER_HOME:-"automatic"}"

# Must run as root
if [ "$(id -u)" -ne 0 ]; then
        echo -e 'ERROR: Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
        exit 1
fi

echo "=========================================="
echo "AI Coding Agents Feature Installation"
echo "=========================================="

# Auto-detect username if needed
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
        USERNAME=""
        POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
        for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
                if id -u ${CURRENT_USER} >/dev/null 2>&1; then
                        USERNAME=${CURRENT_USER}
                        break
                fi
        done
        if [ "${USERNAME}" = "" ]; then
                USERNAME=root
        fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} >/dev/null 2>&1; then
        USERNAME=root
fi

echo "Container user: ${USERNAME}"

# Determine user home directory
if [ "${USER_HOME}" = "automatic" ] || [ "${USER_HOME}" = "" ]; then
        USER_HOME=$(eval echo "~${USERNAME}")
fi

echo "User home directory: ${USER_HOME}"

# Verify npm is available (should be installed via node feature)
if ! command -v npm >/dev/null 2>&1; then
	echo "ERROR: npm not found. The Node.js feature must be installed."
	echo ""
	echo "Please add the Node.js feature to your devcontainer.json:"
	echo '  "features": {'
	echo '    "ghcr.io/devcontainers/features/node": {},'
	echo '    "ghcr.io/michaelvl/agent-devcontainer/ai-coding-agents:1": {}'
	echo '  }'
	echo ""
	echo "Required features:"
	echo "  - ghcr.io/devcontainers/features/node (for npm)"
	echo "  - ghcr.io/devcontainers/features/git (for version control)"
	echo "  - ghcr.io/devcontainers/features/github-cli (for gh command)"
	exit 1
fi

echo "npm found: $(npm --version)"

# Verify at least one agent is selected
if [ "${INSTALL_OPENCODE}" != "true" ] && [ "${INSTALL_CLAUDE_CODE}" != "true" ]; then
        echo "WARNING: No AI coding agents selected for installation."
        echo "Both installOpencode and installClaudeCode are set to false."
        echo "Skipping installation."
        exit 0
fi

# Get the directory where this script is located (where config files are)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install OpenCode
if [ "${INSTALL_OPENCODE}" = "true" ]; then
        echo ""
        echo "Installing OpenCode version ${OPENCODE_VERSION}..."
        echo "------------------------------------------"

        # Install via npm
        npm install -g "opencode-ai@${OPENCODE_VERSION}"

        # Verify installation
        if command -v opencode >/dev/null 2>&1; then
                echo "✓ OpenCode installed successfully"
                opencode --version || echo "OpenCode is ready to use"
        else
                echo "ERROR: OpenCode installation failed - command not found"
                exit 1
        fi

        # Install OpenCode configuration
        echo ""
        echo "Setting up OpenCode configuration..."
        OPENCODE_CONFIG_DIR="${USER_HOME}/.config/opencode"

        # Create config directory
        mkdir -p "${OPENCODE_CONFIG_DIR}"

        # Copy configuration file
        if [ -f "${SCRIPT_DIR}/opencode.jsonc" ]; then
                cp "${SCRIPT_DIR}/opencode.jsonc" "${OPENCODE_CONFIG_DIR}/opencode.jsonc"
                echo "✓ OpenCode configuration installed at ${OPENCODE_CONFIG_DIR}/opencode.jsonc"
        else
                echo "WARNING: opencode.jsonc not found in ${SCRIPT_DIR}"
        fi

        # Set proper ownership and permissions
        chown -R ${USERNAME}:${USERNAME} "${OPENCODE_CONFIG_DIR}" 2>/dev/null || true
        chmod 755 "${OPENCODE_CONFIG_DIR}"
        chmod 644 "${OPENCODE_CONFIG_DIR}/opencode.jsonc" 2>/dev/null || true

        echo "✓ OpenCode configuration permissions set"
fi

# Install Claude-Code
if [ "${INSTALL_CLAUDE_CODE}" = "true" ]; then
        echo ""
        echo "Installing Claude-Code version ${CLAUDE_CODE_VERSION}..."
        echo "------------------------------------------"

        # Install via npm
        npm install -g "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"

        # Verify installation
        if command -v claude >/dev/null 2>&1; then
                echo "✓ Claude-Code installed successfully"
                # Try to get version, but don't fail if it doesn't support --version
                claude --version 2>/dev/null || echo "Claude-Code is ready to use"
        else
                echo "ERROR: Claude-Code installation failed - command not found"
                exit 1
        fi
fi

# Summary
echo ""
echo "=========================================="
echo "✓ Installation Complete"
echo "=========================================="
echo ""
echo "Installed components:"
[ "${INSTALL_OPENCODE}" = "true" ] && echo "  ✓ OpenCode (configured at ~/.config/opencode/)"
[ "${INSTALL_CLAUDE_CODE}" = "true" ] && echo "  ✓ Claude-Code"
echo ""
echo "Dependencies (via dependsOn):"
echo "  ✓ Node.js and npm"
echo "  ✓ git"
echo "  ✓ GitHub CLI (gh)"
echo ""
echo "=========================================="
echo "AI coding agents are ready to use!"
echo "=========================================="
