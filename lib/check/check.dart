// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   File _profilePic;
//   File _coverPic;
//   File _video;
//   bool _uploading = false;
//   String _profilePicUrl;
//   String _coverPicUrl;
//   List<Post> _posts = [];
//   bool _showContact = true;
//   bool _showEducation = true;
//   bool _showEmployment = true;
//   bool _showSkills = true;
//   bool _showSpecialization = true;
//
//   Future<void> getMedia(ImageSource source, Function(File) setMedia) async {
//     var media = await ImagePicker.pickImage(source: source);
//     setState(() {
//       setMedia(media);
//     });
//   }
//
//   Future<void> uploadMedia(File media, String folderName, Function(String) setUrl) async {
//     try {
//       setState(() {
//         _uploading = true;
//       });
//
//       Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(folderName);
//       UploadTask uploadTask = firebaseStorageRef.child(media.path).putFile(File(media.path));
//
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//       String url = await taskSnapshot.ref.getDownloadURL();
//
//       setState(() {
//         _uploading = false;
//         setUrl(url);
//       });
//     } catch (error) {
//       print('Error during media upload: $error');
//       setState(() {
//         _uploading = false;
//       });
//       // Handle the error as needed
//     }
//   }
//
//   Future<void> getPosts() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();
//     setState(() {
//       _posts = querySnapshot.docs.map((doc) => Post.fromDocument(doc)).toList().reversed.toList();
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getPosts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             // Profile Picture
//             Center(
//               child: Stack(
//                 children: <Widget>[
//                   _profilePicUrl != null
//                       ? CircleAvatar(
//                           backgroundImage: NetworkImage(_profilePicUrl),
//                           radius: 50,
//                         )
//                       : const CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/default_profile.png'),
//                           radius: 50,
//                         ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.blue,
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.camera_alt,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => getMedia(ImageSource.gallery, (media) => _profilePic = media),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Cover Picture
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 image: _coverPicUrl != null
//                     ? DecorationImage(
//                         image: NetworkImage(_coverPicUrl),
//                         fit: BoxFit.cover,
//                       )
//                     : const DecorationImage(
//                         image: AssetImage('assets/images/default_cover.png'),
//                         fit: BoxFit.cover,
//                       ),
//               ),
//               child: Stack(
//                 children: <Widget>[
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.blue,
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.camera_alt,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => getMedia(ImageSource.gallery, (media) => _coverPic = media),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Profile Settings
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Profile Settings'),
//               onTap: () {
//                 // Navigate to Profile Settings Screen
//               },
//             ),
//             // Friends List
//             ListTile(
//               leading: const Icon(Icons.group),
//               title: const Text('Friends'),
//               onTap: () {
//                 // Navigate to Friends List Screen
//               },
//             ),
//             // Image and Video Upload
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 // Image Upload
//                 ElevatedButton(
//                   onPressed: _uploading ? null : () => uploadMedia(_profilePic, 'profilePics', (url) => _profilePicUrl = url),
//                   child: const Text('Upload Image'),
//                 ),
//                 // Video Upload
//                 ElevatedButton(
//                   onPressed: _uploading ? null : () => uploadMedia(_video, 'videos', (url) => _videoUrl = url),
//                   child: const Text('Upload Video'),
//                 ),
//               ],
//             ),
//             // Uploading Progress
//             _uploading ? const LinearProgressIndicator() : Container(),
//             // Profile Information
//             // ... (rest of your profile information widgets)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Post {
//   // Add your Post class definition here
// }
