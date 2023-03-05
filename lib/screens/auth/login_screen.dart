
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
        actions: [
          //search button button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          //more features button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      //floatingButton
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_box),
        ),
      ),
    );
  }
}
