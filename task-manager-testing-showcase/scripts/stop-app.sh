#!/usr/bin/env bash
# Stops the Task Manager API previously started by start-app.sh.
set -euo pipefail

cd "$(dirname "$0")/.."
if [ -f app.pid ]; then
  kill "$(cat app.pid)" 2>/dev/null || true
  rm -f app.pid
  echo "Stopped Task Manager API."
else
  echo "No app.pid found, nothing to stop."
fi
