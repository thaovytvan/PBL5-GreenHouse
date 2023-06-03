const { Storage } = require('@google-cloud/storage')
require('firebase/storage');

var admin = require("firebase-admin");

var serviceAccount = require("./greenhouseapp-822f1-firebase-adminsdk-e4s9m-69ed5a9d22.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://greenhouseapp-822f1-default-rtdb.firebaseio.com"
});

const db = admin.database();

// Initialize storage
const storage = new Storage({
  keyFilename: './greenhouseapp-822f1-firebase-adminsdk-e4s9m-69ed5a9d22.json',
})

const bucketName = 'greenhouseapp-822f1.appspot.com'
const bucket = storage.bucket(bucketName)


const path = require('path');
const uploadDir = path.join(__dirname, 'py/test');
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });
const { spawn } = require('child_process');
const fs = require('fs')
const express = require('express');
const bodyParser = require('body-parser');
const { title } = require('process');
const { Console } = require('console');
const { url } = require('inspector');
const jsonParser = bodyParser.json();
const app = express();
app.use(bodyParser.urlencoded({ extended: false }))
app.get('/', function (req, res) {
  res.send('Hello, world!');
});

var bd = 0;
var auto = 0;
var mt = 0;
var fan = 0;
var a = 0;
var b = 0;
var c = 0;
var isMoto = false;
var isbongden = false;
var isquat = false;
var _mt = 0;
var _bd = 0;

function create_db_battat(){
  const ref = db.ref('history_device_control');

  // Lấy timestamp hiện tại
  const timestamp = Math.floor(Date.now() / 1000);

  const newData = {
    time: Date(),
    bongden: bd,
    moto: mt,
    tudong: auto
  };
  ref.child(timestamp.toString()).set(newData)
}

// function getTime() {
//   const now = new Date();
//   const hours = now.getHours();
//   const minutes = now.getMinutes();
//   const seconds = now.getSeconds();
//   const day = now.getDate();
//   const month = now.getMonth() + 1; // tháng bắt đầu từ 0 nên cần +1
//   const year = now.getFullYear();

//   const formattedTime = `${hours}:${minutes}:${seconds} ${day}/${month}/${year}`;
//   return formattedTime;
// }


//api bật tắt 
app.post('/send-moto', jsonParser, function (req, res) {
  var title = req.body.title
  if (title == 'LIGHTS') {
    bd = req.body.data
    if (bd == 1) {
      console.log("Bật bóng đèn")
      create_db_battat()
    } else if (bd == 0) {
      console.log("Tắt bóng đèn")
      create_db_battat()
    }
  } else if (title == 'WATER PUMP') {
    mt = req.body.data
    if (mt == 1) {
      console.log("Bật Mô tơ nước")
      create_db_battat()
    } else if (mt == 0) {
      console.log("Tắt Mô tơ nước")
      create_db_battat()
    }
  } 
  else if (title == 'FAN') {
    fan = req.body.data
    if (fan == 1) {
      console.log("Bật Quạt")
      create_db_battat()
    } else if (fan == 0) {
      console.log("Tắt Quạt")
      create_db_battat()
    }
  }
  else {
    auto = req.body.data
    if (auto == 1) {
      console.log("Bật Tự Động")
      create_db_battat()
    } else if (auto == 0) {
      console.log("Tắt Tự Động")
      create_db_battat()
    }
  }
  console.log(mt)
  res.send(`Server received data: ${mt}`);
});

//api bật tắt bóng đèn
// app.post('/send-bd', jsonParser, function (req, res) {
//   bd = req.body.bd;
//   console.log('Received bd:', bd);
//   res.send(`Server received data: ${bd}`);
// });
// Khởi động server
app.listen(3000, function () {
  console.log('Server listening on port 3000');
});

