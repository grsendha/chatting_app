import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/screens/profile_screen.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    // TODO: implement initState
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('We Chat'),
        actions: [
          //search button button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          //more features button
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(user: APIs.me),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      //floatingButton
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_box),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: context.screenHeight * 0.01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return ChatUserCard(user: list[index]);
                  }),
                );
              } else {
                return Center(
                  child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_rc6CDU.json',
                    repeat: true,
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
