import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile_app/screens/LoginPage.dart';
import 'package:smile_app/screens/bottomnav.dart';
import 'package:smile_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final user_id = prefs.getString('user_id') ?? "";
  final last_names = prefs.getString('last_names') ?? "";
  final first_name = prefs.getString('first_name') ?? "";
  final user_email = prefs.getString('user_email') ?? "";
  final image_data = prefs.getString('image_data') ?? "";
  final User_role = prefs.getString('User_role') ?? "";
  final token = prefs.getString('token') ?? "";

  runApp(
     ChangeNotifierProvider(
      create: (context) => AuthProvider(
        user_id: user_id,
        last_names: last_names,
        first_name: first_name,
        user_email: user_email,
        image_data: image_data,
        User_role: User_role,
        token: token,
        refreshPostsCallback: () {},
      ),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}


class MyApp extends StatelessWidget {
 final bool isLoggedIn;

  const MyApp({required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if the user is logged in or not
    final isLoggedIn = authProvider.isLoggedIn;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smile app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      home: isLoggedIn
          ? BottomNavBar(
              // Pass the necessary user information here
              user_id: authProvider.user_id,
              last_names: authProvider.last_names,
              first_name: authProvider.first_name,
              user_email: authProvider.user_email,
              image_data: authProvider.image_data,
              User_role: authProvider.User_role,
              token: authProvider.token,
              refreshPostsCallback: authProvider.refreshPostsCallback,
            )
          : splash_screen(),
    );
  }
}



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      backgroundColor: Color.fromARGB(255, 219, 219, 219),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Smile app',
                          style: TextStyle(
                            fontSize: 22.0,
                            letterSpacing: 2.8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            const Column(
              children: [
                Text(
                  'bring nature home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 98, 98),
                    fontSize: 16.0,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Here users enjoy Trending Memes',
                  style: TextStyle(
                    color: Color.fromARGB(255, 100, 98, 98),
                    fontSize: 16.0,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              width: 200,
              child: Image.asset('assets/images/OIP.png'),
            ),
            SizedBox(height: 25,),
            GestureDetector(
              onTap: () {
                if (authProvider.isLoggedIn) {
                  // User is already logged in, navigate to the BottomNavBar.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (builder) =>  BottomNavBar(
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
                } else {
                  // User is not logged in, navigate to the login screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => LoginPage()),
                  );
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Join us',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 22.0,
                        letterSpacing: 2.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




class AuthProvider with ChangeNotifier {
  bool isLoggedIn = false;
  String user_id = "";
  String last_names = "";
  String first_name = "";
  String user_email = "";
  String image_data = "";
  String User_role = "";
  String token = "";
  late void Function() refreshPostsCallback;

  AuthProvider({
    required this.user_id,
    required this.last_names,
    required this.first_name,
    required this.user_email,
    required this.image_data,
    required this.User_role,
    required this.token,
    required this.refreshPostsCallback,
  }) {
    // Load user data from shared preferences when the provider is created.
    loadUserData();
  }

  void setLoggedIn(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('user_id', user_id);
    prefs.setString('last_names', last_names);
    prefs.setString('first_name', first_name);
    prefs.setString('user_email', user_email);
    prefs.setString('image_data', image_data);
    prefs.setString('User_role', User_role);
    prefs.setString('token', token);
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    user_id = prefs.getString('user_id') ?? "";
    last_names = prefs.getString('last_names') ?? "";
    first_name = prefs.getString('first_name') ?? "";
    user_email = prefs.getString('user_email') ?? "";
    image_data = prefs.getString('image_data') ?? "";
    User_role = prefs.getString('User_role') ?? "";
    token = prefs.getString('token') ?? "";
    notifyListeners();
  }
}


