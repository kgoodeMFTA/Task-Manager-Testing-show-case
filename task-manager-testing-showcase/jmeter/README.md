# JMeter

Test plan: `TaskManagerLoadTest.jmx`

Simulates 20 concurrent users, each looping 10 times through: list tasks -> create task -> get created task -> delete task, with response-code assertions and a JSON extractor (`taskId`) chaining requests together.

## Run in the GUI
```bash
jmeter -t jmeter/TaskManagerLoadTest.jmx
```

## Run headlessly (used in CI)
```bash
jmeter -n -t jmeter/TaskManagerLoadTest.jmx -l jmeter/results.jtl -e -o jmeter/report
```

Demonstrates: Thread Group / Loop Controller configuration, HTTP Request Defaults + Header Manager, `JSONPostProcessor` correlation between requests, Response Assertions, and non-GUI execution with an HTML dashboard report for CI artifacts.
