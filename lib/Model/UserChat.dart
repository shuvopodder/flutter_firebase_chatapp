import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constant/Firestore.dart';

class UserChat {
  String id;
  String photoUrl;
  String nickname;
  String aboutMe;

  UserChat({required this.id, required this.photoUrl, required this.nickname, required this.aboutMe});

  Map<String, String> toJson() {
    return {
      FirestoreConstant.nickname: nickname,
      FirestoreConstant.aboutMe: aboutMe,
      FirestoreConstant.photoUrl: photoUrl,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoUrl = "";
    String nickname = "";
    try {
      aboutMe = doc.get(FirestoreConstant.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstant.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstant.nickname);
    } catch (e) {}
    return UserChat(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
      aboutMe: aboutMe,
    );
  }
}