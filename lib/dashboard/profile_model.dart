

// class Post {
//   String content;
//   String userId;
//   List<String> comments;
//   List<String> likes;
//   List<String> shares;

//   Post({required this.content, this.userId, this.comments, this.likes, this.shares});
// }

// class Comment {
//   String userId;
//   String content;

//   Comment({this.userId, this.content});
// }


// class Message {
//   String senderId;
//   String receiverId;
//   String content;

//   Message({this.senderId, this.receiverId, this.content});
// }


// // class PostScreen extends StatefulWidget {
// //   @override
// //   _PostScreenState createState() => _PostScreenState();
// // }

// // class _PostScreenState extends State<PostScreen> {
// //   Post _post;
// //   TextEditingController _commentController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _post = Post(
// //       content: 'This is a sample post',
// //       userId: '123',
// //       comments: [],
// //       likes: [],
// //       shares: [],
// //     );
// //     Firestore.instance.collection('posts').document('123').snapshots().listen((data) {
// //       setState(() {
// //         _post = Post(
// //           content: data['content'],
// //           userId: data['userId'],
// //           comments: data['comments'],
// //           likes: data['likes'],
// //           shares: data['shares'],
// //         );
// //       });
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Post'),
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           Text(_post.content),
// //           RaisedButton(
// //             child: Text('Like'),
// //             onPressed: () {
// //               Firestore.instance.collection('posts').document('123').updateData({'likes': FieldValue.arrayUnion(['123'])});
// //             },
// //           ),
// //           RaisedButton(
// //             child: Text('Share'),
// //             onPressed: () {
// //               Firestore.instance.collection('posts').document('123').updateData({'shares': FieldValue.arrayUnion(['123'])});
// //             },
// //           ),
// //           TextField(
// //             controller: _commentController,
// //             decoration: InputDecoration(hintText: 'Add a comment'),
// //           ),
// //           RaisedButton(
// //             child: Text('Comment'),
// //             onPressed: () {
// //               Firestore.instance.collection('posts').document('123').updateData({
// //                 'comments': FieldValue.arrayUnion([
// //                   {
// //                     'userId': '123',
// //                     'content': _commentController.text,
// //                   }
// //                 ]),
// //               });
// //               _commentController.clear();
// //             },
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: _post.comments.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(_post.comments[index]['content']),
// //                   subtitle: Text(_post.comments[index]['userId']),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }