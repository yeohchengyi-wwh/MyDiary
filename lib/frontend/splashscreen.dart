import 'package:mydiary/frontend/homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){ 
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Diary.jpg',scale: 4),
            SizedBox(height: 20),
            Text('My Diary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
} 