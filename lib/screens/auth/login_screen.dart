import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          Positioned(
            // top: MediaQuery.of(context).size.height * .15,
            // width: MediaQuery.of(context).size.width * .5,
            // left: MediaQuery.of(context).size.width * .25,
            top: context.screenHeight * .15,
            width: context.screenWidth * .5,
            left: context.screenWidth * .25,
            child: Image.asset('assets/images/chat.png'),
          ),
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
              onPressed: () {},
              icon: Image.asset(
                'assets/images/search.png',
                height: context.screenHeight * .03,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Sign In With'),
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
