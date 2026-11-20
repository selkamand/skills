#!/usr/bin/env bash
set -euo pipefail

REPO="selkamand/skills"
BRANCH="main"
DEST="${1:-${HOME}/.agents/skills}"
STAGING=$(mktemp -d "${TMPDIR:-/tmp}/skills-install.XXXXXXXX")
trap 'rm -rf "$STAGING"' EXIT

mkdir -p "$DEST"

curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" |
  tar -xz -C "$STAGING" --strip-components=1 \
    "${REPO##*/}-$BRANCH/skills"

shopt -s nullglob
for skill_file in "$STAGING"/skills/*/SKILL.md "$STAGING"/skills/*/*/SKILL.md; do
  cp -R "${skill_file%/SKILL.md}" "$DEST/"
done

echo "Skills installed to $DEST"
