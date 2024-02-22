import 'package:agrixona24/post/comments.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:share/share.dart';
import '../post/post_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

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
                return MessageWidget(message: message);
              },
            ),
          ),
          Container(
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
                    final message = Message(
                      id: DateTime.now().toString(),
                      senderId: FirebaseAuth.instance.currentUser!.uid,
                      recipients: [],
                      content: messageController.text,
                      timestamp: Timestamp.now(),
                      likes: {},
                      comments: [],
                      roomId: '',
                    );
                    firestore
                        .collection('chatRooms')
                        .doc(widget.chatRoom.roomId)
                        .collection('messages')
                        .add(message.toMap());
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isLiked = false;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.message.content),
          subtitle: Text(widget.message.senderId),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                ),
                onPressed: () async {
                  setState(() {
                    isLiked = !isLiked;
                  });
                  await FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(widget.message.roomId)
                      .collection('messages')
                      .doc(widget.message.id)
                      .update({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  });
                },
              ),
              Text('${widget.message.likes.length}'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CommentScreen(message: widget.message);
                  },),);
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final controller =
                      TextEditingController(text: widget.message.content);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Edit Message'),
                        content: TextField(
                          controller: controller,
                          onChanged: (value) {
                            widget.message.content = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('chatRooms')
                                  .doc(widget.message.roomId)
                                  .collection('messages')
                                  .doc(widget.message.id)
                                  .update(widget.message.toMap());
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  ).then((value) => controller.dispose());
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  // Share the message with other users
                  final User currentUser = FirebaseAuth.instance.currentUser!;
                  final String currentUserId = currentUser.uid;
                  final String currentUserName = currentUser.displayName!;
                  final String currentUserPhotoUrl = currentUser.photoURL!;
                  final String messageId = widget.message.id;
                  final String roomId = widget.message.roomId;
                  final String content = widget.message.content;
                  final String senderId = widget.message.senderId;
                  final Timestamp timestamp = widget.message.timestamp;
                  final List<String> likes = widget.message.likes.keys.toList();
                  final List<String> replies = widget.message.comments
                      .map((comment) => comment.id)
                      .toList();
                  final DocumentReference messageRef = FirebaseFirestore
                      .instance
                      .collection('chatRooms')
                      .doc(roomId)
                      .collection('messages')
                      .doc(messageId);
                  final DocumentSnapshot messageSnapshot =
                      await messageRef.get();

                  final Message message = Message.fromMap(
                    messageSnapshot.data() as Map<String, dynamic>,
                  );

                  final DocumentReference shareRef = FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(roomId)
                      .collection('messages')
                      .doc(messageId)
                      .collection('shares')
                      .doc();
                  await shareRef.set({
                    'shareId': shareRef.id,
                    'messageId': messageId,
                    'senderId': currentUserId,
                    'senderName': currentUserName,
                    'senderPhotoUrl': currentUserPhotoUrl,
                    'timestamp': Timestamp.now(),
                  });
                  final DocumentReference shareNotificationRef =
                      FirebaseFirestore.instance
                          .collection('chatRooms')
                          .doc(roomId)
                          .collection('notifications')
                          .doc();
                  await shareNotificationRef.set({
                    'notificationId': shareNotificationRef.id,
                    'roomId': roomId,
                    'senderId': currentUserId,
                    'senderName': currentUserName,
                    'senderPhotoUrl': currentUserPhotoUrl,
                    'type': 'share',
                    'messageId': messageId,
                    'content': content,
                    'timestamp': Timestamp.now(),
                  });
                  final List<String> recipientIds = [];
                  for (final String recipientId in message.recipients) {
                    if (recipientId != currentUserId) {
                      recipientIds.add(recipientId);
                    }
                  }
                  for (final String recipientId in recipientIds) {
                    final DocumentReference recipientRef = FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(recipientId);
                    final DocumentSnapshot recipientSnapshot =
                        await recipientRef.get();
                    final User recipient = (recipientSnapshot.data()
                        as Map<String, dynamic>)['user'];
                    // final String recipientName = recipient.displayName!;
                    // final String recipientPhotoUrl = recipient.photoURL!;
                    final String notificationId = shareNotificationRef.id;
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(recipientId)
                        .collection('notifications')
                        .doc(notificationId)
                        .set({
                      'notificationId': notificationId,
                      'roomId': roomId,
                      'senderId': currentUserId,
                      'senderName': currentUserName,
                      'senderPhotoUrl': currentUserPhotoUrl,
                      'type': 'share',
                      'messageId': messageId,
                      'content': content,
                      'timestamp': Timestamp.now(),
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(recipientId)
                        .collection('chats')
                        .doc(roomId)
                        .update({
                      'lastMessage': content,
                      'lastMessageTimestamp': timestamp,
                      'unreadCount': FieldValue.increment(1),
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(recipientId)
                        .collection('chats')
                        .doc(roomId)
                        .collection('messages')
                        .doc(messageId)
                        .set({
                      'messageId': messageId,
                      'roomId': roomId,
                      'senderId': senderId,
                      'content': content,
                      'timestamp': timestamp,
                      'likes': likes,
                      'replies': replies,
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(recipientId)
                        .collection('chats')
                        .doc(roomId)
                        .collection('messages')
                        .doc(messageId)
                        .collection('shares')
                        .doc(shareRef.id)
                        .set({
                      'shareId': shareRef.id,
                      'messageId': messageId,
                      'senderId': currentUserId,
                      'senderName': currentUserName,
                      'senderPhotoUrl': currentUserPhotoUrl,
                      'timestamp': Timestamp.now(),
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(recipientId)
                        .collection('chats')
                        .doc(roomId)
                        .collection('notifications')
                        .doc(notificationId)
                        .set({
                      'notificationId': notificationId,
                      'roomId': roomId,
                      'senderId': currentUserId,
                      'senderName': currentUserName,
                      'senderPhotoUrl': currentUserPhotoUrl,
                      'type': 'share',
                      'messageId': messageId,
                      'content': content,
                      'timestamp': Timestamp.now(),
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(widget.message.roomId)
                      .collection('messages')
                      .doc(widget.message.id)
                      .collection('comments')
                      .add({
                    'content': commentController.text,
                    'senderId': FirebaseAuth.instance.currentUser!.uid,
                    'timestamp': Timestamp.now(),
                  });
                  commentController.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
      throw Exception('Unexpected error occurred during sign in.');
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception(
            'The email address is already in use by another account.');
      }
      throw Exception('Unexpected error occurred during sign up.');
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

User? getCurrentUser() {
  return _firebaseAuth.currentUser;
}

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<void> addMessage(Message message) async {
    await _firestore.collection('messages').add(message.toMap());
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore
        .collection('messages')
        .doc(conversationId)
        .collection(conversationId)
        .orderBy('timestamp')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Message.fromMap(doc.data()))
            .toList());
  }

  Future<void> likeMessage(String messageId, String userId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unLikeMessage(String messageId, String userId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> commentOnMessage(
      String messageId, String userId, String comment) async {
    await _firestore.collection('messages').doc(messageId).update({
      'comments': FieldValue.arrayUnion([
        {
          'userId': userId,
          'comment': comment,
          'timestamp': Timestamp.now(),
        }
      ]),
    });
  }

  Future<void> shareMessage(String messageId, String userId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'shares': FieldValue.arrayUnion([userId]),
    });
  }
}