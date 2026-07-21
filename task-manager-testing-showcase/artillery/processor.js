// Custom Artillery processor function referenced from artillery-config.yml.
// Demonstrates how to hook custom JS logic (logging, extra assertions,
// metrics emission) into an Artillery load test.

module.exports = {
  logCompletion,
};

function logCompletion(context, events, done) {
  events.emit('counter', 'tasks.updated', 1);
  return done();
}
