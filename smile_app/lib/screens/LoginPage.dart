import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/main.dart';
import 'package:smile_app/screens/bottomnav.dart';
import 'package:smile_app/screens/sigUp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  Function()? refreshPostsCallback;
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
bool isLoggedIn = false;

@override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  Future<void> checkLoggedInStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // If the user is already logged in, navigate to the home page
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavBar(
            user_id: authProvider.user_id,
            last_names: authProvider.last_names,
            first_name: authProvider.first_name,
            user_email: authProvider.user_email,
            image_data: authProvider.image_data,
            User_role: authProvider.User_role,
            token: authProvider.token,
            refreshPostsCallback: authProvider.refreshPostsCallback,
          ),
        ),
      );
    }
  }

  Future<void> loginUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var apiUrl = Connection_String.loginUser;
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_email': _emailController.text,
          'user_password': _passwordController.text,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200 && data['success']) {
        final user = data['user'];
        final token = data['token'];
        refreshPostsCallback() {};
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(
              user_id: user['user_id'],
              last_names: user['last_names'],
              first_name: user['first_name'],
              user_email: user['user_email'],
              image_data: user['user_picture'],
              User_role: user['User_role'],
              token: token,
              refreshPostsCallback: refreshPostsCallback,
            ),
          ),
        );

        // Set isLoggedIn to true
        Provider.of<AuthProvider>(context, listen: false).setLoggedIn(true);
        Provider.of<AuthProvider>(context, listen: false).saveUserData();
      } else {
        // Handle login error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to the server: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
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

Future<bool> _onWillPop() async {
  if (_isLoading) {
    return false; 
  } else {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
    return true; 
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              color: Colors.green,
              height: 80,
              margin: EdgeInsets.only(bottom: 5),
              child: const Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text('Login',
                  style: TextStyle(
                              fontSize: 27.0, 
                            letterSpacing: 2.8,
                            fontWeight: FontWeight.w900),
                ),
              ],
            ),
            ),
               Padding(
                 padding: const EdgeInsets.all(17),
                 child: Container(
                        // height: 45,
                        // width: 45,
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
                  child:SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 25,),
                      const Text("Email",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 20,
                  ),),
                   SizedBox(height: 10,),
                      TextFormField(
                      style: TextStyle (fontSize: 20),
                      controller: _emailController,
                      autofocus: false,
                      validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                        color: Colors.blue,
                        ),
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                        // color: Colors.red,
                        width: 1,
                        ),
                        ),
                        ),
                    ),
                    SizedBox(height: 30),
    
                    const Text("Password",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 20,
                  ),),
                  SizedBox(height: 15),
                 TextFormField(
                          style: TextStyle(fontSize: 20),
                          controller: _passwordController,
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          obscureText: _obscureText,
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                // color: Colors.red,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                            Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
    
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child:TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginUser();
                                }
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Login',
                                    style: TextStyle(
                                      fontSize: 28.0, 
                                      color: Colors.green,
                                    letterSpacing: 2.8,
                                    fontWeight: FontWeight.w900),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                  "Not yet a member  ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 102, 101, 128),
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateUserScreen()));
                  },
                  child: const Text(
                    "SignUp",
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
        )),
    );
  }
}
