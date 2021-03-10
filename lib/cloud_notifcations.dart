// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:io';
//
//
// class MessagingManager {
//   MessagingManager._();
//   // String _uid;
//   factory ngManager (String uid) => _instance;
//   static final MessagingManager _instance = MessagingManager._();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   bool _initialized = false;
//   StreamSubscription iosSubscription;
//
//   _saveDeviceToken(String uid) async {
//     // Get the current user
//     // String uid = 'jeffd23';
//     // FirebaseUser user = await _auth.currentUser();
//
//     // Get the token for this device
//     String fcmToken = await _firebaseMessaging.getToken();
//
//     // Save it to Firestore
//     if (fcmToken != null) {
//       var tokens = _db
//           .collection('appointments')
//           .doc(uid);
//
//       await tokens.set({
//         'token': fcmToken,
//         // 'createdAt': FieldValue.serverTimestamp(), // optional
//         // 'platform': Platform.operatingSystem // optional
//       });
//     }
//   }
//
//   Future<void> init(String uid) async {
//     if(!_initialized) {
//       if (Platform.isIOS) {
//         iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data) {
//           print(data);
//           _saveDeviceToken(uid);
//         });
//
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure();
//
//       String token = await _firebaseMessaging.getToken();
//       print(token);
//
//       _initialized = true;
//     }
//   }
//
//
// }