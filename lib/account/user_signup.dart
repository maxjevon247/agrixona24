// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class SignupPage extends StatefulWidget {
//   const SignupPage({Key? key}) : super(key: key);
//
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//
//   String email = '';
//   String username = '';
//   String password = '';
//   DateTime? dob;
//   String location = '';
//   String profession = '';
//   String specialization = '';
//
//   int currentPage = 0;
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: currentPage);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue.shade700,
//       body: Center(
//         child: Form(
//           key: _formKey,
//           child: PageView(
//             controller: _pageController,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               Center(
//                 child: Text(
//                   'Signup',
//                   style: TextStyle(
//                     fontSize: 24.0,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 80),
//               _buildStep1(),
//               _buildStep2(),
//               _buildStep3(),
//               _buildStep4(),
//               _buildStep5(),
//               _buildStep6(),
//               _buildStep7(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep1() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Email',
//             content: Column(
//               children: [
//                 TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   decoration:
//                       const InputDecoration(labelText: 'Enter your email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => email = value!,
//                 ),
//               ],
//             ),
//             onContinue: () => _next(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep2() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Username',
//             content: Column(
//               children: [
//                 TextFormField(
//                   decoration:
//                       const InputDecoration(labelText: 'Enter your username'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your username';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => username = value!,
//                 ),
//               ],
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep3() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Password',
//             content: Column(
//               children: [
//                 TextFormField(
//                   obscureText: true,
//                   decoration:
//                       const InputDecoration(labelText: 'Enter your password'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     final RegExp passwordRegex = RegExp(
//                       r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$',
//                     );
//                     if (!passwordRegex.hasMatch(value)) {
//                       return 'Password must contain at least\n '
//                           'one uppercase letter,\n '
//                           'one lowercase letter, \n '
//                           'one number,\n and one special character';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => password = value!,
//                 ),
//               ],
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep4() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Date of Birth',
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Select your date of birth:'),
//                 ElevatedButton(
//                   onPressed: () => _selectDate(context),
//                   child: const Text('Select Date'),
//                 ),
//                 if (dob != null) Text('Selected Date: $dob'),
//               ],
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep5() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Location',
//             content: Container(
//               width: 400,
//               height: 400,
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CountryPickerPlus(
//                     isRequired: true,
//                     countryLabel: "Country",
//                     countrySearchHintText: "Search Country",
//                     countryHintText: "Select Country",
//                     onCountrySelected: (value) {
//                       print(value);
//                     },
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextFormField(
//                     validator: (value) {
//                       return (value == null || value.isEmpty)
//                           ? 'Please enter your location'
//                           : null;
//                     },
//                     onSaved: (value) => location = value!,
//                     decoration: const InputDecoration(
//                       labelText: 'Location',
//                       prefixIcon: Icon(Icons.location_on),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep6() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 60),
//         child: Expanded(
//           child: StepPage(
//             title: 'Profession',
//             content: TextFormField(
//               decoration:
//                   const InputDecoration(labelText: 'Enter your profession'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your profession';
//                 }
//                 return null;
//               },
//               onSaved: (value) => profession = value!,
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStep7() {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 400,
//         padding: const EdgeInsets.all(20.0),
//         margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
//         child: Expanded(
//           child: StepPage(
//             title: 'Specialization',
//             content: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       labelText: 'Enter your specialization'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your specialization';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => specialization = value!,
//                 ),
//               ],
//             ),
//             onContinue: () => _next(),
//             onCancel: () => _previous(),
//           ),
//         ),
//       ),
//     );
//   }

//   void _next() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       if (_pageController.page != 6) {
//         // Check uniqueness of email and username
//         if (await _isEmailUnique(email) && await _isUsernameUnique(username)) {
//           setState(() {
//             currentPage += 1;
//           });
//           _pageController.animateToPage(currentPage,
//               duration: const Duration(milliseconds: 300), curve: Curves.ease);
//         } else {
//           // Handle duplicate email or username
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Email or username already exists.'),
//             ),
//           );
//         }
//       } else {
//         _register();
//       }
//     }
//   }
//
//   void _previous() {
//     if (currentPage > 0) {
//       setState(() {
//         currentPage--;
//       });
//       _pageController.animateToPage(currentPage,
//           duration: const Duration(milliseconds: 300), curve: Curves.ease);
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null && picked != dob) {
//       setState(() {
//         dob = picked;
//       });
//     }
//   }
//
//   Future<bool> _isEmailUnique(String email) async {
//     final querySnapshot = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();
//
//     return querySnapshot.docs.isEmpty;
//   }
//
//   Future<bool> _isUsernameUnique(String username) async {
//     final querySnapshot = await _firestore
//         .collection('users')
//         .where('username', isEqualTo: username)
//         .get();
//
//     return querySnapshot.docs.isEmpty;
//   }
//
//   Future<void> _register() async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       User? user = userCredential.user;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).set({
//           'email': email,
//           'username': username,
//           'dob': dob,
//           'location': location,
//           'profession': profession,
//           'specialization': specialization,
//         });
//         await user.sendEmailVerification();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Verification email sent. Please check your inbox.'),
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error during registration: $e'),
//         ),
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker_plus/country_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
// class StepPage extends StatelessWidget {
//   final String title;
//   final Widget content;
//   final VoidCallback? onContinue;
//   final VoidCallback? onCancel;
//
//   const StepPage({
//     Key? key,
//     required this.title,
//     required this.content,
//     this.onContinue,
//     this.onCancel,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         Expanded(child: content),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             if (onCancel != null)
//               TextButton(
//                 onPressed: onCancel,
//                 child: const Text('Back'),
//               ),
//             const SizedBox(width: 12),
//             ElevatedButton(
//               onPressed: onContinue,
//               child: const Text('Next'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String email = '';
  String username = '';
  String password = '';
  String passwordConfirmation = '';
  String location = '';
  DateTime? dob;
  String profession = '';
  String specialization = '';

  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1(),
            _buildStep2(),
            _buildStep3(),
            _buildStep4(),
            _buildStep5(),
            _buildStep6(),
            _buildStep7(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: StepPage(
          title: 'Email',
          content: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(labelText: 'Enter your email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
            ],
          ),
          onContinue: () => _next(),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: StepPage(
          title: 'Username',
          content: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Enter your username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => username = value!,
              ),
            ],
          ),
          onContinue: () => _next(),
          onCancel: () => _previous(),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: StepPage(
          title: 'Password',
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Enter your password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    final RegExp passwordRegex = RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$',
                    );
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must contain at least\n '
                          'one uppercase letter,\n '
                          'one lowercase letter, \n '
                          'one number,\n and one special character';
                    }
                    return null;
                  },
                  onSaved: (value) => password = value!,
                ),
                TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm your password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onSaved: (value) => passwordConfirmation = value!,
                ),
              ],
            ),
          ),
          onContinue: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _next();
            }
          },
          onCancel: () => _previous(),
        ),
      ),
    );
  }

  Widget _buildStep4() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: Expanded(
          child: StepPage(
            title: 'Date of Birth',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select your date of birth:'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
                if (dob != null) Text('Selected Date: $dob'),
              ],
            ),
            onContinue: () => _next(),
            onCancel: () => _previous(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep5() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: Expanded(
          child: StepPage(
            title: 'Location',
            content: Container(
              width: 400,
              height: 400,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(20.0),
                    child: CountryPickerPlus(
                      isRequired: true,
                      countryLabel: "Country",
                      countrySearchHintText: "Search Country",
                      countryHintText: "Select Country",
                      onCountrySelected: (value) {
                        print(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Please enter your location'
                          : null;
                    },
                    onSaved: (value) => location = value!,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                ],
              ),
            ),
            onContinue: () => _next(),
            onCancel: () => _previous(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep6() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 60),
        child: Expanded(
          child: StepPage(
            title: 'Profession',
            content: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Enter your profession'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your profession';
                }
                return null;
              },
              onSaved: (value) => profession = value!,
            ),
            onContinue: () => _next(),
            onCancel: () => _previous(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep7() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.fromLTRB(50, 55, 50, 20),
        child: Expanded(
          child: StepPage(
            title: 'Specialization',
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Enter your specialization'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your specialization';
                    }
                    return null;
                  },
                  onSaved: (value) => specialization = value!,
                ),
              ],
            ),
            onContinue: () => _next(),
            onCancel: () => _previous(),
          ),
        ),
      ),
    );
  }

  void _next() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_pageController.page != 6) {
        // Check uniqueness of email and username
        if (await _isEmailUnique(email) && await _isUsernameUnique(username)) {
          setState(() {
            currentPage += 1;
          });
          _pageController.animateToPage(currentPage,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        } else {
          // Handle duplicate email or username
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email or username already exists.'),
            ),
          );
        }
      } else {
        _register();
      }
    }
  }

  void _previous() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
      });
    }
  }

  Future<bool> _isEmailUnique(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<bool> _isUsernameUnique(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'dob': dob,
          // 'location': location,
          'profession': profession,
          'specialization': specialization,
        });
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent. Please check your inbox.'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during registration: $e'),
        ),
      );
    }
  }
}

class StepPage extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onContinue;
  final VoidCallback? onCancel;

  const StepPage({
    Key? key,
    required this.title,
    required this.content,
    this.onContinue,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onCancel != null)
              TextButton(
                onPressed: onCancel,
                child: const Text('Back'),
              ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onContinue,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
