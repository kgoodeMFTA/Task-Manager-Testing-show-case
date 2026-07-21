# Artillery

Config: `artillery-config.yml` + `processor.js`

Three load phases (warm up -> ramp -> sustained peak) exercising two weighted scenarios: a full task lifecycle (create -> read -> update -> delete, with a custom processor hook and captured `taskId`) and a lightweight "browse tasks" read scenario.

## Run
```bash
npm install -g artillery
artillery run artillery/artillery-config.yml -o artillery/report.json
artillery report artillery/report.json   # generates HTML report
```

Demonstrates: multi-phase load profiles, weighted scenarios, response capturing/correlation (`capture` + `{{ taskId }}`), the `expect` plugin for assertions, and a custom processor function for extra hooks/metrics.
