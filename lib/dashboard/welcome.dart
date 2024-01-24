// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Future<void> getWelcomeScreenData() async {
//   final DocumentReference docRef = firestore.collection("welcome").doc("welcome_screen");
//   final DocumentSnapshot doc = await docRef.get();
//   if (doc.exists) {
//     final welcomeScreenData = doc.data();
//     print("Welcome screen text: ${welcomeScreenData['text']}");
//     print("Welcome screen image URL: ${welcomeScreenData['imageUrl']}");
//   } else {
//     print("No such document!");
//   }
// }

// class WelcomeScreen extends StatelessWidget {
//   final String text;
//   final String imageUrl;

//   WelcomeScreen({required this.text, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text(text),
//           Image.network(imageUrl),
//         ],
//       ),
//     );
//   }
// }