import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: context.screenWidth * .03, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        child: ListTile(
          //profile picture
          // leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
          // leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(context.screenHeight * 0.3),
            child: CachedNetworkImage(
              height: context.screenHeight * 0.055,
              width: context.screenHeight * 0.055,
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageUrl: widget.user.image,
            ),
          ),
          // leading: CachedNetworkImage(
          //   width: 30,
          //   height: 30,
          //   imageUrl: widget.user.image,
          //   // placeholder: (context, url) => CircularProgressIndicator(),
          //   // errorWidget: (context, url, error) =>
          //   //     const CircleAvatar(child: Icon(Icons.person_outline)),
          // ),
          //user name
          title: Text(widget.user.name),
          //last message
          subtitle: Text(widget.user.about, maxLines: 1),
          //last message time
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
