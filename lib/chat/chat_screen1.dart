import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:agrixona24/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';



final _firestore = FirebaseFirestore.instance;
final ScrollController listScrollController = ScrollController();
String chatId = '';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String displayId;
  final String displayImage;
  final String currentUserId;
  final String name;

  ChatScreen({
    required this.displayId,
    required this.displayImage,
    required this.currentUserId,
    required this.name,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState(
        displayId: displayId,
        displayImage: displayImage,
        currentUserId: currentUserId,
        name: name,
      );
}

class _ChatScreenState extends State<ChatScreen> {
  final String displayId;
  final String displayImage;
  final String currentUserId;
  final String name;

  _ChatScreenState({
    required this.displayId,
    required this.displayImage,
    required this.currentUserId,
    required this.name,
  });

  final messageTextController = TextEditingController();
  String messageText = '';
  var image;
  String imageUrl = '';
  int type = 0;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    if (currentUserId.hashCode <= displayId.hashCode) {
      chatId = '$currentUserId-$displayId';
    } else {
      chatId = '$displayId-$currentUserId';
    }

    _firestore.collection('users').doc(currentUserId).update({'chattingWith': displayId});

    setState(() {});
  }

Future<void> getImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path); // Create a File object
    setState(() {
      image = imageFile;
    });

    final Reference reference = FirebaseStorage.instance.ref()
    .child(DateTime.now()
    .millisecondsSinceEpoch.toString());
    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl;
    });
  }
}


  void onSendMsg(String content, int type) {
    if (content.trim().isNotEmpty) {
      messageTextController.clear();
      final documentReference = _firestore
          .collection('messages')
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      _firestore.runTransaction((transaction) async {
        await transaction.set(documentReference, {
          'idFrom': currentUserId,
          'idTo': displayId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type,
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color(0xFF162447),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF162447)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('$name', style: const TextStyle(color: Color(0xFF162447))),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(currentUserId: currentUserId),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: IconButton(
                      icon: const Icon(Icons.image, color: Color(0xFF162447), size: 35.0),
                      onPressed: () {
                        messageText = imageUrl;
                        getImage();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onSendMsg(messageTextController.text, 0);
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String currentUserId;

  MessagesStream({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc(chatId)
          .collection(chatId)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF162447),
            ),
          );
        }

        final messages = snapshot.data!.docs;
        List<Widget> messageBubbles = [];
        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>;
          final messageText = messageData['content'];
          final messageTime = messageData['timestamp'];
          final sender = messageData['idFrom'];
          final messageType = messageData['type'];

          final messageBubble = MessageBubble(
            time: messageTime,
            text: messageText,
            isMe: currentUserId == sender,
            type: messageType,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String time;
  final String text;
  final bool isMe;
  final int type;

  MessageBubble({
    required this.time,
    required this.text,
    required this.isMe,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DateFormat('dd MMM kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(time))),
            style: TextStyle(
              fontSize: 12.0,
              color: const Color(0xFF162447).withOpacity(0.5),
            ),
          ),
          type == 0
              ? Material(
                  borderRadius: isMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        )
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                  elevation: 5.0,
                  color: isMe ? const Color(0xFF162447).withOpacity(0.8) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : const Color(0xFF162447).withOpacity(0.8),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                )
              : Material(
                child: CachedNetworkImage(
                  imageUrl: text,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
        ],
      ),
    );
  }
}