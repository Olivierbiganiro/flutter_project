import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/form_validation/form_validations.dart';
import 'package:smile_app/screens/Home.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:smile_app/screens/bottomnav.dart';
import 'package:smile_app/screens/list_of_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final String currentfirst_name;
  final String currentlast_names;
  final String currentuser_email;
  final String currentuser_picture;
  final String currentuser_password;
  final String User_role;

  UpdateUserScreen({
    required this.userId,
    required this.currentfirst_name,
    required this.currentlast_names,
    required this.currentuser_email,
    required this.currentuser_picture,
    required this.currentuser_password,
    required this.User_role,
  });

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final MyKey = GlobalKey<FormState>();
  TextEditingController _newFirstNameController = TextEditingController();
  TextEditingController _newLastNameController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  XFile? _newSelectedFile;
  bool _isLoading = false;
    @override
  void initState() {
    super.initState();
    _newFirstNameController.text = widget.currentfirst_name;
    _newEmailController.text = widget.currentuser_email;
    _newLastNameController.text=widget.currentlast_names;
  }

  void _openFilePicker() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newSelectedFile = pickedFile;
      });
    }
  }

  Future<void> showSuccessNotification() async {
    final snackBar = successNotification();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> showErrorNotification(String message) async {
    final snackBar = errorNotification(message);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> updateUser() async {
    if (_newSelectedFile != null && _newEmailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final imageBytes = await _newSelectedFile!.readAsBytes();

        var apiUrl = Connection_String.update_user_account;
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.fields['user_id'] = widget.userId;
        request.fields['new_first_name'] = _newFirstNameController.text;
        request.fields['new_last_names'] = _newLastNameController.text;
        request.fields['new_user_email'] = _newEmailController.text;
        request.fields['new_password'] = _newPasswordController.text;
        request.fields['User_role'] = widget.User_role;

        request.files.add(
          http.MultipartFile.fromBytes(
            'user_picture',
            imageBytes,
            filename: _newSelectedFile!.name,
          ),
        );

        var response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);

        if (response.statusCode == 200) {
          if (decodedResponse['success'] == true) {
            print("Success");
            await showSuccessNotification();
          }
        } else {
          print("Fail");
          await showErrorNotification(decodedResponse['message']);
        }
      } catch (e) {
        print('Error: $e');
        await showErrorNotification('Failed to connect to the server: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
            children: [
              Text('Update User'),
              
              Form(
                 key: MyKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'User ID: ${widget.userId}',
                    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 10),
                     TextFormField(
                      controller: _newFirstNameController,
                      decoration: InputDecoration(labelText: 'New first Name'),
                    ),
                     TextFormField(
                      controller: _newLastNameController,
                      decoration: InputDecoration(labelText: 'New last Name'),
                    ),
                    TextFormField(
                      controller: _newEmailController,
                      decoration: InputDecoration(labelText: 'New Email'),
                    ),
                    TextFormField(
                      validator: validatePasword,
                      controller: _newPasswordController,
                      obscureText: _obscureText,
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Enter password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                    ),),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _openFilePicker,
                      child: Text('Choose Image'),
                    ),
                    _newSelectedFile != null ? Text(_newSelectedFile!.name) : SizedBox.shrink(),
                    SizedBox(height: 16.0),
                   ElevatedButton(
  onPressed: () async {
    if (MyKey.currentState!.validate()) {
      if (_isLoading) {
        return;
      }

      await updateUser();
      
      if (!_isLoading) {
        // If the update was successful, navigate back to the login screen
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage())); // Replace LoginScreen with your actual login screen
      }
    }
  },
  child: Text('Update User'),
),
                  ],
                ),
              ),
            ],
          ),
        
          )),
      ),
    );
  }
SnackBar successNotification() {
  return SnackBar(
    content: const Text(
      "Your user updated Successfully",
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
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 30,
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
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 30,
      ),
  );
}

}
