# SoapUI

Project file: `TaskManagerAPI-soapui-project.xml`

## Run in the SoapUI Desktop GUI
1. Open SoapUI (free/open-source edition).
2. File -> Import Project -> select `TaskManagerAPI-soapui-project.xml`.
3. Start the API (`npm start` in `/app`), then run the `Task CRUD TestSuite`.

## Run headlessly with `testrunner` (SoapUI CLI, used in CI)
```bash
testrunner.sh -s "Full CRUD Lifecycle" -r TaskManagerAPI-soapui-project.xml
```

Demonstrates: REST resource/method modeling, JsonPath + HTTP status assertions, Groovy script assertions to chain a generated `taskId` between steps, and a SoapUI LoadTest definition for basic performance checks.
