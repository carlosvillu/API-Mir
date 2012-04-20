require('coffee-script');
http = require('http');

var app = require('./app');

http.createServer(app).listen(3000);

console.log("Express server listening on port 3000");
