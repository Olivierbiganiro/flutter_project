import 'package:flutter/material.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:smile_app/screens/list_of_user.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;
  final String token;

  WelcomeScreen({required this.userName, required this.token});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _loggedIn = true; // Initial login status

  // Store token and expiration time here
  String? _token;
  DateTime? _tokenExpiration;

  void logout() {
    // Clear token and expiration time on logout
    setState(() {
      _token = null;
      _tokenExpiration = null;
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Welcome'),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loggedIn)
                Row(
                  children: [
                    Text(
                      'Welcome, ${widget.userName}!',
                      style: TextStyle(fontSize: 24),
                    ),
                       
                    ElevatedButton(
                      onPressed: logout, // Call the logout function
                      child: Text('Logout'),
                    ),
                  ],
                ),
              if (!_loggedIn)
                Row(
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 13, 14),
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
    
        ],
      ),
      body: Column(children:[
         TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                        );
                      },
                      child: Text("List of Users"),
                    ),
      ]));
  }
}

 // Add it to the constructor

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome, $userName!', // Use the userName parameter here
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement logout logic here
//               },
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
