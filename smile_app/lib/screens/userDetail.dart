// import 'package:flutter/material.dart';
// import 'package:smile_app/connectiostring/api_connection.dart';
// import 'package:smile_app/screens/list_of_user.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:html' as html;

// class UserDetailScreen extends StatefulWidget {
//   final String userId;
//   final String currentfirst_name;
//   final String currentlast_names;
//   final String currentuser_email;
//   final String currentimage_data;
//   final String currentuser_password;
//   final String User_role;

//   UserDetailScreen({
//   required this.userId, 
//   required this.currentfirst_name, 
//   required this.currentlast_names,
//   required this.currentuser_email,
//   required this.currentimage_data,
//   required this.currentuser_password,
//   required this.User_role,
//   });
//   @override
//   _UserDetailScreenState createState() => _UserDetailScreenState();
// }

// class _UserDetailScreenState extends State<UserDetailScreen> {
// final MyKey = GlobalKey<FormState>();
//   TextEditingController _new_firstNameController = TextEditingController();
//   TextEditingController _new_lastNameController = TextEditingController();
//   TextEditingController _new_emailController = TextEditingController();
//   TextEditingController _new_passwordController = TextEditingController();
//   var __new_uploading = false;
//   html.File? _new_selectedFile;
//   bool _isLoading = false;

//   void _openFilePicker() async {
//     final input = html.FileUploadInputElement()..accept = 'image/*';
//     input.click();

//     input.onChange.listen((event) {
//       final file = input.files!.first;
//       setState(() {
//         _new_selectedFile = file;
//       });
//     });
//   }
//    @override
//   void initState() {
//     super.initState();
//     _new_firstNameController.text = widget.currentfirst_name;
//     _new_lastNameController.text = widget.currentlast_names;
//     _new_emailController.text = widget.currentuser_email;
//     _new_passwordController.text = widget.currentuser_password;
//   }
//   Future<void> showSuccessNotification() async {
//   final snackBar = successnotification();
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

// Future<void> showErrorNotification(String message) async {
//   final snackBar = errornotification(message);
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

//   Future<void> updateUser() async {
//     if (_new_selectedFile != null && _new_emailController.text.isNotEmpty) {
//       setState(() {
//         _isLoading = true; // Set loading indicator
//       });

//       try {
//         final reader = html.FileReader();
//         reader.readAsArrayBuffer(_new_selectedFile!);

//         await reader.onLoadEnd.first; // Wait for the read operation to complete

//         final imageBytes = reader.result as List<int>;

//         var apiUrl = Connection_String.update_user_account;
//         var request = http.MultipartRequest('POST',
//         Uri.parse(apiUrl));
//         request.fields['user_id']= widget.userId;
//         request.fields['new_first_name'] = _new_firstNameController.text;
//         request.fields['new_first_name'] = _new_firstNameController.text;
//         request.fields['new_last_names'] = _new_lastNameController.text;
//         request.fields['new_user_email'] = _new_emailController.text;
//         request.fields['new_password'] = _new_passwordController.text;
//         request.fields['new_password'] = _new_passwordController.text;
//         request.fields['User_role'] =widget.User_role;
        
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'user_picture',
//             imageBytes,
//             filename: _new_selectedFile!.name,
//           ),
//         );
        
//         var response = await request.send();
//         final responseBody = await response.stream.bytesToString();
//           final decodedResponse = json.decode(responseBody);
//         if (response.statusCode == 200) {
//           if (decodedResponse['success'] == true) {
//           print("sucess");
//           await showSuccessNotification();
//           Navigator.push(context, MaterialPageRoute(builder: ((context) => UserListScreen())),
//         );}
//         } else {
//             print("fail");
//             // showToast(decodedResponse['message'], Colors.red);
//              await showErrorNotification(decodedResponse['message']);
//         }
//       } catch (e) {
//         print('Error: $e');
//         await showErrorNotification('Failed to connect to the server: $e');
//       }

//       setState(() {
//         _isLoading = false; // Reset loading indicator
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update User'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
//           children: [
//           Text(
//             'User ID: ${widget.userId}', // Display the userId
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//             TextField(
//               controller: _new_firstNameController,
//               decoration: InputDecoration(labelText: 'New first Name'),
//             ),
//              TextField(
//               controller: _new_firstNameController,
//               decoration: InputDecoration(labelText: 'New last Name'),
//             ),
//             TextField(
//               controller: _new_emailController,
//               decoration: InputDecoration(labelText: 'New Email'),
//             ),
//             TextField(
//               controller: _new_passwordController,
//               decoration: InputDecoration(labelText: 'New pasword'),
//             ),
//              SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _openFilePicker,
//               child: Text('Choose Image'),
//             ),
//             _new_selectedFile != null
//                 ? Text(_new_selectedFile!.name)
//                 : SizedBox.shrink(),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed:(){
//                 updateUser(); // Wait for the updateUser() function to complete
                  
//               Navigator.push(context, MaterialPageRoute(builder: ((context) =>
//                                UserListScreen()),));
//               },
//               child: Text('Update User'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
