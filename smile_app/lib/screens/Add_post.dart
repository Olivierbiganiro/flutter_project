import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/screens/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  final String user_id;
  final void Function() refreshPostsCallback;
  final String last_names;
  final String first_name;
  final String user_email;
  final String image_data;
  final String User_role;
  final String token;
  PostScreen({
    required this.user_id,
    required this.refreshPostsCallback,
    required this.last_names,
    required this.first_name,
    required this.user_email,
    required this.image_data,
    required this.User_role,
    required this.token,
  });

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController postDescriptionController = TextEditingController();
  XFile? _selectedImage;
  bool _isLoading = false;

  void _openImagePicker() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> showSuccessNotification() async {
    final snackBar = successNotification();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> showErrorNotification(String message) async {
    final snackBar = errorNotification(message);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> submitPost() async {
    if (_selectedImage != null && postDescriptionController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        var apiUrl = Connection_String.create_post_story;
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(apiUrl),
        );
        final imageBytes = await _selectedImage!.readAsBytes();
        request.fields['user_id'] = widget.user_id;
        request.fields['post_discriptions'] = postDescriptionController.text;

        request.files.add(
          http.MultipartFile.fromBytes(
            'post_image',
            imageBytes,
            filename: _selectedImage!.name,
          ),
        );

        var response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);

        if (response.statusCode == 200) {
          if (decodedResponse['success'] == true) {
            print("Success");
            await showSuccessNotification();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
                  user_id: widget.user_id,
                  last_names: widget.last_names,
                  first_name: widget.first_name,
                  user_email: widget.user_email,
                  image_data: widget.image_data,
                  User_role: widget.User_role,
                  token: widget.token,
                  refreshPostsCallback: widget.refreshPostsCallback,
                ),
              ),
            );
          }
        } else {
          print("Fail");
          await showErrorNotification(decodedResponse['message']);
        }
      }catch (e) {
      print('Error: $e');
      await showErrorNotification('Failed to connect to the server: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        border: Border.all(color: Colors.green),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 160, 163, 160).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLines: 6,
                  minLines: 2,
                  controller: postDescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _openImagePicker,
                  child: const Text('Choose Image', style: TextStyle(fontSize: 20, letterSpacing: 2.8)),
                ),
                _selectedImage != null
                    ? Text(_selectedImage!.name) 
                    : SizedBox.shrink(),
                SizedBox(height: 16.0),
                Container(
  padding: EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color.fromARGB(255, 255, 255, 255),
  ),
  child: TextButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        if (!_isLoading) {
          submitPost();
                  }
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.green,
                        letterSpacing: 2.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
          ],
            ),
          ),
        ),
      );
  }

  SnackBar successNotification() {
    return SnackBar(
      content: const Text(
        "Your post created Successfully",
        style: TextStyle(
          color: Color.fromARGB(255, 229, 235, 229),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.green,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 50,
        right: 20,
        left: 20,
      ),
    );
  }

  SnackBar errorNotification(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Color.fromARGB(255, 8, 184, 75),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.red,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 50,
        right: 20,
        left: 20,
      ),
    );
  }
}
