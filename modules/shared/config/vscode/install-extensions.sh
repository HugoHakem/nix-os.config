#!/usr/bin/env zsh

# exit if command fails
set -e

# retrieve arguments from the CLI
CODE_BIN="$1"
EXT_FILE="$2"

# check bin executable
if [ ! -x "$CODE_BIN" ]; then
  echo "VS Code CLI not found at: $CODE_BIN"
  exit 1
fi

# check file
if [ ! -f "$EXT_FILE" ]; then
  echo "Extensions file not found: $EXT_FILE"
  exit 1
fi

# Read extensions into an associative array
typeset -A installed_exts
while IFS= read -r ext; do
  installed_exts[$ext]=1
done < <("$CODE_BIN" --list-extensions)


# Process the extensions file
while IFS= read -r line || [[ -n "$line" ]]; do
  # Trim leading/trailing whitespace
  ext="${line#"${line%%[![:space:]]*}"}"
  ext="${ext%"${ext##*[![:space:]]}"}"

  # Skip comments and blank lines
  if [[ "$ext" == \#* || -z "$ext" ]]; then
    continue
  fi

  # Remove surrounding quotes if any
  ext="${ext%\"}"
  ext="${ext#\"}"

  # Install if not already installed
  if [[ -z "${installed_exts[$ext]:-}" ]]; then
    echo "Installing VS Code extension: $ext"
    "$CODE_BIN" --install-extension "$ext"
  else
    echo "VS Code extension already installed: $ext"
  fi
done < "$EXT_FILE"