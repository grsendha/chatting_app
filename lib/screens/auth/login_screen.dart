import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          //logo
          AnimatedPositioned(
            // top: MediaQuery.of(context).size.height * .15,
            // width: MediaQuery.of(context).size.width * .5,
            // left: MediaQuery.of(context).size.width * .25,
            top: context.screenHeight * .15,
            width: context.screenWidth * .5,
            right: isAnimate
                ? context.screenWidth * .25
                : -context.screenWidth * .25,
            duration: const Duration(seconds: 1),
            child: Image.asset('assets/images/chat.png'),
          ),
          //google signin
          Positioned(
            // top: MediaQuery.of(context).size.height * .15,
            // width: MediaQuery.of(context).size.width * .5,
            // left: MediaQuery.of(context).size.width * .25,
            bottom: context.screenHeight * .15,
            width: context.screenWidth * .9,
            left: context.screenWidth * .05,
            height: context.screenHeight * 0.06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 161, 230, 163),
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              icon: Image.asset(
                'assets/images/search.png',
                height: context.screenHeight * .03,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Login In With'),
                    TextSpan(
                      text: ' Google',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      //floatingButton
    );
  }
}
