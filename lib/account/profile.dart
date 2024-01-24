import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Post {
  // Define your Post model class if not already defined
  // ...

  // Example constructor
  Post.fromDocument(DocumentSnapshot document) {
    // Implement the constructor based on your Post model
    // ...
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late File _profilePic;
  late File _coverPic;
  late File _video;
  bool _uploading = false;
  late String _profilePicUrl;
  late String _coverPicUrl;
  late String _videoUrl;
  List<String> _friends = [];
  List<Post> _posts = [];
  bool _showContact = true;
  bool _showEducation = true;
  bool _showEmployment = true;
  bool _showSkills = true;
  bool _showSpecialization = true;

  Future<void> getProfilePic() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePic = File(image.path);
      });
    }
  }

  Future<void> getCoverPic() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverPic = File(image.path);
      });
    }
  }

  Future<void> getVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _video = File(video.path);
      });
    }
  }



  Future<void> uploadPicture(File imageFile, String folderName) async {
    try {
      setState(() {
        _uploading = true;
      });

      firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(folderName);
      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.child(imageFile.path).putFile(imageFile);

      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String url = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _uploading = false;
        if (folderName == 'profilePics') {
          _profilePicUrl = url;
        } else if (folderName == 'coverPics') {
          _coverPicUrl = url;
        } else if (folderName == 'videos') {
          _videoUrl = url;
        }
      });
    } catch (error) {
      print('Error during picture upload: $error');
      setState(() {
        _uploading = false;
      });
      // Handle the error as needed
    }
  }

  Future<void> uploadVideo() async {
    setState(() {
      _uploading = true;
    });

    final firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('videos');
    final firebase_storage.UploadTask uploadTask = firebaseStorageRef.child(_video.path).putFile(_video);

    final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      _uploading = false;
      _videoUrl = url;
    });
  }

  Future<void> getPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();
    setState(() {
      _posts = querySnapshot.docs.map((doc) => Post.fromDocument(doc)).toList().reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
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
            // Profile Picture
            Center(
              child: Stack(
                children: <Widget>[
                  _profilePicUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_profilePicUrl),
                          radius: 50,
                        )
                      : const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/default_profile.png'),
                          radius: 50,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: getProfilePic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cover Picture
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: _coverPicUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_coverPicUrl),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/default_cover.png'),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: getCoverPic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Profile Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Profile Settings'),
              onTap: () {
                // Navigate to Profile Settings Screen
              },
            ),
            // Friends List
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Friends'),
              onTap: () {
                // Navigate to Friends List Screen
              },
            ),
            // Image and Video Upload
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Image Upload
                ElevatedButton(
                  onPressed: _uploading ? null : getProfilePic,
                  child: const Text('Upload Image'),
                ),
                // Video Upload
                ElevatedButton(
                  onPressed: _uploading ? null : getVideo,
                  child: const Text('Upload Video'),
                ),
              ],
            ),
            // Uploading Progress
            _uploading
                ? const LinearProgressIndicator()
                : Container(),
            // Profile Information
            Column(
              children: <Widget>[
                // Name
                const ListTile(
                  title: Text('Name'),
                  subtitle: Text('John Doe'),
                ),
                // Bio
                const ListTile(
                  title: Text('Bio'),
                  subtitle: Text('Software Engineer at XYZ Corp.'),
                ),
                // Contact
                ListTile(
                  title: const Text('Contact'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showContact = !_showContact;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showContact = !_showContact;
                    });
                  },
                ),
                if (_showContact)
                  const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle: Text('john.doe@xyz.com'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                        subtitle: Text('555-555-5555'),
                      ),
                    ],
                  ),
                // Education
                ListTile(
                  title: const Text('Education'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showEducation = !_showEducation;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showEducation = !_showEducation;
                    });
                  },
                ),
                if (_showEducation)
                  const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('BS in Computer Science'),
                        subtitle: Text('University of XYZ, 2015-2019'),
                      ),
                    ],
                  ),
                // Employment
                ListTile(
                  title: const Text('Employment'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showEmployment = !_showEmployment;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showEmployment = !_showEmployment;
                    });
                  },
                ),
                if (_showEmployment)
                  const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.work),
                        title: Text('Software Engineer'),
                        subtitle: Text('XYZ Corp., 2019-Present'),
                      ),
                    ],
                  ),
                // Skills
                ListTile(
                  title: const Text('Skills'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showSkills = !_showSkills;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showSkills = !_showSkills;
                    });
                  },
                ),
                if (_showSkills)
                  const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Dart'),
                      ),
                      ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Flutter'),
                      ),
                      ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Java'),
                      ),
                    ],
                  ),
                // Specialization
                ListTile(
                  title: const Text('Specialization'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _showSpecialization = !_showSpecialization;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _showSpecialization = !_showSpecialization;
                    });
                  },
                ),
                if (_showSpecialization)
                  const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.developer_mode),
                        title: Text('Mobile App'),
                      ),
                    ],
                  ),
                // Publications
                ListTile(
                  title: const Text('Publications'),
                  onTap: () {
                    // Navigate to Publications Screen
                    navigateToPublicationsScreen();
                  },
                ),
                // Links
                ListTile(
                  title: const Text('Links'),
                  onTap: () {
                    // Navigate to Links Screen
                    navigateToLinksScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPublicationsScreen() {
    // Implement navigation logic
    print('Navigate to Publications Screen');
  }

  void navigateToLinksScreen() {
    // Implement navigation logic
    print('Navigate to Links Screen');
  }
}
