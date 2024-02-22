import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class JobPostingPage extends StatefulWidget {
  @override
  _JobPostingPageState createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  File? _image;

  String _jobTitle = '';
  String _jobDescription = '';
  String _targetAudience = '  ';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      // Redirect to a login page or display an error message
      return Scaffold(
        appBar: AppBar(title: Text('Submit Job')),
        body: Center(
          child: Text('Please log in to post a job.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Submit Job')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!, height: 150, width: 150),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an image'),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Job Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
              onSaved: (value) => _jobTitle = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Job Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a job description';
                }
                return null;
              },
              onSaved: (value) => _jobDescription = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Target Audience'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a target audience';
                }
                return null;
              },
              onSaved: (value) => _targetAudience = value!,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitJob,
              child: Text('Submit Job'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Upload the image to Firebase Storage
      final imageName = DateTime.now().toString();
      final reference = FirebaseStorage.instance.ref().child('jobs/$imageName');
      final uploadTask = reference.putFile(_image!);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      // Save the job to Firestore
      final product = {
        'title': _jobTitle,
        'description': _jobDescription,
        'targetAudience': _targetAudience,
        'imageUrl': imageUrl,
        'userId': _auth.currentUser!.uid,
        'approved': false,
      };
      await _firestore.collection('jobs').add(product);

      setState(() {
        _isLoading = false;
      });

      // Clear the form and show a success message
      _formKey.currentState!.reset();
      _image = null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job submitted successfully!')));
    }
  }
}