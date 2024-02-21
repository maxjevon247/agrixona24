// import 'account/account_new.dart';
import 'package:agrixona24/account/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugShowCheckedModeBanner:
  false;
  runApp(const MyApp());
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> getWelcomeScreenData() async {
  final DocumentReference docRef =
      firestore.collection("welcome").doc("welcome_screen");
  final DocumentSnapshot doc = await docRef.get();
  if (doc.exists) {
    return doc.data() as Map<String, dynamic>?;
  } else {
    print("No such document!");
    return null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        color: Colors.green.shade900,
        title: 'Agrixonia',
        home: FutureBuilder<Map<String, dynamic>?>(
          future: getWelcomeScreenData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else {
              if (snapshot.hasData) {
                final welcomeData = snapshot.data!;
                return WelcomeScreen(
                  text: welcomeData['text'] ?? '',
                  imageUrl: welcomeData['imgUrl'] ?? '',
                );
              } else {
                return const Center(
                    child: Text('Please check your network connection'));
              }
            }
          },
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final String text;
  final String imageUrl;

  WelcomeScreen({required this.text, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      // appBar: AppBar(
      //   title: Text('Welcome Screen'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Image.network(
              imageUrl,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  // MaterialPageRoute(builder: (context) => const LoginScreen())),
                  MaterialPageRoute(builder: (context) => LoginPage())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                side: const BorderSide(color: Colors.yellow, width: 2),
                // textStyle: const TextStyle(
                //     color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
              ),
              child: Text('Get Started',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ],
        ),
      ),
    );
  }
}

// /////////////////////
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Agrixona',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Agrixona'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade900,
//       // appBar: AppBar(
//       //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       //   title: Text(widget.title),
//       // ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Welcome to Agrixona',
//               style: TextStyle(fontSize: 28.0, color: Colors.white70),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => LoginScreen())),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 side: BorderSide(color: Colors.yellow, width: 2),
//                 // textStyle: const TextStyle(
//                 //     color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
//               ),
//               child: Text('Get Started',
//                   style: Theme.of(context).textTheme.headlineMedium),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
