const WebSocket = require('ws');

const ws = new WebSocket('ws://192.168.11.128:8080', ['ide']);

ws.on('open', function open() {
  console.log('Connected to server');
});

ws.on('message', function incoming(data) {
  console.log(data);
});

setInterval(function () {
  ws.send('Request data from server');
}, 1000);