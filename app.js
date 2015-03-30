var express = require('express');
var app = express();
var path = require('path');

app.use(express.static(path.join(__dirname, 'public'))); //  "public" off of current is root

app.get('/', function (req, res) {
  res.sendFile('index.html', {root: __dirname });
});

var port = process.env.PORT || 3000;
var server = app.listen(port, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('Example app listening at http://%s:%s', host, port);
});