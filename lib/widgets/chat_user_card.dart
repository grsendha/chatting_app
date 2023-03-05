import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

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
      color: Colors.yellow.shade100,
      elevation: 1,
      child: const InkWell(
        child: ListTile(
          //profile picture
          // leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
          leading: CircleAvatar(child: Icon(Icons.person_outline)),
          //user name
          title: Text('Demo User'),
          //last message
          subtitle: Text('Last User Message', maxLines: 1),
          //last message time
          trailing: Text('12:00 PM', style: TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
