package tasks;

import com.intuit.karate.junit5.Karate;

/**
 * Entry point Maven/Surefire uses to discover and run the Karate features
 * in this package. Run with: mvn test (optionally -Dkarate.env=ci)
 */
class TasksRunner {

    @Karate.Test
    Karate testTasks() {
        return Karate.run("tasks").relativeTo(getClass());
    }
}
