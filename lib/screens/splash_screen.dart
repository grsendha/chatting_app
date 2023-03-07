import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        //exit full screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

        if (APIs.auth.currentUser != null) {
          log('\nUser: $APIs.auth.currentUSer');
          //navigate to homescreen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          //navigate to loginscreen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar

      body: Stack(
        children: [
          //logo
          AnimatedPositioned(
            // top: MediaQuery.of(context).size.height * .15,
            // width: MediaQuery.of(context).size.width * .5,
            // left: MediaQuery.of(context).size.width * .25,
            top: context.screenHeight * .15,
            width: context.screenWidth * .5,
            right: context.screenWidth * .25,

            duration: const Duration(seconds: 1),
            child: Image.asset('assets/images/chat.png'),
          ),
          //google signin
          Positioned(
              // top: MediaQuery.of(context).size.height * .15,
              // width: MediaQuery.of(context).size.width * .5,
              // left: MediaQuery.of(context).size.width * .25,
              bottom: context.screenHeight * .15,
              width: context.screenWidth,
              child: const Text(
                "GYANARANJAN SENDHA",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, letterSpacing: 0.5),
              )),
        ],
      ),
      //floatingButton
    );
  }
}
