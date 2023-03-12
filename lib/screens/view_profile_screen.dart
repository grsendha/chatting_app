// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          // floatingActionButton: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text(
          //       'Joined On:  ',
          //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          //     ),
          //     Text(
          //       MyDateUtil.getLastMEssageTime(
          //           context: context,
          //           time: widget.user.createdAt,
          //           showYear: true),
          //       style: const TextStyle(color: Colors.black87, fontSize: 16),
          //     ),
          //   ],
          // ),
          /* -------------------------------- //AppBar -------------------------------- */
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          /* ---------------------------- //floatingButton ---------------------------- */

          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * 0.03,
                  ),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(context.screenHeight * 0.1),
                    child: CachedNetworkImage(
                      height: context.screenHeight * 0.2,
                      width: context.screenHeight * 0.2,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl: widget.user.image,
                    ),
                  ),
                  SizedBox(
                    height: context.screenHeight * 0.03,
                  ),
                  /* --------------------------- //user email label --------------------------- */
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  SizedBox(
                    height: context.screenHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        widget.user.about,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
