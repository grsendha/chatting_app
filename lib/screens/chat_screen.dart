import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/view_profile_screen.dart';
import 'package:we_chat/widgets/message_card.dart';

import '../api/apis.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /* ---------------------------- uploading images ---------------------------- */
  bool isUploading = false;
  /* ------------------------------ showing emoji ----------------------------- */
  bool showingEmoji = false;
/* ---------------------------- storing messages ---------------------------- */
  List<Message> list = [];
  /* ------------------------ for handling message text ----------------------- */
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          /* ---- //if emoji are shown and back button is pressed then hide emojis ---- */
          /* ------- //or else simple close  current screen on back button click ------ */
          onWillPop: () {
            if (showingEmoji) {
              setState(() {
                showingEmoji = !showingEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 244, 251, 255),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        /* -------------------------- //if data is loading -------------------------- */
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(child: SizedBox());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          // log('Data: ${jsonEncode(data![2].data())}');
                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          log('donee');

                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                padding: EdgeInsets.only(
                                    top: context.screenHeight * 0.01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return MessageCard(message: list[index]);
                                }));
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii!👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (isUploading) progressBar(),
                _chatInput(),
                if (showingEmoji) emojiPicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget progressBar() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget emojiPicker() {
    /* -------- show emoji on keyboard emoji button click and vice versa -------- */
    // if (showingEmoji)
    return SizedBox(
      height: context.screenHeight * .35,
      child: EmojiPicker(
        textEditingController:
            textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          bgColor: const Color.fromARGB(255, 244, 251, 255),
          columns: 8,
          initCategory: Category.RECENT,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
      ),
    );
  }

  Widget _chatInput() {
    /* -------------------------- input field and button -------------------------- */
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: context.screenHeight * .01,
          horizontal: context.screenWidth * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  /* ----------------------------- //emoji button ----------------------------- */
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        showingEmoji = !showingEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: textController,
                    onTap: () {
                      if (showingEmoji) {
                        setState(() {
                          showingEmoji = !showingEmoji;
                        });
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  /* ---------------------------- //gallery button ---------------------------- */
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      /* ------------------------- // Pick multiple images ------------------------ */
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        log('Image Path:$images.path');
                        setState(() {
                          isUploading = true;
                        });

                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          isUploading = false;
                        });
                      }
                      if (images.isNotEmpty) {
                        log('Image Path:$images.path');

                        // await APIs.sendChatImage(widget.user, File(image.path));
                      }
                    },
                    icon: const Icon(Icons.image,
                        color: Colors.blueAccent, size: 26),
                  ),
                  /* ------------------------------ camera button ----------------------------- */
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      /* ---------------------------- // Pick an image ---------------------------- */
                      XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path:$image.path');
                        setState(() {
                          isUploading = true;
                        });

                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() {
                          isUploading = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  SizedBox(
                    width: context.screenWidth * .01,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                if (list.isEmpty) {

                  /* ----- //on first message add user to my_user collection of chat user ----- */
                  APIs.sendFirstMessage(
                      widget.user, textController.text, Type.text);
                } else {
                  /* --------------------------- simply send Message -------------------------- */
                  log('API send message');
                  APIs.sendMessage(widget.user, textController.text, Type.text);
                }

                textController.text = '';
              }
            },
            minWidth: 0,
            shape: const CircleBorder(),
            color: Colors.green,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(context.screenHeight * 0.3),
                  child: CachedNetworkImage(
                    height: context.screenHeight * 0.055,
                    width: context.screenHeight * 0.055,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }
}
