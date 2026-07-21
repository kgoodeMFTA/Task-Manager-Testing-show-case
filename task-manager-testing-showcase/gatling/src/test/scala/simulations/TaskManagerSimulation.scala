package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

/**
 * Load simulation for the Task Manager API.
 * Run with: mvn gatling:test  (from the /gatling directory)
 */
class TaskManagerSimulation extends Simulation {

  private val httpProtocol = http
    .baseUrl("http://localhost:3000")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")

  private val lifecycleScenario = scenario("Task Lifecycle")
    .exec(
      http("Health Check")
        .get("/health")
        .check(status.is(200))
    )
    .pause(500.milliseconds)
    .exec(
      http("List Tasks")
        .get("/api/tasks")
        .check(status.is(200))
    )
    .pause(500.milliseconds)
    .exec(
      http("Create Task")
        .post("/api/tasks")
        .body(StringBody("""{"title":"Gatling load test task","completed":false}"""))
        .check(status.is(201))
        .check(jsonPath("$.id").saveAs("taskId"))
    )
    .pause(500.milliseconds)
    .exec(
      http("Get Task By Id")
        .get("/api/tasks/${taskId}")
        .check(status.is(200))
    )
    .exec(
      http("Update Task")
        .put("/api/tasks/${taskId}")
        .body(StringBody("""{"completed":true}"""))
        .check(status.is(200))
        .check(jsonPath("$.completed").is("true"))
    )
    .exec(
      http("Delete Task")
        .delete("/api/tasks/${taskId}")
        .check(status.is(204))
    )

  setUp(
    lifecycleScenario
      .inject(
        rampUsers(20).during(15.seconds),
        constantUsersPerSec(10).during(30.seconds)
      )
  ).protocols(httpProtocol)
    .assertions(
      global.responseTime.max.lt(2000),
      global.successfulRequests.percent.gt(95)
    )
}
