import 'package:agrixona24/account/user_signup.dart';
import 'package:agrixona24/dashboard/dashboard.dart';
import 'package:agrixona24/dashboard/profile3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

var logger = Logger();

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white70,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      //color: Colors.white70,
                      child: TextFormField(
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please enter your email'
                              : null;
                        },
                        onSaved: (value) => _email = value!,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white70,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      //color: Colors.white70,
                      child: TextFormField(
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please enter your password'
                              : null;
                        },
                        onSaved: (value) => _password = value!,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          // filled: true,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            );
                            User? user = userCredential.user;
                            if (user != null) {
                              await user.sendEmailVerification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Verification email sent. Please check your inbox.')),
                              );
                              Navigator.pop(context);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'The password provided is too weak.')),
                              );
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'The account already exists for that email.')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'An error occurred during registration.')),
                            );
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  late String uid;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        // ),
        backgroundColor: Colors.green.shade800,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 20), // all(16.0),
            child: Center(
              child: Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.white70,
                      ),
                      //color: Colors.white70,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          // filled: true,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.white70,
                      ),
                      // color: Colors.white70,
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          filled: true,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          logger.i("User logged in successfully");
                          // Check if userCredential is not null
                          if (_auth.currentUser != null) {
                            // Navigate to dashboard upon successful login
                            // Navigator.pushReplacementNamed(context, '/profile');
                            //Navigator.pushReplacementNamed(context, '/dashboard');
                            // Navigator.pushReplacement(context,
                            //     ProfileScreen(uid: uid) as Route<Object?>);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildCcontext) =>
                                    const Dashboard(title: 'Agrixona'),
                              ),
                            );
                          } //else {
                          //   Navigator.pushReplacement(
                          //       context, const Marketplace() as Route<Object?>);
                          // }
                        } catch (e) {
                          logger.e("Error during login: $e");
                        }
                      },
                      child: const Text('Login'),
                    ),
                    // GestureDetector(
                    //   child: Text(
                    //     'No Account ?',
                    //     style: TextStyle(
                    //       fontSize: 24.0,
                    //       color: Colors.white70,
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        'No Account ?',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}
//
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ResponsiveWrapper(
              desktop: DesktopPage(),
              mobile: LoginPage(),
            ),
        '/dashboard': (context) => DashboardPage(),
        '/profile': (context) => const ProfileScreen(
              uid: '',
            ),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}

class DesktopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop Page'),
      ),
      body: Row(
        children: [
          Expanded(
            child: LoginPage(),
          ),
          Expanded(
            child: RegistrationPage(),
          ),
        ],
      ),
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;

  ResponsiveWrapper({required this.desktop, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
