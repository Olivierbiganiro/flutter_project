// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:smile_app/screens/Add_post.dart';
// import 'package:smile_app/screens/Home.dart';
// import 'package:smile_app/screens/HomePage.dart';
// import 'package:smile_app/screens/List_of_post.dart';
// import 'package:smile_app/screens/list_of_user.dart';
// import 'package:smile_app/screens/userDetail.dart';

// class BottomNavBar extends StatefulWidget {
//   final String userName;
//   final String firstName;
//   final String useremail;
//   final String image_data;
//   final String token;

//   BottomNavBar({
//     required this.userName,
//     required this.useremail,
//     required this.image_data,
//     required this.firstName,
//     required this.token,
//   });

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   PageController pageController = PageController();
//   int selectedIndex = 0;
//   bool _loggedIn = true; // Store token and expiration time here
//   String? _token;
//   DateTime? _tokenExpiration;


//   void onPageChanged(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

//   void logout() {
//     // Clear token and expiration time on logout
//     setState(() {
//       _token = null;
//       _tokenExpiration = null;
//       _loggedIn = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red,
//       body: Column(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${widget.userName}!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.green[3000],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 logout();
//                               },
//                               child: const Row(
//                                 children: [
//                                   Text(
//                                     "logout",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Icon(Icons.logout),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     height: 60,
//                     child: Row(
//                       children: [
//                         SizedBox(width: 30),
//                         for (int i = 1; i < bottomIcons.length; i++)
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = i;
//                                 pageController.jumpToPage(i);
//                               });
//                             },
//                             child: Icon(
//                               bottomIcons[i],
//                               color: selectedIndex == i
//                                   ? Color.fromARGB(255, 240, 241, 240)
//                                   : Colors.white,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: PageView.builder(
//               controller: pageController,
//               onPageChanged: onPageChanged,
//               itemCount: child.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   child: child[index],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               for (int i = 0; i < 1; i++)
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = i;
//                       pageController.jumpToPage(i);
//                     });
//                   },
//                   child: Icon(
//                     bottomIcons[i],
//                     color: selectedIndex == i
//                         ? Colors.green
//                         : Colors.grey.withOpacity(0.5),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// List<Widget> child = [
//   HomeSreen(),
//   UserListScreen(),
//   // PostScreen(),
//   TextButton(
//     onPressed: () {
//       _showUserInfoDialog(context as BuildContext, 'SampleUsername', 'sample@email.com');
//     },
//     child: Text('Show Info'),
//   ),
// ];

// List<IconData> bottomIcons = [
//   Icons.home,
//   Icons.list,
//   Icons.add,
//   Icons.person,
// ];




//   void _showUserInfoDialog(BuildContext context, String username, String useremail) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('User Information'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Username: $username'),
//               SizedBox(height: 8),
//               Text('Email: $useremail'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }