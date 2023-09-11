import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/form_validation/form_validations.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';


class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final MyKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
 var _uploading = false;
  XFile? _selectedImage; // Using XFile from image_picker package
  bool _isLoading = false;

  void _openImagePicker() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> showSuccessNotification() async {
    final snackBar =successnotification();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> showErrorNotification(String message) async {
    final snackBar = errorNotification(message);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> registerUser() async {
    if (_selectedImage!= null && emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
       final imageBytes = await _selectedImage!.readAsBytes();

        var apiUrl = Connection_String.createUser;
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        request.fields['first_name'] = firstNameController.text;
        request.fields['last_names'] = lastNameController.text;
        request.fields['user_email'] = emailController.text;
        request.fields['user_password'] = passwordController.text;

         request.files.add(
          http.MultipartFile.fromBytes(
            'user_picture',
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
            Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
          }
        } else {
          print("Fail");
          await showErrorNotification(decodedResponse['message']);
          Navigator.push(context, MaterialPageRoute(builder: ((context) => CreateUserScreen())));
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
        backgroundColor: Colors.green,
      ),
      body:SingleChildScrollView(
        child:  Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Container(
              color: Colors.green,
              height: 80,
              margin: EdgeInsets.only(bottom: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 27.0,
                      letterSpacing: 2.8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                child: SingleChildScrollView(
                  child: Form(
                   key: MyKey,
                  child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 15,),

                   TextFormField(
                    style: TextStyle(fontSize: 13),
                    validator: Usernamevalidator,
                    controller: firstNameController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      labelText: "Enter First Name",
                      prefixIcon: Icon(Icons.person),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                    ),
                  ),
                    const SizedBox(height: 17,),
                    
                   SizedBox(height: 15,),
                    TextFormField(
                    style: TextStyle (fontSize: 13),
                     validator: Usernamevalidator,
                     controller: lastNameController,
                      autofocus: false,
                      decoration: InputDecoration(
                         labelText: "Enter Last Name",
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                        color: Colors.blue,
                        ),
                        ),
                       enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                        ),
                    ), 
                    
                     SizedBox(height: 17,),
                   
                   SizedBox(height: 15,),
                  TextFormField(
                    style: TextStyle(fontSize: 13),
                    validator: Emailvalidator,
                    controller: emailController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      labelText: "Enter Email",
                      prefixIcon: Icon(Icons.email),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                    ),
                  ),

                 SizedBox(height: 17,),
                  
                   SizedBox(height: 15,),
                     TextFormField(
                      style: TextStyle(fontSize: 13),
                      controller: passwordController,
                      obscureText: _obscureText,
                      validator: validatePasword,
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
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                      ),
                        ),
                SizedBox(height: 16.0),
                        // Existing form fields..
                    Text('Profile Image', style: TextStyle(fontSize: 13.0, letterSpacing: 2.8)),
                    SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _openImagePicker,
                          child: Text('Choose Image', style: TextStyle(fontSize: 12, letterSpacing: 2.8)),
                        ),
                        _selectedImage!= null
                            ? Text(_selectedImage!.name)
                            : SizedBox.shrink(),

                        SizedBox(height: 16.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (MyKey.currentState!.validate()) {
                                    _isLoading ? null : registerUser();
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : const Text(
                                        'Register',
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

                        // Other widgets...
                      ],
                    ),
                  ),
                ),
              ),
            ),

   const SizedBox(
          height: 42,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "i am arleady have account",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 168, 167, 216),
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          ],
        ),

      ),
      ));
  }


  
SnackBar successnotification() {
    return SnackBar(
      content: const Text(
        "Your account created Successfully",
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
        bottom: MediaQuery.of(context).size.height - 140,
        right: 20,
        left: 40,
      ),
    );
  }
}

