import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  File _image = File('assets/images/agrixona.png');

  String _productName = '';
  String _productDescription = '';
  List<String> _targetAudience = [];

  bool _isLoading = false;

 final List<String> _targetAudienceOptions = [
    'Farmers',
    'Gardeners',
    'Agricultural Companies',
    'Government Agencies',
    'Educational Institutions',
    'Non-profit Organizations',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Upload the image to Firebase Storage
      final imageName = DateTime.now().toString();
      final reference = FirebaseStorage.instance.ref().child('products/$imageName');
      final uploadTask = reference.putFile(_image);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      // Save the product to Firestore
      final user = _auth.currentUser;
      final product = {
        'name': _productName,
        'description': _productDescription,
        'targetAudience': _targetAudience,
        'imageUrl': imageUrl,
        'userId': user!.uid,
        'approved': false,
      };
      await _firestore.collection('products').add(product);

      setState(() {
        _isLoading = false;
      });

      // Clear the form and show a success message
      _formKey.currentState!.reset();
      _image;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product submitted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image, height: 150, width: 150),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick an image'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
              onSaved: (value) => _productName = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product description';
                }
                return null;
              },
              onSaved: (value) => _productDescription = value!,
            ),
            const SizedBox(height: 16),
            TargetAudienceField(targetAudience: _targetAudience, targetAudienceOptions: _targetAudienceOptions),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitProduct,
              child: const Text('Submit Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class TargetAudienceField extends StatefulWidget {
  final List<String> targetAudience;
  final List<String> targetAudienceOptions;

  const TargetAudienceField({
    required this.targetAudience,
    required this.targetAudienceOptions,
  });

  @override
  _TargetAudienceFieldState createState() => _TargetAudienceFieldState();
}

class _TargetAudienceFieldState extends State<TargetAudienceField> {
  List<String> _selectedTargetAudience = [];

  @override
  void initState() {
    super.initState();
    _selectedTargetAudience = widget.targetAudience;
  }

  void _toggleTargetAudience(String value) {
    setState(() {
      if (_selectedTargetAudience.contains(value)) {
        _selectedTargetAudience.remove(value);
      } else {
        _selectedTargetAudience.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.targetAudienceOptions
          .map((option) => Row(
                children: [
                  Checkbox(
                    value: _selectedTargetAudience.contains(option),
                    onChanged: (value) => _toggleTargetAudience(option),
                  ),
                  Text(option),
                ],
              ))
          .toList(),
    );
  }
}




// class TargetAudienceField extends StatefulWidget {
//   final List<String> targetAudience;

//   const TargetAudienceField({required this.targetAudience});

//   @override
//   _TargetAudienceFieldState createState() => _TargetAudienceFieldState();
// }

// class _TargetAudienceFieldState extends State<TargetAudienceField> {
//   List<String> _selectedTargetAudience = [];

//   @override
//   void initState() {
//     super.initState();
//     _selectedTargetAudience = widget.targetAudience;
//   }

//   void _toggleTargetAudience(String value) {
//     setState(() {
//       if (_selectedTargetAudience.contains(value)) {
//         _selectedTargetAudience.remove(value);
//       } else {
//         _selectedTargetAudience.add(value);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: _targetAudienceOptions
//           .map((option) => Row(
//                 children: [
//                   Checkbox(
//                     value: _selectedTargetAudience.contains(option),
//                     onChanged: (value) => _toggleTargetAudience(option),
//                   ),
//                   Text(option),
//                 ],
//               ))
//           .toList(),
//     );
//   }
// }