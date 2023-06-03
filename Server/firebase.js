const admin = require('firebase-admin')

// Initialize firebase admin SDK
admin.initializeApp({
  credential: admin.credential.cert('./db-pbl5-firebase-adminsdk-yl46f-402e7286d8.json'),
  storageBucket: 'gs://db-pbl5.appspot.com/'
})
// Cloud storage
const bucket = admin.storage().bucket()

module.exports = {
  bucket
}
