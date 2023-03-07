import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          /* -------------------------------- //AppBar -------------------------------- */
          appBar: AppBar(
            title: const Text('Profile Screen'),
          ),
          /* ---------------------------- //floatingButton ---------------------------- */
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              onPressed: () async {
                Dialogs.showProgressBar(context);
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    /* -------------------- removing the progressBar screen ------------------- */
                    Navigator.pop(context);
                    /* --------- //removing the profile screen which leads to homescreen -------- */
                    Navigator.pop(context);
                    /* ------------ //then replacing the homescreen with loginscreen ------------ */
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
                await GoogleSignIn().signOut();
              },
              label: const Text('Logout'),
              icon: const Icon(Icons.logout_sharp),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
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

                    Stack(
                      children: [
                        /* ---------------------------- //profile picture --------------------------- */
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(context.screenHeight * 0.1),
                          child: CachedNetworkImage(
                            height: context.screenHeight * 0.2,
                            width: context.screenHeight * 0.2,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            imageUrl: widget.user.image,
                          ),
                        ),
                        /* ------------------ //floating button for picture change ------------------ */
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            shape: const CircleBorder(),
                            onPressed: () {},
                            color: Colors.black,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.03,
                    ),
                    /* --------------------------- //user email label --------------------------- */
                    Text(
                      widget.user.email,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.05,
                    ),
                    /* --------------------------- //name input field --------------------------- */
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: ((newValue) => APIs.me.name = newValue ?? ''),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        hintText: 'eg: Gyanaranjan Sendha',
                        label: const Text('Name'),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.02,
                    ),
                    /* --------------------------- //about input field -------------------------- */
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: ((newValue) => APIs.me.about = newValue ?? ''),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        hintText: 'eg: I m feeling awesome',
                        label: const Text('About'),
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.03,
                    ),
                    /* -------------------------- //user profile button ------------------------- */
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(context.screenWidth * .5,
                              context.screenHeight * .06)),
                      onPressed: () {
                        /* ---------------------------- //form validation --------------------------- */
                        if (_formKey.currentState!.validate()) {
                          //save the form information
                          _formKey.currentState!.save();
                          /* --------------------- //update the data of firestore --------------------- */
                          APIs.updateUserInfo();
                          log('inside Validator');
                          log(APIs.me.name);
                          /* --------------------------- //showing snackbar --------------------------- */
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully');
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'Update',
                        style: TextStyle(fontSize: 25),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
