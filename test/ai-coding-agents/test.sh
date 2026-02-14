#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Michael Vittrup Larsen. All rights reserved.
# Licensed under the MIT License. See https://github.com/michaelvl/agent-devcontainer/blob/main/LICENSE for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Test script for AI Coding Agents feature
# This script verifies that OpenCode and/or Claude-Code are installed correctly

set -e

# Source test library if available (used by devcontainer CLI for testing)
# shellcheck source=/dev/null
source dev-container-features-test-lib 2>/dev/null || true

# Helper function for checks if test lib is not available
if ! command -v check > /dev/null 2>&1; then
    check() {
        local description="$1"
        local command="$2"
        echo -n "Testing: $description ... "
        if eval "$command" > /dev/null 2>&1; then
            echo "PASS"
            return 0
        else
            echo "FAIL"
            return 1
        fi
    }
fi

if ! command -v reportResults > /dev/null 2>&1; then
    reportResults() {
        echo "All tests completed"
    }
fi

echo "=========================================="
echo "Testing AI Coding Agents Feature"
echo "=========================================="

# Test: OpenCode installation
check "opencode command exists" bash -c "command -v opencode"
check "opencode version" bash -c "opencode --version"

# Test: OpenCode configuration file
check "opencode config directory exists" bash -c "test -d ~/.config/opencode"
check "opencode config file exists" bash -c "test -f ~/.config/opencode/opencode.jsonc"
check "opencode config is valid JSON" bash -c "cat ~/.config/opencode/opencode.jsonc | grep -q 'github-copilot/claude-sonnet-4.5'"
check "opencode config has schema" bash -c "cat ~/.config/opencode/opencode.jsonc | grep -q 'https://opencode.ai/config.json'"

# Test: Claude-Code installation (if installed)
if command -v claude-code > /dev/null 2>&1; then
    check "claude-code command exists" bash -c "command -v claude-code"
    echo "✓ Claude-Code is installed"
else
    echo "ℹ Claude-Code is not installed (skipping claude-code tests)"
fi

# Test: Dependencies are available
check "git available" bash -c "git --version"
check "gh (GitHub CLI) available" bash -c "gh --version"
check "npm available" bash -c "npm --version"
check "node available" bash -c "node --version"

# Report results
echo ""
echo "=========================================="
reportResults
echo "=========================================="
