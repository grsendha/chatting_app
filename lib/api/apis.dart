import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';

class APIs {
  /* ------------------------ //firebase authentication ----------------------- */
  static FirebaseAuth auth = FirebaseAuth.instance;
  /* --------------------------- //firebase database -------------------------- */
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
/* ---------------------------- firebase storage ---------------------------- */
  static FirebaseStorage storage = FirebaseStorage.instance;

  /* --------------------------- firebase messageing -------------------------- */


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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updatedActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  /* -------------------- //updated profile picture of user ------------------- */
  /* ------------------------------ //episode 31 ------------------------------ */
  static Future<void> updateProfilePicture(File file) async {
    /* ------------------------ getting image file extension ----------------------- */
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

  /* -------------------------------------------------------------------------- */
  /*                           chat screen related API                          */
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
  /*                                                          chats(collection)--> conversation_id(doc)--> messages(collection)--> message(doc)                                                         */
  /* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------- useful for getting conversation id ----------------------------- */
  /* ----------------------------------------- episode 37 ----------------------------------------- */
/* ----------------------------- //useful fr getting conversation id ---------------------------- */
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  /* ---- for getting all messages of a specific conversation from firestore --- */
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    log('message received');
    /* ------------------ //message sending time can use as id ------------------ */
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    /* ----------------------------- message to send ---------------------------- */
    final Message message = Message(
        msg: msg,
        read: '',
        told: chatUser.id,
        type: type,
        fromId: user.uid,
        sent: time);
    // log();
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    /* ------------------------ getting image file extension ----------------------- */
    final ext = file.path.split('.').last;

    /* ----------------------- storage file ref with path ----------------------- */
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    /* ----------------------------- uploading image ---------------------------- */
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000} kb");
    });
    /* ----------------------- uploading file in firestore ---------------------- */
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
