import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/screens/profile_screen.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // ignore: todo
    // TODO: implement initState
    APIs.getSelfInfo();

    /* ----------------- checking the online and offline status ----------------- */
    /* ------------------------ resume---active or online ----------------------- */
    /* ----------------------- pause---inactive or offline ---------------------- */
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('pause')) {
          APIs.updatedActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          APIs.updatedActiveStatus(true);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        /* ---------- for hiding keyboard when a tap is detected on screen ---------- */
        FocusScope.of(context).unfocus();
        isSearching = false;
      }),
      child: WillPopScope(
        /* ----- //if search is on and back button is pressed then close search ----- */
        /* ----------- //or else simple close current screen on back button ---------- */
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            /* -------------------------------- //AppBar -------------------------------- */
            appBar: AppBar(
              leading: const Icon(CupertinoIcons.home),
              title: isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Name,email,...'),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: ((value) {
                        /* ------------------------------ search logic ------------------------------ */
                        _searchList.clear();
                        for (var i in list) {
                          /* ---------------- searching in name and email of every user --------------- */
                          /* ---------- its like searching of every name and email key value ---------- */
                          if (i.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      }),
                    )
                  : const Text('We Chat'),
              actions: [
                /* ------------------------- //search button button ------------------------- */
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    icon: Icon(isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                /* ------------------------- //more features button ------------------------- */
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
            /* ---------------------------- //floatingButton ---------------------------- */
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () async {
                  addChatUserDialog();
                },
                child: const Icon(Icons.add_box),
              ),
            ),
            body: StreamBuilder(
              /* ------------------------- //get id of known users ------------------------ */
              stream: APIs.getMyUsersID(),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  /* -------------------------- //if data is loading -------------------------- */
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      /* -------------- //get only those users whose ids are provided ------------- */
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          /* -------------------------- //if data is loading -------------------------- */
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          // return const Center(
                          //     child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (list.isNotEmpty) {
                              return ListView.builder(
                                itemCount: isSearching
                                    ? _searchList.length
                                    : list.length,
                                padding: EdgeInsets.only(
                                    top: context.screenHeight * 0.01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return ChatUserCard(
                                      user: isSearching
                                          ? _searchList[index]
                                          : list[index]);
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
                    );
                }
              }),
            )),
      ),
    );
  }

  // for adding new chat user
  void addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
