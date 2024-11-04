import 'package:flutter_chat_app/entity/chat.dart';
import 'package:flutter_chat_app/entity/local_message.dart';

abstract class IDataprovider{
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat?> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
}