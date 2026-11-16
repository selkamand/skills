#!/usr/bin/env bash
set -euo pipefail

REPO="selkamand/skills"
BRANCH="main"
DEST="${1:-${HOME}/.agents/skills}"

mkdir -p "$DEST"

curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" |
  tar -xz -C "$DEST" --strip-components=2 \
    "${REPO##*/}-$BRANCH/skills"

echo "Skills installed to $DEST"
