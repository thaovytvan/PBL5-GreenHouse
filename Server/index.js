const { Storage } = require('@google-cloud/storage')

var admin = require("firebase-admin");

var serviceAccount = require("./db-pbl5-8aa8a17225ea.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://db-pbl5-default-rtdb.asia-southeast1.firebasedatabase.app"
});

// Initialize storage
const storage = new Storage({
  keyFilename: './db-pbl5-8aa8a17225ea.json',
})

const bucketName = 'db-pbl5.appspot.com'
const bucket = storage.bucket(bucketName)

// Sending the upload request
bucket.upload(
  './runs/detect/predict/image_1682411726672.jpg',
  {
    destination: 'someFolderInBucket/image_1682411726672.jpg',
  },
  function (err, file) {
    if (err) {
      console.error(`Error uploading image image_to_upload.jpg: ${err}`)
    } else {
      console.log(`Image image_to_upload.jpg uploaded to ${bucketName}.`)
    }
  }
)