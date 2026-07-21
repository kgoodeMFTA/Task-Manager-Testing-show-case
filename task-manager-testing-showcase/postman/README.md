# Postman / Newman

Collection: `TaskManagerAPI.postman_collection.json`
Environment: `TaskManagerAPI.postman_environment.json`

## Run in the Postman GUI
1. Import both files into Postman.
2. Select the "Task Manager - Local" environment.
3. Run the collection with the Collection Runner (requests are ordered so `taskId` flows from Create -> Get -> Update -> Delete).

## Run headlessly with Newman (used in CI)
```bash
npm install -g newman
newman run postman/TaskManagerAPI.postman_collection.json \
  -e postman/TaskManagerAPI.postman_environment.json \
  --reporters cli,junit \
  --reporter-junit-export postman/newman-report.xml
```

Demonstrates: request chaining with variables, pre-request/test scripts, positive + negative path coverage, and CI-friendly JUnit reporting via Newman.
