import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../post/post_model.dart';

class CommentScreen extends StatefulWidget {
  final Message message;

  CommentScreen({required this.message});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _getCommentsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildCommentTile(snapshot.data![index]);
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Stream<List<Comment>> _getCommentsStream() {
    return firestore
        .collection('chatRooms')
        .doc(widget.message.roomId)
        .collection('messages')
        .doc(widget.message.id)
        .collection('comments')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Comment.fromDocument(doc))
            .toList());
  }

  Widget _buildCommentTile(Comment comment) {
    return ListTile(
      title: Text(comment.content),
      subtitle: Text(comment.senderId),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              comment.likes.containsKey(FirebaseAuth.instance.currentUser!.uid)
                  ? Icons.thumb_up
                  : Icons.thumb_up_outlined,
            ),
            onPressed: () {
              _toggleLike(comment);
            },
          ),
          Text('${comment.likes.length}'),
          IconButton(
            icon: const Icon(Icons.reply),
            onPressed: () {
              _showReplyDialog(comment);
            },
          ),
          if (comment.senderId == FirebaseAuth.instance.currentUser!.uid)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(comment);
              },
            ),
          if (comment.senderId == FirebaseAuth.instance.currentUser!.uid)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteComment(comment);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
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
            onPressed: () {
              _addCommentToFirestore();
              commentController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _toggleLike(Comment comment) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final liked = comment.likes.containsKey(userId) ? !comment.likes[userId]! : true;
    final updatedLikes = {userId: liked};


    firestore
        .collection('chatRooms')
        .doc(widget.message.roomId)
        .collection('messages')
        .doc(widget.message.id)
        .collection('comments')
        .doc(comment.commentId)
        .update({
      'likes': updatedLikes,
    });
  }

  void _showReplyDialog(Comment parentComment) {
    // Implement reply functionality here
  }

  void _showEditDialog(Comment comment) {
    // Implement edit functionality here
  }

  void _deleteComment(Comment comment) {
    firestore
        .collection('chatRooms')
        .doc(widget.message.roomId)
        .collection('messages')
        .doc(widget.message.id)
        .collection('comments')
        .doc(comment.commentId)
        .delete();
  }

  void _addCommentToFirestore() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    firestore
        .collection('chatRooms')
        .doc(widget.message.roomId)
        .collection('messages')
        .doc(widget.message.id)
        .collection('comments')
        .add({
      'senderId': userId,
      'content': commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': <String, bool>{},
    });
  }
}