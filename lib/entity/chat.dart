// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/entity/local_message.dart';

class Chat {
  String? id;
  int unread = 0;
  List<LocalMessage>? messages = [];
  LocalMessage? mostRecent;
  Chat(
    this.id,
    {
      this.messages,
      this.mostRecent,
    }
  );

  toMap() => {'id':id};
  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);
}
