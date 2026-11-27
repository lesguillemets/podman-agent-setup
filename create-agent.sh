#!/usr/bin/env bash
set -euo pipefail

podman create -it \
	--name agents-online \
	--user=0:0 \
	--security-opt=no-new-privileges \
	--umask=0007 \
	--memory=24g \
	--memory-swap=26g \
	--cpus=6 \
	--pids-limit=1024 \
	--volume /home/agents/container-shared/online:/workspace:ro,Z \
	--volume /home/agents/container-shared/online/repos:/workspace/repos:rw,Z \
	--volume /home/agents/container-shared/online/projects:/workspace/projects:rw,Z \
	--volume /home/agents/container-shared/online/reference:/workspace/reference:ro,Z \
	--volume /home/agents/container-secrets/online:/agent-secrets:rw,Z \
	--env CODEX_HOME=/agent-secrets/codex \
	--env CLAUDE_CONFIG_DIR=/agent-secrets/claude \
	--workdir /workspace \
	localhost/agent-base:fedora45 \
	/bin/bash
#
# --secret github-readonly,type=mount,mode=0400
