import 'package:flutter/material.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Define the User model
class User {
  String email;
  String username;
  DateTime dateOfBirth;
  String profession;
  String specialization;

  User({
    required this.email,
    required this.username,
    required this.dateOfBirth,
    required this.profession,
    required this.specialization,
  });
}

// Multi-step registration screen widget
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  late User _user;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _registerUser() {
    // Register user with Firebase Authentication
    // Save additional user data to Firestore or Firebase Realtime Database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _currentStep < 3 ? _currentStep += 1 : _registerUser();
            });
          }
        },
        steps: [
          Step(
            title: Text('Step 1'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      // Validate email
                    },
                    onChanged: (value) {
                      // Update email in user object
                    },
                  ),
                  // Other form fields for step 1
                ],
              ),
            ),
          ),
          Step(
            title: Text('Step 2'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Form fields for step 2
                ],
              ),
            ),
          ),
          // Additional steps for username, date of birth, profession, specialization, etc.
        ],
      ),
    );
  }
}
