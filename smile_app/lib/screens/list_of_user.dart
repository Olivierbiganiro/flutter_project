import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/screens/update_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  var api_alluser_Url = Connection_String.get_all_user;

  List<dynamic> userList = []; 
  List<dynamic> filteredUserList = []; 

  @override
  void initState() {
    fetchUsers(); 
    super.initState();
  }

  void searchUsers(String query) {
    setState(() {
      filteredUserList = userList
          .where((user) =>
              user['first_name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user['user_email']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(api_alluser_Url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        setState(() {
          userList = data['data'];
          filteredUserList = userList; 
        });
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }

  Future<void> deleteUser(BuildContext context, String userId) async {
    const api_Delete_Url = Connection_String.delete_user;

    final response = await http.delete(
      Uri.parse('$api_Delete_Url?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseData['success'] == true) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    Navigator.pop(context);
                    if (responseData['success']) {
                      // Extract user data from the response
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(),
                        ),
                      );
                    } // Return true to previous screen
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        fetchUsers(); // Refresh the user list after deletion
      });
    } else {
      print('User deletion failed: ${responseData['message']}'); // Log error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: UserSearchDelegate(userList, deleteUser),
              );

              if (result != null) {
                searchUsers(result);
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: filteredUserList.length,
          itemBuilder: (context, index) {
            final user = filteredUserList[index];
            return ListTile(
              leading: Container(
  padding: EdgeInsets.symmetric(horizontal: 100),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255),
    border: Border.all(color: Colors.green),
    boxShadow: [
      BoxShadow(
        color: Colors.green.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 0),
      )
    ],
    borderRadius: BorderRadius.circular(10),
  ),
  height: 100,
  width: 100,
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.green), // Add border styling here
      borderRadius: BorderRadius.circular(10),
    ),
    child: Image.memory(
      base64.decode(user['image_data']), // Decode the base64 encoded data
      fit: BoxFit.cover,
    ),
  ),
),

              title: Text(user['first_name'] ?? ''),
              subtitle: Column(
                children: [
                  Text(user['user_email'] ?? ''),
                  SizedBox(height: 25,),
                  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      deleteUser(context, user['user_id']);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserScreen(
                           userId: user['user_id'] ?? '',
                            currentfirst_name: user['first_name'] ?? '',
                            currentlast_names: user['last_names'] ?? '',
                            currentuser_email: user['user_email'] ?? '',
                            currentuser_picture: user['user_picture'] ?? '',
                            currentuser_password: user['user_password'] ?? '',
                            User_role: user['User_role'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            
                ],
              ),
              
              );
          },
        ),
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final Function(BuildContext, String) deleteUserFunction;
  List<dynamic> userList;

  UserSearchDelegate(this.userList, this.deleteUserFunction);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Pass an empty string as the result
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredResults = userList.where((user) =>
        user['first_name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        user['user_email'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final user = filteredResults[index];
        return ListTile(
          title: Text(user['first_name'] ?? ''),
          subtitle: Text(user['user_email'] ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  deleteUserFunction(context, user['user_id']);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateUserScreen(
                          userId: user['user_id'] ?? '',
                          currentfirst_name: user['first_name'] ?? '',
                          currentlast_names: user['last_names'] ?? '',
                          currentuser_email: user['user_email'] ?? '',
                          currentuser_picture: user['user_picture'] ?? '',
                          currentuser_password: user['user_password'] ?? '',
                          User_role: user['User_role'] ?? '',
                      ),
                    ),
                  );
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredResults = userList.where((user) =>
        user['first_name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        user['user_email'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final user = filteredResults[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(user['first_name'] ?? ''),
              subtitle: Text(user['user_email'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      deleteUserFunction(context, user['user_id']);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserScreen(
                              userId: user['user_id'] ?? '',
                              currentfirst_name: user['first_name'] ?? '',
                              currentlast_names: user['first_name'] ?? '',
                              currentuser_email: user['first_name'] ?? '',
                              currentuser_picture: user['user_email'] ?? '',
                              currentuser_password: user['user_password'] ?? '',
                              User_role: user['User_role'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
