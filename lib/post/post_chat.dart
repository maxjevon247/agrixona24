// import 'dart:io';
// import 'package:agrixona24/post/post.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ffi' hide Size;

// // import '../post/post_model.dart';
// // import 'package:agrixona24/post/post_model.dart' hide ChatRoom;

// // /conversations (collection)
// //   /conversationId (document)
// //     /messages (sub-collection)
// //       /messageId (document)
// //         - content: "Hello, how are you?"
// //         - createdAt: Timestamp
// //         - senderId: "userId1"
// //         - type: "text"

// //  To implement a Flutter advanced chat using Firestore with likes, comments, and functionality, you can follow these steps:

// // 1. Set up Firestore and create a collection for chat rooms and messages.
// // 2. Create a ChatRoom model class with fields for roomId, lastMessage, and timestamp.
// // 3. Create a Message model class with fields for messageId, content, senderId, timestamp, and likes (a map of userIds and their corresponding like values).
// // 4. Create a Comment model class with fields for commentId, messageId, content, senderId, timestamp, and replies (a list of Comment objects).
// // 5. Create a ChatScreen widget that retrieves data from Firestore and displays the chat room name, last message, and a list of messages.
// // 6. Implement a like functionality that updates the likes map in the Message object when a user likes a message.
// // 7. Implement a comment functionality that allows users to add comments to a message and displays the number of comments.
// // 8. Implement a share functionality that allows users to share a message with other users.
// // 9. Use Firestore's security rules to control access to the chat rooms and messages.
// // 10. Use Firebase Authentication to manage user authentication and authorization.
// class ChatRoom {
//   final String roomId;
//   final String lastMessage;
//   final Timestamp timestamp;

//   ChatRoom({required this.roomId, required this.lastMessage, required this.timestamp});

//   factory ChatRoom.fromDocument(DocumentSnapshot doc) {
//     return ChatRoom(
//       roomId: doc['roomId'],
//       lastMessage: doc['lastMessage'],
//       timestamp: doc['timestamp'],
//     );
//   }
// }
// class Message{
//   //final message = Message();
//   final String messageId;
//   final String content;
//   final String senderId;
//   final Timestamp timestamp;
//   final Map<String, bool> likes;
//   final List<Comment> comments;

//   Message({
//     required this.messageId,
//     required this.senderId,
//     required this.content,
//     required this.timestamp,
//     required this.likes,
//     required this.comments,
//   });

//   factory Message.fromDocument(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final likes = (data['likes'] as List<dynamic>).map((like) => MapEntry(like, true)).toMap();
//     final comments = (data['comments'] as List<dynamic>).map((comment) => Comment.fromMap(comment)).toList();
//     return Message(
//       messageId: doc.id,
//       senderId: data['senderId'],
//       content: data['content'],
//       timestamp: data['timestamp'],
//       likes: likes,
//       comments: comments,
//     );
//   }


// }

// class Comment {
//   final String commentId;
//   final String messageId;
//   final String content;
//   final String senderId;
//   final Timestamp timestamp;
//   final List<Comment> replies;

//   Comment({required this.commentId, required this.messageId, required this.content, required this.senderId, required this.timestamp, required this.replies});

//   factory Comment.fromDocument(DocumentSnapshot doc) {
//     return Comment(
//       commentId: doc['commentId'],
//       messageId: doc['messageId'],
//       content: doc['content'],
//       senderId: doc['senderId'],
//       timestamp: doc['timestamp'],
//       replies: (doc['replies'] as List<dynamic>).map((e) => Comment.fromDocument(e as DocumentSnapshot)).toList(),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final ChatRoom chatRoom ;

