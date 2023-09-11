// import 'package:flutter/material.dart';
// import 'package:smile_app/connectiostring/api_connection.dart';
// import 'package:smile_app/screens/update_post.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PostListScreen extends StatefulWidget {
//   @override
//   _PostListScreenState createState() => _PostListScreenState();
// }

// class _PostListScreenState extends State<PostListScreen> {
//   var api_alluser_Url = Connection_String.get_all_post;

//   List<dynamic> PostList = []; // The original list of users
//   List<dynamic> filteredPostList = []; // The filtered list based on search

//   @override
//   void initState() {
//     fetchPost(); // Fetch the user list when the screen is initialized
//     super.initState();
//   }

//   void searchUsers(String query) {
//     setState(() {
//       filteredPostList = PostList
//           .where((user) =>
//               user['post_discriptions']
//                   .toString()
//                   .toLowerCase()
//                   .contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   Future<void> fetchPost() async {
//     final response = await http.get(Uri.parse(api_alluser_Url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       if (data.containsKey('data')) {
//         setState(() {
//           PostList = data['data'];
//           filteredPostList = PostList; // Initialize the filtered list with all users
//         });
//       }
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }

//   Future<void> deletepost(BuildContext context, String PostId) async {
//     const api_Delete_Url = Connection_String.get_all_post;

//     final response = await http.delete(
//       Uri.parse('$api_Delete_Url?post_id=$PostId'),
//       headers: {'Content-Type': 'application/json'},
//     );

//     final responseData = json.decode(response.body);

//     if (response.statusCode == 200) {
//       if (responseData['success'] == true) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Success'),
//               content: Text(responseData['message']),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pop(context, true);
//                     Navigator.pop(context);
//                     if (responseData['success']) {
//                       // Extract user data from the response
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PostListScreen(),
//                         ),
//                       );
//                     } // Return true to previous screen
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text(responseData['message']),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//       setState(() {
//         fetchPost(); // Refresh the user list after deletion
//       });
//     } else {
//       print('POST deletion failed: ${responseData['message']}'); // Log error message
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: Text('Available post'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () async {
//               final result = await showSearch(
//                 context: context,
//                 delegate: UserSearchDelegate(PostList, deletepost),
//               );

//               if (result != null) {
//                 searchUsers(result);
//               }
//             },
//           ),
//           SizedBox(
//             width: 10,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: ListView.builder(
//           itemCount: filteredPostList.length,
//           itemBuilder: (context, index) {
//             final post = filteredPostList[index];
//             return ListTile(
//               leading: Container(
//               height: 100,
//               width: 100,
//               child: Image.memory(
//                 base64.decode(post['image_data']), // Decode the base64 encoded data
//                 fit: BoxFit.cover,
//               ),
//               ),
//               title: Text(post['post_discriptions'] ?? ''),
//               // subtitle: Text(user['user_email'] ?? ''),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       deletepost(context, post['post_id']);
//                     },
//                     child: const Text(
//                       'Delete',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Update_Post(
//                           post_id: post['post_id'] ?? '',
//                           userId: post['user_id'] ?? '',
//                           currentpost_discriptions: post['post_discriptions'] ?? '',
//                           currentpost_image: post['post_image'] ?? '',
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text('Update'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class UserSearchDelegate extends SearchDelegate<String> {
//   final Function(BuildContext, String) deleteUserFunction;
//   List<dynamic> userList;

//   UserSearchDelegate(this.userList, this.deleteUserFunction);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, ''); // Pass an empty string as the result
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final filteredResults = userList.where((user) =>
//         user['post_discriptions'].toString().toLowerCase().contains(query.toLowerCase())
//     ).toList();

//     return ListView.builder(
//       itemCount: filteredResults.length,
//       itemBuilder: (context, index) {
//       final post = filteredResults[index];

//         return ListTile(
//           title: Text(post['post_discriptions'] ?? ''),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   deleteUserFunction(context, post['user_id']);
//                 },
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               SizedBox(width: 8),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                    MaterialPageRoute(
//                           builder: (context) => Update_Post(
//                           post_id: post['post_id'] ?? '',
//                           userId: post['user_id'] ?? '',
//                           currentpost_discriptions: post['post_discriptions'] ?? '',
//                           currentpost_image: post['post_image'] ?? '',
//                           ),
//                         ),
//                   );
//                 },
//                 child: Text('Update'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final filteredResults = userList.where((user) =>
//         user['post_discriptions'].toString().toLowerCase().contains(query.toLowerCase())
//     ).toList();

//     return ListView.builder(
//       itemCount: filteredResults.length,
//       itemBuilder: (context, index) {
//         final post = filteredResults[index];
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ListTile(
//               title: Text(post['post_discriptions'] ?? ''),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       deleteUserFunction(context, post['post_id']);
//                     },
//                     child: const Text(
//                       'Delete',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  Update_Post(
//                           post_id: post['post_id'] ?? '',
//                           userId: post['user_id'] ?? '',
//                           currentpost_discriptions: post['post_discriptions'] ?? '',
//                           currentpost_image: post['post_image'] ?? '',
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text('Update'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
