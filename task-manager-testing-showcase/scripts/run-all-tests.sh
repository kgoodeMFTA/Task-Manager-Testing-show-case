#!/usr/bin/env bash
# Orchestrates the full multi-tool test suite locally, end to end:
# start the API -> Newman (Postman) -> Karate -> JMeter -> Artillery ->
# Gatling -> stop the API. Mirrors what .github/workflows/ci.yml runs.
#
# Requirements: node/npm, java + maven, jmeter on PATH, artillery (npx is fine).
set -euo pipefail
cd "$(dirname "$0")/.."

trap './scripts/stop-app.sh' EXIT

./scripts/start-app.sh

echo "=== Postman / Newman ==="
npx --yes newman run postman/TaskManagerAPI.postman_collection.json \
  -e postman/TaskManagerAPI.postman_environment.json --reporters cli

echo "=== Karate ==="
(cd karate && mvn -q test)

echo "=== JMeter (non-GUI) ==="
rm -rf jmeter/report jmeter/results.jtl
jmeter -n -t jmeter/TaskManagerLoadTest.jmx -l jmeter/results.jtl -e -o jmeter/report

echo "=== Artillery ==="
npx --yes artillery run artillery/artillery-config.yml

echo "=== Gatling ==="
(cd gatling && mvn -q gatling:test)

echo "=== Terraform (fmt + validate only, no apply) ==="
(cd terraform && terraform init -backend=false -input=false && terraform validate && terraform fmt -check)

echo "All test suites completed successfully."
