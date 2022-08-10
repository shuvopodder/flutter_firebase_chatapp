
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constant/Firestore.dart';

class Message {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  Message({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstant.idFrom: this.idFrom,
      FirestoreConstant.idTo: this.idTo,
      FirestoreConstant.timestamp: this.timestamp,
      FirestoreConstant.content: this.content,
      FirestoreConstant.type: this.type,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstant.idFrom);
    String idTo = doc.get(FirestoreConstant.idTo);
    String timestamp = doc.get(FirestoreConstant.timestamp);
    String content = doc.get(FirestoreConstant.content);
    int type = doc.get(FirestoreConstant.type);
    return Message(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content, type: type);
  }
}
