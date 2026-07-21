function fn() {
  var env = karate.env || 'local';
  karate.log('karate.env system property was:', env);

  var config = {
    env: env,
    baseUrl: 'http://localhost:3000'
  };

  if (env === 'ci') {
    config.baseUrl = 'http://localhost:3000';
  }

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}
