import 'package:agrixona24/post/comments.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import '../post/post_model.dart';


class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  ChatScreen({required this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() {
    firestore
        .collection('chatRooms')
        .doc(widget.chatRoom.roomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
      setState(() {
        messages = event.docs.map((doc) => Message.fromDocument(doc)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.lastMessage),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.senderId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: () {
                          // Update the likes map in the Message object
                        },
                      ),
                      Text('${message.likes.length}'),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          // Show the comment screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentScreen(message: message),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          // Share the message with other users
                          try {
                            await Share.share(
                              '${message.content}\n\nShared via your app!',
                              subject: 'Check out this message!',
                            );
                          } catch (e) {
                            print('Error sharing message: $e');
                            // Handle the error, show a snackbar, or display a user-friendly message
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessageToFirestore();
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessageToFirestore() {
    firestore
        .collection('chatRooms')
        .doc(widget.chatRoom.roomId)
        .collection('messages')
        .add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'content': messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': <String, bool>{},
      'comments': <Map<String, dynamic>>[],
    });
  }
}

// The rest of code remains unchanged.
