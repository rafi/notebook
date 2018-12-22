var express = require('express');
var app = express();

process.on('SIGINT', function () {
  process.exit();
});

app.get('/', function (req, res) {
  res.send("Hello World!\n");
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
