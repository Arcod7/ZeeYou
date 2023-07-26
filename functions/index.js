const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("chat/{messageId}")
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic("chat", {
      notification: {
        title: snapshot.data()["username"],
        body: snapshot.data()["text"],
      },
    });
  });
