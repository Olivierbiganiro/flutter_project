// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smile_app/main.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

@override
void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 7)).then((value) {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (ctx) => MyHomePage()));
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SizedBox(
              width: 100,
              child: Image.asset('assets/images/OIP.png')
              ),
              const SizedBox(height: 50,
              child: Text("MemeVibes"),),
             const Opacity(
              opacity: 0.8, 
              child: SpinKitPouringHourGlassRefined(
                color: Colors.green,
                size: 50.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}