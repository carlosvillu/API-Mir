require('coffee-script');
http = require('http');

var app = require('./app');
var port = process.env.NODE_PORT || 3000;

http.createServer(app).listen(port);

console.log("Express server listening on port " + port);
