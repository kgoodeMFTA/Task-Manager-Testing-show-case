# Gatling

Simulation: `src/test/scala/simulations/TaskManagerSimulation.scala`

Ramps up 20 users over 15s, then holds a constant 10 requests/sec for 30s, running the full task lifecycle each iteration. Includes global assertions (max response time < 2s, success rate > 95%) so the build fails automatically on regressions.

## Run
```bash
cd gatling
mvn gatling:test
```

HTML report is generated under `target/gatling/`.

Demonstrates: Scala DSL simulation design, injection profiles (`rampUsers` + `constantUsersPerSec`), JSON body checks/correlation (`saveAs`/`${taskId}`), and CI-friendly pass/fail assertions.
