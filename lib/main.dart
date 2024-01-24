import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'account.dart';

// import 'account/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> getWelcomeScreenData() async {
  final DocumentReference docRef =
      firestore.collection("welcome").doc("welcome_screen");
  final DocumentSnapshot doc = await docRef.get();
  if (doc.exists) {
    final Map<String, dynamic>? welcomeScreenData =
        doc.data() as Map<String, dynamic>?;
    print("Welcome screen text: ${welcomeScreenData?['text']}");
    print("Welcome screen image URL: ${welcomeScreenData?['imageUrl']}");
  } else {
    print("No such document!");
  }
}

class WelcomeScreen extends StatelessWidget {
  final String text;
  final String imageUrl;

  WelcomeScreen({required this.text, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(text),
          Image.network(imageUrl),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrixona',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Agrixona'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Agrixona',
              style: TextStyle(fontSize: 28.0, color: Colors.white70),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: Text(
                'Get Started',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
