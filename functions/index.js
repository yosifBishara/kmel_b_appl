const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

async function shit() {
    const db = admin.firestore;
    const snapshot = await db.collection('appointments').where('date', '===', ).get();
    var today = Date.now();
    var todayDate = today.getDay().toString() + '/' + today.gotMonth().toString() + '/'
                    today.getFullYear().toString();
    var i = 0;
    for(i=0 ; i < snapshot.length ; i++){
       if(docs[i].get('date') === todayDate) {
            db.delete(docs[i].id);
       }
    }
}

//database fire store cleaning function
exports.wipingFunction = functions.pubsub.schedule('25 21 * * *')
                .timeZone('Asia/Tel_Aviv').onRun((context) => shit());

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
