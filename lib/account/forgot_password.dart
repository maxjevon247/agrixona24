import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phoneNumber = value!,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('A password reset link has been sent to your email.')),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No user found for that email.')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred while sending the password reset link.')),
                      );
                    }
                  }
                },
                child: const Text('Reset Password via Email'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: _phoneNumber,
                        verificationCompleted: (PhoneAuthCredential credential) async {
                          await FirebaseAuth.instance.signInWithCredential(credential);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signed in successfully.')),
                          );
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Verification failed.')),
                          );
                        },
                        codeSent: (String verificationId, [int? resendToken]) async {
                          String smsCode = '';
                          // Show the verification code dialog here.
                          // ...
                          await FirebaseAuth.instance.signInWithCredential(
                            PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: smsCode,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signed in successfully.')),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          // Handle the timeout here.
                          // ...
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred while sending the verification code.')),
                      );
                    }
                  }
                },
                child: const Text('Reset Password via Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}