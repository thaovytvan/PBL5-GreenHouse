const WebSocket = require('ws');
const path = require('path');
const fs = require('fs');
const uploadDir = path.join(__dirname, 'runs');

// Tạo một kết nối Websocket tới server

const ws = new WebSocket('ws://172.21.1.48:8080');
// Khi nhận được dữ liệu từ server
ws.on('message', (data) => {

    if (data.byteLength > 1000) {
        latestImage = data;
        const fs = require('fs');
        const filename = `image_${new Date().getTime()}.jpg`;

        const filepath = path.join(uploadDir, filename);
        fs.writeFile(filepath, data, function (err) {
            if (err) {
                console.error(`Lỗi khi lưu ảnh: ${err}`);
            } else {
                console.log(`Ảnh đã được lưu tại đường dẫn ${filepath}`);
            }
        });
    }
    else {
        const messageObj = JSON.parse(data);
        console.log(messageObj)
    }

});
setInterval(function () {
    ws.send('Request data from server');
}, 1000);