connections = []
wss.on('connection', function connection(ws) {
  console.log('Client connected');
  console.log(ws.protocol)
  connections.push(ws);
  const clientIpAddress = ws._socket.remoteAddress;
  // console.log(clientIpAddress)
  // console.log()
  ws.on('message', function incoming(data) {
    if (ws.protocol === 'arduino') {
      const messageOb = JSON.parse(data);
      a = messageOb.temperature
      b = messageOb.humidity
      c = messageOb.anaValue

      if(messageOb.sendServer == 1){
        isMoto = true;
        
      }else{
        isMoto = false;
      }
      if(messageOb.sendServerbd == 1){
        isbongden = true;
        
      }else{
        isbongden = false;
        
      }
      if(messageOb.sendServerq == 1){
        isquat = true;
        
      }else{
        isquat = false;
        
      }
      // console.log(messageOb.sendServerbd)
      console.log(isMoto)
      console.log(isbongden)
      const messageObj = {
        temperature: a,
        humidity: b, 
        anaValue: c,
        moto: isMoto,
        bongden: isbongden,
        fan : isquat
      }
      // console.log(messageOb.sendServer)
    
      const response = {
        moto: mt,
        bongden: bd,
        tudong: auto,
        quat: fan
      };

      // console.log(auto)
      if(auto == 1){
        mt = messageOb.sendServer;
        bd = messageOb.sendServerbd;
        console.log(mt,_mt,bd,_bd)
        if(mt!= _mt || bd!=_bd) {
          create_db_battat()
          console.log("lich")
          _mt = mt;
          _bd = bd;
        }
      }
      
      ws.send(JSON.stringify(response));
      connections.forEach(function each(client) {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify(messageObj));
        }
      });

    } else if (ws.protocol === 'camesp32') {
      latestImage = data;
      const fs = require('fs');
const filename = `image_${new Date().getTime()}.jpg`;

      const filepath = path.join(uploadDir, filename);
      fs.writeFile(filepath, data, function (err) {
        if (err) {
          console.error(`Lỗi khi lưu ảnh: ${err}`);
        } else {
          console.log(`Image saved to ${data.length}`);
          const pythonProcess = spawn('py', ['./py/main.py', filepath]);
          pythonProcess.stdout.on('data', (data) => {
            console.log(`stdout: ${data}`);
            if(data > 0)
            {
              const imagePath = `./runs/detect/predict/${filename}`;
              console.log(imagePath)

              // Gửi tin nhắn đến một thiết bị
              const message = {
                notification: {
                  title: "Thông báo sâu bệnh",
                  body: "Đã phát hiện sâu bệnh trong vườn của bạn"
                },
                token: "eBKDmE0KQQevCdHZH34mRM:APA91bHPQZimtCTA-zRrlrTO58hQeZ_nucRjjjveu415__EbEODZIVhgiYbTAHRTL5Y99dyuYzOuKllQst-9OZvGcN_qv0vwPNDw-X1eG8hQoGZhioT_yMpBJ78TodPxsCY5-LXrbKPf"
              };
              admin.messaging().send(message)
                .then((response) => {
                  console.log("Tin nhắn đã được gửi: ", response);
                })
                .catch((error) => {
                  console.log("Lỗi khi gửi tin nhắn: ", error);
                });

              //upload ảnh lên firebase
              bucket.upload(
                `./runs/detect/predict/${filename}`,
                {
                  destination: `ImagesFolder/${filename}`,
                },
                function (err, file) {
                  if (err) {
                    console.error(`Error uploading image image_to_upload.jpg: ${err}`)
                  } else {
                    console.log(`Image image_to_upload.jpg uploaded to ${bucketName}.`)
                    // Lấy URL của file đã upload
                    file.getSignedUrl({
                      action: 'read',
                      expires: '03-17-2025' // Thời gian URL hết hạn
                    }, function(err, url) {
                      if (err) {
                        console.error(`Error getting signed URL for file: ${err}`)
                      } else {
                        console.log(`Signed URL for file is: ${url}`)

                        //lưu lịch sử sâu bọ vào db
                        const ref = db.ref('history_saubo');

                        // Lấy timestamp hiện tại
                        const timestamp = Math.floor(Date.now() / 1000);

                        const newData = {
                          time: Date(),
                          image: url
                        };
                        ref.child(timestamp.toString()).set(newData)
                      }
                    })
                  }
                }
              )
            }
          });
          pythonProcess.stderr.on('data', (data) => {
            console.error(`stderr: ${data}`);
          });
        }
          const path = './runs/detect/predict';

          try {
            fs.rmdirSync(path, { recursive: true });
            console.log(path)
            console.log(`Đã xoá thư mục ${path} thành công.`);
          } catch (err) {
            console.error(`Lỗi xoá thư mục ${path}: ${err}`);
          }
      });


    } 
  });

  ws.on('close', function close() {
    console.log('Client disconnected');
    // Tìm index của kết nối trong mảng connections
    const index = connections.indexOf(ws);
    // Nếu tìm thấy, loại bỏ phần tử đó khỏi mảng
    if (index !== -1) {
      connections.splice(index, 1);
    }
  });
  // console.log(connections.length)
});