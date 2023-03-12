import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/models/message.dart';

import '../helper/my_date_util.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.auth.currentUser!.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

/* ------------------------------ sender message ----------------------------- */
  _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.lightBlue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? context.screenWidth * .03
                : context.screenWidth * .04),
            margin: EdgeInsets.symmetric(
                horizontal: context.screenWidth * .04,
                vertical: context.screenHeight * .01),
            child: widget.message.type == Type.text
                /* -------------------------- show text of message -------------------------- */
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  )
                /* -------------------------- show image of message ------------------------- */
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      // height: context.screenHeight * 0.055,
                      // width: context.screenHeight * 0.055,
                      placeholder: (context, url) =>
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                      imageUrl: widget.message.msg,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: context.screenWidth * 0.04),
          child: Text(
            /* ------------------------------- //read time ------------------------------ */
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

/* ------------------------------- our message ------------------------------ */
  _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: context.screenWidth * .04,
            ),
            /* ------------------- //double tick icon for message read ------------------ */
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            /* -------------------------- for adding some space ------------------------- */
            const SizedBox(
              width: 2,
            ),
            /* -------------------------------- read time ------------------------------- */
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? context.screenWidth * .03
                : context.screenWidth * .04),
            margin: EdgeInsets.symmetric(
                horizontal: context.screenWidth * .04,
                vertical: context.screenHeight * .01),
            child: widget.message.type == Type.text
                /* -------------------------- show text of message -------------------------- */
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  )
                /* -------------------------- show image of message ------------------------- */
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      // height: context.screenHeight * 0.055,
                      // width: context.screenHeight * 0.055,
                      placeholder: (context, url) =>
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                      imageUrl: widget.message.msg,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
