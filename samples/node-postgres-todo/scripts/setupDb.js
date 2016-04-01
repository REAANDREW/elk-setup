var config = require('../lib/config');
var pg = require('pg');

var client = new pg.Client(config.connectionString);
client.connect();
client.query('CREATE TABLE items(id SERIAL PRIMARY KEY, text VARCHAR(40) not null, complete BOOLEAN)', function(err){
  client.end();
});
