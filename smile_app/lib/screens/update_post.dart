// import 'package:flutter/material.dart';
// import 'package:smile_app/connectiostring/api_connection.dart';
// import 'package:smile_app/screens/list_of_user.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:html' as html;

// class Update_Post extends StatefulWidget {
//   final String  userId;
//    final String post_id;
//   final String currentpost_discriptions;
//   final String currentpost_image;

//   Update_Post({
//   required this.userId, 
//   required this.post_id, 
//   required this.currentpost_discriptions,
//   required this.currentpost_image,
//   });
//   @override
//   _Update_PostState createState() => _Update_PostState();
// }

// class _Update_PostState extends State<Update_Post> {
// final MyKey = GlobalKey<FormState>();
//   TextEditingController _new_post_discriptions = TextEditingController();
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
//     _new_post_discriptions.text = widget.currentpost_discriptions;
//   }

//  Future<void> showSuccessNotification() async {
//   final snackBar = successnotification();
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

// Future<void> showErrorNotification(String message) async {
//   final snackBar = errornotification(message);
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

//   Future<void> updateUser() async {
//     if (_new_selectedFile != null && _new_post_discriptions.text.isNotEmpty) {
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
//         request.fields['new_user_id']= widget.userId;
//         request.fields['post_id'] = widget.post_id;
//         request.fields['new_post_discriptions'] = _new_post_discriptions.text;
        
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'new_post_image',
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
//             'Post id: ${widget.post_id}', // Display the userId
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//             TextField(
//               controller: _new_post_discriptions,
//               decoration: InputDecoration(labelText: 'new post discriptions'),
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

  
//   SnackBar successnotification() {
//     return SnackBar(
//       content: const Text(
//         "Your user updated Successfully",
//         style: TextStyle(
//           color: Color.fromARGB(255, 229, 235, 229),
//         ),
//       ),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       backgroundColor: Colors.green,
//       margin: EdgeInsets.only(
//         bottom: MediaQuery.of(context).size.height - 50,
//         right: 20,
//         left: 20,
//       ),
//     );
//   }

//   SnackBar errornotification(String message) {
//     return SnackBar(
//       content: Text(
//         message,
//         style: TextStyle(
//           color: Color.fromARGB(255, 8, 184, 75),
//         ),
//       ),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       backgroundColor: Colors.red,
//       margin: EdgeInsets.only(
//         bottom: MediaQuery.of(context).size.height - 50,
//         right: 20,
//         left: 20,
//       ),
//     );
//   }
// }


