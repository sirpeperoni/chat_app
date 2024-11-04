import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_providers/data_provier_contract.dart';
import 'package:flutter_chat_app/entity/local_message.dart';
import 'package:flutter_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDataprovider _dataprovider;
  ChatsViewModel(this._dataprovider) : super(_dataprovider);


  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(chatId: message.from!, message: message, receipt: ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}