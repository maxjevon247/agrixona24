import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class Post {
  String content;
  String userId;
  List<String> comments;
  List<String> likes;
  List<String> shares;

  Post({
    required this.content,
    required this.userId,
    required this.comments,
    required this.likes,
    required this.shares,
  });
}

class Comment {
  String userId;
  String content;

  Comment({required this.userId, required this.content});
}

class Message {
  String senderId;
  String receiverId;
  String content;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
  });
}

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userId;
  late File _imageFile;
  late File _videoFile;
  late VideoPlayerController _controller;
  late String _uploadedImageURL;
  late String _uploadedVideoURL;
  bool _showContact = false;
  bool _showEducation = false;
  bool _showEmployment = false;
  bool _showSkills = false;
  bool _showSpecialization = false;
  List<String> _posts = [];

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(_uploadedVideoURL));

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _userId = user.uid;
        });
        _fetchUserData();
      }
    });
  }

  Future<void> _fetchUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .snapshots()
        .listen((data) {
      if (data.exists) {
        setState(() {
          _showContact = data['contact'];
          _showEducation = data['education'];
          _showEmployment = data['employment'];
          _showSkills = data['skills'];
          _showSpecialization = data['specialization'];
          _posts = List<String>.from(data['posts']);
        });
      }
    });
  }

  Future<void> getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> getVideo() async {
    XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
      });
    }
  }

  Future<void> uploadImage() async {
    try {
      String fileName = _imageFile.path.split('/').last;

      // Compress the image file
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        _imageFile.path,
        minHeight: 1920,
        minWidth: 1080,
        quality: 80,
      );

      // Provide a default value (empty list) if compressedBytes is null
      List<int> compressedList = compressedBytes ?? [];

      // Upload the compressed image to Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask =
          storageReference.putData(Uint8List.fromList(compressedList));
      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageURL = downloadUrl;
      });
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  Future<void> uploadVideo() async {
    try {
      String fileName = _videoFile.path.split('/').last;
      // Compress the video file
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        _videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (mediaInfo != null && mediaInfo.path != null) {
        // Upload the compressed video to Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('profile_videos/$fileName');
        UploadTask uploadTask = storageReference.putFile(File(mediaInfo.path!));
        TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

        setState(() {
          _uploadedVideoURL = downloadUrl;
        });
      } else {
        print('Error during video compression or missing file path.');
      }
    } catch (e) {
      print('Error during video upload: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String? profileImageUrl = data['profileImageUrl'];

                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : null,
                    );
                  }

                  return CircularProgressIndicator();
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Change Profile Picture'),
              onTap: getImage,
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Change Profile Video'),
              onTap: getVideo,
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: uploadVideo,
              child: const Text('Upload Video'),
            ),
            Container(
              height: 200,
              width: 300,
              child: VideoPlayer(_controller..initialize()),
              // child: _uploadedVideoURL != null
              //     ? VideoPlayer(_controller..initialize())
              //     : Container(),
            ),
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_uploadedImageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Show Contact Information'),
              value: _showContact,
              onChanged: (value) {
                setState(() {
                  _showContact = value;
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .update({'contact': value});
              },
            ),
            if (_showContact)
              const Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                ],
              ),
            SwitchListTile(
              title: const Text('Education'),
              value: _showEducation,
              onChanged: (value) {
                setState(() {
                  _showEducation = value;
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .update({'education': value});
              },
            ),
            if (_showEducation)
              const Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Degree'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Institution'),
                  ),
                ],
              ),
            SwitchListTile(
              title: const Text('Employment'),
              value: _showEmployment,
              onChanged: (value) {
                setState(() {
                  _showEmployment = value;
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .update({'employment': value});
              },
            ),
            if (_showEmployment)
              const Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Company'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Position'),
                  ),
                ],
              ),
            SwitchListTile(
              title: const Text('Skills'),
              value: _showSkills,
              onChanged: (value) {
                setState(() {
                  _showSkills = value;
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .update({'skills': value});
              },
            ),
            if (_showSkills)
              const Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Skill 1'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Skill 2'),
                  ),
                ],
              ),
            SwitchListTile(
              title: const Text('Specialization'),
              value: _showSpecialization,
              onChanged: (value) {
                setState(() {
                  _showSpecialization = value;
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .update({'specialization': value});
              },
            ),
            if (_showSpecialization)
              const Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Specialization 1'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Specialization 2'),
                  ),
                ],
              ),
            ListView.builder(
              itemCount: _posts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_posts[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
