import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/data/data_providers/data_provier_contract.dart';
import 'package:flutter_chat_app/entity/chat.dart';
import 'package:flutter_chat_app/entity/local_message.dart';

abstract class BaseViewModel {
  final IDataprovider _dataprovider;

  BaseViewModel(this._dataprovider);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if(!await _isExistingChat(message.chatId)) {
      await _createNewChat(message.chatId);
    }
    await _dataprovider.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataprovider.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _dataprovider.addChat(chat);
  }
}