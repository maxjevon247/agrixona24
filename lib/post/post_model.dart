
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String roomId;
  final String lastMessage;
  final Timestamp timestamp;

  ChatRoom({
    required this.roomId,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatRoom.fromDocument(DocumentSnapshot doc) {
    return ChatRoom(
      roomId: doc['roomId'],
      lastMessage: doc['lastMessage'],
      timestamp: doc['timestamp'],
    );
  }
}

class Message {
  final String id;
  final String roomId;
  final String senderId;
  final List<String> recipients;
  String content;
  final Timestamp timestamp;
  final Map<String, int> likes;
  final List<Comment> comments;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.recipients,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      roomId: map['roomId'],
      senderId: map['senderId'],
      content: map['content'],
      timestamp: map['timestamp'],
      likes: Map<String, int>.from(map['likes'] ?? {}),
      comments: (map['comments'] as List<dynamic>? ?? []).map((e) => Comment.fromMap(e)).toList(), 
      recipients: (map['recipients'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roodId': roomId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
      'likes': likes,
      'recipients': recipients,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }
  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      id: doc['Id'],
      roomId: doc['roomId'],
      senderId: doc['senderId'],
      content: doc['content'],
      timestamp: doc['timestamp'],
      likes: Map<String, int>.from(doc['likes'] ?? {}),
      comments: (doc['comments'] as List<dynamic>? ?? []).map((e) => Comment.fromMap(e)).toList(), 
      recipients: [],
    );
  }

}

class Comment {
  final String commentId;
  final String messageId;
  final String content;
  final String senderId;
  final Timestamp timestamp;
  final List<Comment> replies;
  final Map<String, bool> likes;

  Comment({
    required this.commentId,
    required this.messageId,
    required this.content,
    required this.senderId,
    required this.timestamp,
    required this.replies,
    required this.likes,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      messageId: map['messageId'],
      content: map['content'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
      likes: Map<String, bool>.from(map['likes'] ?? {}),
      replies: (map['replies'] as List<dynamic>? ?? []).map((e) => Comment.fromMap(e)).toList(),
    );
  }

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      commentId: doc['commentId'],
      messageId: doc['messageId'],
      content: doc['content'],
      senderId: doc['senderId'],
      timestamp: doc['timestamp'],
      likes: Map<String, bool>.from(doc['likes'] ?? {}),
      replies: (doc['replies'] as List<dynamic>? ?? []).map((e) => Comment.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'messageId': messageId,
      'content': content,
      'senderId': senderId,
      'timestamp': timestamp,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  String get id => commentId;
}

