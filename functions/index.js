const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("chata/{messageId}")
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic("chata", {
      notification: {
        title: snapshot.data()["username"],
        body: snapshot.data()["text"],
      },
    });
  });