//   ChatScreen({required this.chatRoom});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final TextEditingController messageController = TextEditingController();
//   List<Message> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     firestore.collection('chatRooms').doc(widget.chatRoom.roomId).collection('messages').orderBy('timestamp').snapshots().listen((event) {
//       setState(() {
//         messages = event.docs.map((doc) => Message.fromDocument(doc)).toList();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.chatRoom.lastMessage),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return ListTile(
//                   title: Text(message.content),
//                   subtitle: Text(message.senderId),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.thumb_up),
//                         onPressed: () {
//                           // Update the likes map in the Message object
//                         },
//                       ),
//                       Text('${message.likes.length}'),
//                       IconButton(
//                         icon: const Icon(Icons.comment),
//                         onPressed: () {
//                           // Show the comment screen
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.share),
//                         onPressed: () {
//                           // Share the message with other users
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     // Send the message to Firestore
//                     firestore.collection('chatRooms').doc(widget.chatRoom.roomId).collection('messages').add({
//                       'id': message.id,
//                       'senderId': message.senderId,
//                       'content': message.content,
//                       'timestamp': message.timestamp,
//                       'likes': message.likes,
//                       'comments': message.comments,
//                     });
//                     messageController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// class Message extends StatefulWidget {
//   final Message message;

//   Message({required this.message});

//   @override
//   _MessageState createState() => _MessageState();
// }

// class _MessageState extends State<Message> {
//   bool isLiked = false;
//   TextEditingController commentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(widget.message.content),
//           subtitle: Text(widget.message.senderId),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined),
//                 onPressed: () async {
//                   setState(() {
//                     isLiked = !isLiked;
//                   });
//                   await FirebaseFirestore.instance.collection('chatRooms').doc(widget.message.roomId).collection('messages').doc(widget.message.messageId).update({
//                     'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
//                   });
//                 },
//               ),
//               Text('${widget.message.likes.length}'),
//               IconButton(
//                 icon: const Icon(Icons.comment),
//                 onPressed: () {
//                   // Show the comment screen
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.share),
//                 onPressed: () {
//                   // Share the message with other users
//                 },
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: commentController,
//                   decoration: const InputDecoration(
//                     hintText: 'Add a comment',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () async {
//                   await FirebaseFirestore.instance.collection('chatRooms').doc(widget.message.roomId).collection('messages').doc(widget.message.messageId).collection('comments').add({
//                     'content': commentController.text,
//                     'senderId': FirebaseAuth.instance.currentUser!.uid,
//                     'timestamp': Timestamp.now(),
//                   });
//                   commentController.clear();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Message extends StatefulWidget {
//   final Message message;

//   Message({required this.message});

//   @override
//   _MessageState createState() => _MessageState();
// }

