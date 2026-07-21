#!/usr/bin/env bash
# Starts the Task Manager API in the background and waits for /health to
# respond before returning. Used by run-all-tests.sh and CI.
set -euo pipefail

cd "$(dirname "$0")/../app"
npm install --no-fund --no-audit
nohup npm start > ../app.log 2>&1 &
echo $! > ../app.pid

echo "Waiting for Task Manager API to become healthy..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:3000/health > /dev/null; then
    echo "API is up."
    exit 0
  fi
  sleep 1
done

echo "API did not become healthy in time. Log output:"
cat ../app.log
exit 1
