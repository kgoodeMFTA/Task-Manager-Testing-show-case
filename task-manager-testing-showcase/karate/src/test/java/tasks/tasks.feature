Feature: Task Manager API - CRUD and validation

Background:
  * url baseUrl

Scenario: Health check responds OK
  Given path '/health'
  When method GET
  Then status 200
  And match response.status == 'ok'

Scenario: Full create -> read -> update -> delete lifecycle
  # Create
  Given path '/api/tasks'
  And request { title: 'Write karate tests', completed: false }
  When method POST
  Then status 201
  And match response.title == 'Write karate tests'
  And match response.completed == false
  * def taskId = response.id

  # Read
  Given path '/api/tasks/' + taskId
  When method GET
  Then status 200
  And match response.id == taskId

  # Task shows up in the full list
  Given path '/api/tasks'
  When method GET
  Then status 200
  And def created = karate.filter(response, function(t){ return t.id == taskId })
  And match created == '#[1]'

  # Update
  Given path '/api/tasks/' + taskId
  And request { completed: true }
  When method PUT
  Then status 200
  And match response.completed == true

  # Delete
  Given path '/api/tasks/' + taskId
  When method DELETE
  Then status 204

  # Confirm gone
  Given path '/api/tasks/' + taskId
  When method GET
  Then status 404

Scenario Outline: Creating a task without a title is rejected
  Given path '/api/tasks'
  And request <body>
  When method POST
  Then status 400
  And match response.error == '#present'

  Examples:
    | body                    |
    | { completed: false }    |
    | { completed: true }     |
    | {}                      |

Scenario: Fetching a task that does not exist returns 404
  Given path '/api/tasks/999999'
  When method GET
  Then status 404
