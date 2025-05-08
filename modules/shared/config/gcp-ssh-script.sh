#!/usr/bin/env bash
# Usage: gcloud_proxy.sh <vm_name> <project_name> <zone>

set -euo pipefail

VM_NAME="$1"
PROJECT_NAME="$2"
ZONE="$3"
PORT="$4"

# Retrieve SDK root and Python location from gcloud info
read -r SDK_ROOT PYTHON_BIN < <(gcloud info --format='value(installation.sdk_root,basic.python_location)')

# Execute the gcloud command
exec "$PYTHON_BIN" -S -W ignore "$SDK_ROOT/lib/gcloud.py" compute start-iap-tunnel "$VM_NAME" "$PORT" \
  --listen-on-stdin \
  --project="$PROJECT_NAME" \
  --zone="$ZONE" \
  --verbosity=warning
