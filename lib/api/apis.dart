import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';

class APIs {
  /* ------------------------ //firebase authentication ----------------------- */
  static FirebaseAuth auth = FirebaseAuth.instance;
  /* --------------------------- //firebase database -------------------------- */
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
/* ---------------------------- firebase storage ---------------------------- */
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  /* --------------------- //for storing self information --------------------- */
  static late ChatUser me;

  /* -------------------------- //check user if exist ------------------------- */
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: $user.data()');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey I m Using We Chat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  /* --------------- //getting all users from firestore database -------------- */
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  /* -------------------- //updated profile picture of user ------------------- */
  /* ------------------------------ //episode 31 ------------------------------ */
  static Future<void> updateProfilePicture(File file) async {
    /* ------------------------ getting image file extion ----------------------- */
    final ext = file.path.split('.').last;
    log('extensions $ext');
    /* ----------------------- storage file ref with path ----------------------- */
    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    /* ----------------------------- uploading image ---------------------------- */
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000} kb");
    });
    /* ----------------------- uploading file in firestore ---------------------- */
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }
}
