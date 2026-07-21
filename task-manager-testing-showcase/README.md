# Task Manager API — Multi-Tool Test Automation Showcase

A single, runnable project that demonstrates hands-on experience across the full toolset in a QA/test-automation + DevOps job req:

- **Terraform Enterprise (TFE)** — infrastructure as code, remote/`cloud` backend, VCS-driven workspace, Sentinel policy-as-code
- **Postman / Newman** — functional API testing with chained requests and CI-ready reports
- **SoapUI** — REST project with assertions, Groovy scripting, and a built-in LoadTest
- **Karate** — BDD-style API test automation (no glue code)
- **JMeter** — load testing with correlation, assertions, and non-GUI CI execution
- **Artillery** — multi-phase load testing with custom JS processors
- **Gatling** — Scala DSL load testing with pass/fail assertions
- **Automation scripting** — shell scripts and a GitHub Actions pipeline that wire every tool above into one repeatable pipeline

Every tool is pointed at the same "system under test": a small Task Manager REST API (`/app`), so the whole repo is internally consistent and actually runs — this isn't just config snippets, it's a working pipeline you can execute end to end.

## Repository layout

```
app/            Express REST API used as the system under test (CRUD on /api/tasks)
postman/        Postman collection + environment (Newman-ready)
soapui/         SoapUI REST project (assertions, Groovy, LoadTest)
karate/         Karate feature files + Maven project
jmeter/         JMeter .jmx test plan
artillery/      Artillery load test config + custom processor
gatling/        Gatling Scala simulation + Maven project
terraform/      Terraform Enterprise workspace config, AWS ECS deployment, Sentinel policy
scripts/        Shell scripts to start the app and run every test suite locally
.github/workflows/ci.yml   GitHub Actions pipeline running all tools on every push
```

## Quick start (run everything locally)

Prerequisites: Node.js 18+, Java 17+ & Maven, [JMeter](https://jmeter.apache.org/download_jmeter.cgi) on your PATH, `npx` (ships with npm).

```bash
git clone <this-repo-url>
cd task-manager-testing-showcase
./scripts/run-all-tests.sh
```

This starts the API, then runs Newman, Karate, JMeter, Artillery, Gatling, and a Terraform fmt/validate check, in sequence, and stops the API when done. The exact same steps run automatically in CI — see `.github/workflows/ci.yml`.

## Run tools individually

| Tool | Command | Details |
|---|---|---|
| Postman/Newman | `newman run postman/TaskManagerAPI.postman_collection.json -e postman/TaskManagerAPI.postman_environment.json` | [postman/README.md](postman/README.md) |
| SoapUI | Import `soapui/TaskManagerAPI-soapui-project.xml` into SoapUI | [soapui/README.md](soapui/README.md) |
| Karate | `cd karate && mvn test` | [karate/README.md](karate/README.md) |
| JMeter | `jmeter -n -t jmeter/TaskManagerLoadTest.jmx -l results.jtl -e -o report` | [jmeter/README.md](jmeter/README.md) |
| Artillery | `artillery run artillery/artillery-config.yml` | [artillery/README.md](artillery/README.md) |
| Gatling | `cd gatling && mvn gatling:test` | [gatling/README.md](gatling/README.md) |
| Terraform Enterprise | `cd terraform && terraform init -backend=false && terraform validate` | [terraform/README.md](terraform/README.md) |

## What this demonstrates, tool by tool

- **TFE**: a `cloud` backend block wired for a VCS-driven workspace, an AWS ECS Fargate deployment for the app, and a Sentinel policy (`terraform/sentinel/enforce-mandatory-tags.sentinel`) that TFE enforces on every run.
- **Postman**: request chaining via collection variables, `pm.test` assertions, positive and negative paths, JUnit export for CI.
- **SoapUI**: REST resource modeling, JsonPath/HTTP-status assertions, a Groovy script assertion to capture and reuse a generated task ID, and a LoadTest test case.
- **Karate**: Gherkin scenarios, `Scenario Outline` for data-driven negative tests, JSON matching, and cross-request variable chaining — all without step-definition boilerplate.
- **JMeter**: Thread Group/Loop Controller load profile, `JSONPostProcessor` correlation, response assertions, and a non-GUI run that produces an HTML dashboard for CI artifacts.
- **Artillery**: multi-phase arrival-rate ramping, weighted scenarios, response capturing, and a custom processor function for extra hooks/metrics.
- **Gatling**: a Scala simulation with two injection profiles (`rampUsers` + `constantUsersPerSec`) and global pass/fail assertions on latency and success rate.
- **Automation scripting**: `scripts/run-all-tests.sh` orchestrates every tool locally; `.github/workflows/ci.yml` runs the identical pipeline on every push/PR and uploads all reports as build artifacts.

## Using this as a portfolio piece

To make this your own before pushing to GitHub:
1. Update `terraform/backend.tf` with your own TFE organization/hostname (or remove the `cloud` block if you don't have TFE access to demo against).
2. Swap the license/author info if desired.
3. Push to a new GitHub repo and enable GitHub Actions — the badge below will go green once CI runs.
4. Optionally add a GitHub Actions status badge to the top of this README once the repo is public:
   `![CI](https://github.com/<you>/<repo>/actions/workflows/ci.yml/badge.svg)`

## License

MIT — see [LICENSE](LICENSE).
