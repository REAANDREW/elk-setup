var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var moment = require('moment');
var routes = require('./routes/index');

var client = {
  bulk : function(data, callback){
    data.body.forEach(function(item){
      logger.info(item);
    });
    callback();
  },
  ping : function(config, callback){
    callback();
  }
};

var reporter   = require('measured-elasticsearch').forClient(client);
var measured   = require('measured');
var collection = measured.createCollection();

reporter.addCollection(collection);
reporter.start(5, measured.units.SECONDS);

var app = express();

var winston = require('winston');
var onFinished = require('on-finished')

var logger = new (winston.Logger)({
  transports: [
    new (winston.transports.File)({ filename: '/var/log/node-postgres-todo.application.log' })
  ]
});

app.use(function(req,res,next){
  var startTime = moment();
  
  onFinished(res, function (err, res) {
    collection.meter('requestsPerSecond').mark();
    var duration = moment.duration(moment().diff(startTime));
    var milliseconds = duration.asMilliseconds();
    collection.histogram('responseTime').update(milliseconds);
  });

  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/', routes);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

module.exports = app;