// class _MessageState extends State<Message> {
//   bool isLiked = false;
//   TextEditingController commentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(widget.message.content),
//           subtitle: Text(widget.message.senderId),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined),
//                 onPressed: () async {
//                   setState(() {
//                     isLiked = !isLiked;
//                   });
//                   await FirebaseFirestore.instance.collection('chatRooms').doc(widget.message.roomId).collection('messages').doc(widget.message.messageId).update({
//                     'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
//                   });
//                 },
//               ),
//               Text('${widget.message.likes.length}'),
//               IconButton(
//                 icon: const Icon(Icons.comment),
//                 onPressed: () {
//                   // Show the comment screen
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.share),
//                 onPressed: () async {
//                   // Share the message with other users
//                   final FirebaseUser currentUser = FirebaseAuth.instance.currentUser!;
//                   final String currentUserId = currentUser.uid;
//                   final String currentUserName = currentUser.displayName!;
//                   final String currentUserPhotoUrl = currentUser.photoURL!;
//                   final String messageId = widget.message.messageId;
//                   final String roomId = widget.message.roomId;
//                   final String content = widget.message.content;
//                   final String senderId = widget.message.senderId;
//                   final String senderName = widget.message.senderName;
//                   final String senderPhotoUrl = widget.message.senderPhotoUrl;
//                   final Timestamp timestamp = widget.message.timestamp;
//                   final List<String> likes = widget.message.likes.keys.toList();
//                   final List<String> replies = widget.message.replies.map((reply) => reply.messageId).toList();
//                   final DocumentReference messageRef = FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('messages').doc(messageId);
//                   final DocumentSnapshot messageSnapshot = await messageRef.get();
//                   final Message message = Message.fromDocument(messageSnapshot);
//                   final DocumentReference shareRef = FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('messages').doc(messageId).collection('shares').doc();
//                   await shareRef.set({
//                     'shareId': shareRef.id,
//                     'messageId': messageId,
//                     'senderId': currentUserId,
//                     'senderName': currentUserName,
//                     'senderPhotoUrl': currentUserPhotoUrl,
//                     'timestamp': Timestamp.now(),
//                   });
//                   final DocumentReference shareNotificationRef = FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('notifications').doc();
//                   await shareNotificationRef.set({
//                     'notificationId': shareNotificationRef.id,
//                     'roomId': roomId,
//                     'senderId': currentUserId,
//                     'senderName': currentUserName,
//                     'senderPhotoUrl': currentUserPhotoUrl,
//                     'type': 'share',
//                     'messageId': messageId,
//                     'content': content,
//                     'timestamp': Timestamp.now(),
//                   });
//                   final List<String> recipientIds = [];
//                   for (final String recipientId in message.recipients) {
//                     if (recipientId != currentUserId) {
//                       recipientIds.add(recipientId);
//                     }
//                   }
//                   for (final String recipientId in recipientIds) {
//                     final DocumentReference recipientRef = FirebaseFirestore.instance.collection('users').doc(recipientId);
//                     final DocumentSnapshot recipientSnapshot = await recipientRef.get();
//                    // final User recipient = recipientSnapshot.data()!['user'] as User;
//                     final User recipient = (recipientSnapshot.data() as Map<String, dynamic>)['user'];


//                     final String recipientName = recipient.displayName!;
//                     final String recipientPhotoUrl = recipient.photoURL!;
//                     final String notificationId = shareNotificationRef.id;
//                     await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('notifications').doc(notificationId).set({
//                       'notificationId': notificationId,
//                       'roomId': roomId,
//                       'senderId': currentUserId,
//                       'senderName': currentUserName,
//                       'senderPhotoUrl': currentUserPhotoUrl,
//                       'type': 'share',
//                       'messageId': messageId,
//                       'content': content,
//                       'timestamp': Timestamp.now(),
//                     });
//                     await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('chats').doc(roomId).update({
//                       'lastMessage': content,
//                       'lastMessageTimestamp': timestamp,
//                       'unreadCount': FieldValue.increment(1),
//                     });
//                     await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('chats').doc(roomId).collection('messages').doc(messageId).set({
//                       'messageId': messageId,
//                       'roomId': roomId,
//                       'senderId': senderId,
//                       'senderName': senderName,
//                       'senderPhotoUrl': senderPhotoUrl,
//                       'content': content,
//                       'timestamp': timestamp,
//                       'likes': likes,
//                       'replies': replies,
//                     });
//                     await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('chats').doc(roomId).collection('messages').doc(messageId).collection('shares').doc(shareRef.id).set({
//                       'shareId': shareRef.id,
//                       'messageId': messageId,
//                       'senderId': currentUserId,
//                       'senderName': currentUserName,
//                       'senderPhotoUrl': currentUserPhotoUrl,
//                       'timestamp': Timestamp.now(),
//                     });
//                     await FirebaseFirestore.instance.collection('users').doc(recipientId).collection('chats').doc(roomId).collection('notifications').doc(notificationId).set({
//                       'notificationId': notificationId,
//                       'roomId': roomId,
//                       'senderId': currentUserId,
//                       'senderName': currentUserName,
//                       'senderPhotoUrl': currentUserPhotoUrl,
//                       'type': 'share',
//                       'messageId': messageId,
//                       'content': content,
//                       'timestamp': Timestamp.now(),
//                     });
//                   }
//                 },
//               ),
//             ]
//           ),
//         ),
//       ]
//     );
//   }

// }
// // Use Firestore's security rules to control access to the chat rooms and messages.

