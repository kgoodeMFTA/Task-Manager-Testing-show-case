# Karate

BDD-style API automation, no step-definition glue code required.

## Run
```bash
cd karate
mvn test
# or, targeting the CI config block:
mvn test -Dkarate.env=ci
```

Requires the Task Manager API running locally on port 3000 (`npm start` inside `/app`).

Files:
- `src/test/java/tasks/tasks.feature` — CRUD lifecycle, negative-path validation (`Scenario Outline`), and 404 handling.
- `src/test/java/tasks/TasksRunner.java` — JUnit5 runner Maven/Surefire executes.
- `src/test/java/karate-config.js` — environment-driven base URL config.

Demonstrates: Gherkin scenario design, scenario outlines/examples for data-driven negative tests, JSON match assertions, variable chaining (`taskId`) across requests, and `karate.filter` for list assertions.
