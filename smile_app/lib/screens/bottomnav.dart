import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/main.dart';
import 'package:smile_app/screens/Add_post.dart';
import 'package:smile_app/screens/Home.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:smile_app/screens/update_user.dart';

class BottomNavBar extends StatefulWidget {
  final String user_id;
  final String last_names;
  final String first_name;
  final String user_email;
  final String image_data;
  final String User_role;
  final String token;
   final void Function() refreshPostsCallback;
  BottomNavBar({
    required this.user_id,
    required this.last_names,
    required this.first_name,
    required this.user_email,
    required this.image_data,
    required this.User_role,
    required this.token,
    required this.refreshPostsCallback,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  bool isCommentVisible = false;
  int selectedPostId = -1;

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void toggleCommentVisibility(String postId) {
    setState(() {
      isCommentVisible = !isCommentVisible;
      selectedPostId = isCommentVisible ? int.parse(postId) : -1;
    });
  }
  String? _token;
  DateTime? _tokenExpiration;

logout() {
  
  setState(() {
    _token = null;
    _tokenExpiration = null;
  });

 
   ScaffoldMessenger.of(
              context)
          .showSnackBar(
        SnackBar(
          content: const Text(
            "Your logout Sucessfully",
            style: TextStyle(
              color:
                  Color.fromARGB(
                      255,
                      229,
                      235,
                      229),
            ),
          ),
          behavior:
              SnackBarBehavior
                  .floating,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius
                      .circular(
                          20)),
          backgroundColor:
              Color.fromARGB(255, 255, 1, 13),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(
                          context)
                      .size
                      .height -
                  100,
              right: 20,
              left: 20),
        ),
      );
 
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}


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
  Future<bool> _onWillPop() async {
    if (_isLoading) {
      return false; 
    } else {
      return true; 
    }
  }
  Future<void> showSuccessNotification() async {
    final snackBar = successnotification();
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
        // request.fields['user_id'] = '1';
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
            postDescriptionController.clear();
            toggleCommentVisibility('-1');
            Navigator.push(
              context,
              MaterialPageRoute(builder: ((context) => HomeScreen(user_id:  widget.user_id,))),
            );
          }
        } else {
          print("Fail");
          await showErrorNotification(decodedResponse['message']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => HomeScreen(user_id:  widget.user_id,))),
          );
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

  


  @override
  Widget build(BuildContext context) {
     List<Widget> child = [
      HomeScreen(user_id: widget.user_id,),
      Center(
        child: PostScreen(
           user_id: widget.user_id,
                    last_names: widget.last_names,
                    first_name: widget.first_name,
                    user_email:widget.user_email,
                    image_data: widget.image_data,
                    User_role: widget.User_role,
                    token: widget.token,
          refreshPostsCallback: widget.refreshPostsCallback, 
      ),
  )];
    return 
    WillPopScope(
      onWillPop: _onWillPop,
      child:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 90,
      ),
      drawer: DrawerFunction(context),
      body: body(child),
      bottomNavigationBar: bottonNavButton(),
    ),);
  }

  BottomAppBar bottonNavButton() {
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             for (int i = 0; i < bottomIcons.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                    pageController.jumpToPage(i);
                  });
                },
                child: Icon(
                  bottomIcons[i],
                  color: selectedIndex == i
                      ? Colors.green
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Column body(List<Widget> child) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: child.length,
            itemBuilder: (context, index) {
              return Container(
                child: child[index],
              );
            },
          ),
        ),
      ]
    );
  }

  Drawer DrawerFunction(BuildContext context) {
    return Drawer(

      width: 250,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${widget.last_names}'),
            accountEmail: Text(widget.user_email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                '${Connection_String.profile}${widget.image_data}',
              ),
            ),
          ),
         ListTile(
                leading: Icon(Icons.update),
                title: Text('Update'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateUserScreen(
                        userId: widget.user_id,
                        currentfirst_name: widget.first_name,
                        currentlast_names: widget.last_names,
                        currentuser_email: widget.user_email,
                        currentuser_picture: widget.image_data,
                        currentuser_password: '', // Pass the appropriate value here
                        User_role: widget.User_role,
                      ),
                    ),
                  );
                },
              ),

          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title:  
            TextButton(
              onPressed: () async {
                  if (_isLoading) {
                    return;
                  }

              await logout();
    
                  if (!_isLoading) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage())); // Replace LoginScreen with your actual login screen
                  }
                },child:const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Logout', style: TextStyle(
                      color: Colors.black
                    ),),
                  ],
                ),
            ),
                          
                          
            
          ),
          // Add more menu items here
        ],
      ),
    );
  }
SnackBar successnotification() {
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

List<IconData> bottomIcons = [
  Icons.home,
  Icons.post_add,
];