// // To control access to the chat rooms and messages, you can use Firestore's security rules. 
// //For example, you can restrict access to the chat rooms and messages to authenticated users only. Here's an example of how you can do this:

// // Firestore security rules:

// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /chatRooms/{chatRoomId} {
//       allow read, write: if request.auth.uid != null;
//     }
//     match /chatRooms/{chatRoomId}/messages/{messageId} {
//       allow read, write: if request.auth.uid != null;
//     }
//     match /chatRooms/{chatRoomId}/messages/{messageId}/comments/{commentId} {
//       allow read, write: if request.auth.uid != null;
//     }
//     match /chatRooms/{chatRoomId}/messages/{messageId}/shares/{shareId} {
//       allow read, write: if request.auth.uid != null;
//     }
//     match /chatRooms/{chatRoomId}/notifications/{notificationId} {
//       allow read, write: if request.auth.uid != null;
//     }
//   }
// }

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw Exception('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         throw Exception('Wrong password provided for that user.');
//       }
//     }
//   }

//   Future<User?> signUpWithEmailAndPassword(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         throw Exception('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         throw Exception('The email address is already in use by another account.');
//       }
//     }
//   }

//   Future<void> signOut() async {
//     return _firebaseAuth.signOut();
//   }

//   User? getCurrentUser() {
//     return _firebaseAuth.currentUser;
//   }
// }







// class FirestoreService {
//   final FirebaseFirestore _firestore;

//   FirestoreService(this._firestore);

//   Future<void> addMessage(Message message) async {
//     await _firestore.collection('messages').add(message.toMap());
//   }

//   Stream<List<Message>> getMessages(String conversationId) {
//     return _firestore
//         .collection('messages')
//         .doc(conversationId)
//         .collection(conversationId)
//         .orderBy('timestamp')
//         .snapshots()
//         .map((querySnapshot) => querySnapshot.docs
//             .map((doc) => Message.fromMap(doc.data()))
//             .toList());
//   }

//   Future<void> likeMessage(String messageId, String userId) async {
//     await _firestore.collection('messages').doc(messageId).update({
//       'likes': FieldValue.arrayUnion([userId]),
//     });
//   }

//   Future<void> unLikeMessage(String messageId, String userId) async {
//     await _firestore.collection('messages').doc(messageId).update({
//       'likes': FieldValue.arrayRemove([userId]),
//     });
//   }

//   Future<void> commentOnMessage(String messageId, String userId, String comment) async {
//     await _firestore.collection('messages').doc(messageId).update({
//       'comments': FieldValue.arrayUnion([{
//         'userId': userId,
//         'comment': comment,
//         'timestamp': Timestamp.now(),
//       }]),
//     });
//   }

//   Future<void> shareMessage(String messageId, String userId) async {
//     await _firestore.collection('messages').doc(messageId).update({
//       'shares': FieldValue.arrayUnion([userId]),
//     });
//   }
// }



// class ChatScreen extends StatefulWidget {
//   final String conversationId;

//   ChatScreen(this.conversationId);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _messageController = TextEditingController();
//   final _firestoreService = FirestoreService();
//   List<Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _firestoreService.getMessages(widget.conversationId).listen((messages) {
//       setState(() {
//         _messages = messages;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return ListTile(
//                   title: Text(message.content),
//                   subtitle: Text('${message.senderId} - ${message.timestamp}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.thumb_up),
//                         onPressed: () {
//                           _firestoreService.likeMessage(message.id, 'currentUser');
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.comment),
//                         onPressed: () {
//                           _firestoreService.commentOnMessage(message.id, 'currentUser', 'comment text');
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.share),
//                         onPressed: () {
//                           _firestoreService.shareMessage(message.id, 'currentUser');
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     final message = Message(
//                       messageId: DateTime.now().toString(),
//                       senderId: 'currentUser',
//                       content: _messageController.text,
//                       comments: [],
//                       timestamp: Timestamp.now(),
//                     );
//                     _firestoreService.addMessage(message);
//                     _messageController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }