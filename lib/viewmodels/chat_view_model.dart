import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_providers/data_provier_contract.dart';
import 'package:flutter_chat_app/entity/local_message.dart';
import 'package:flutter_chat_app/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final IDataprovider _dataprovider;
  ChatViewModel(this._dataprovider) : super(_dataprovider);
  String _chatId = '';
  int otherMessages = 0;

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataprovider.findMessages(chatId);
    if(messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(chatId: message.to!, message: message, receipt: ReceiptStatus.sent);
    if(_chatId.isNotEmpty) return await _dataprovider.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(chatId: message.from!, message: message, receipt: ReceiptStatus.deliverred);
    if(localMessage.chatId != _chatId) otherMessages++;
    await addMessage(localMessage);
  }
}