import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_providers/data_provier_contract.dart';
import 'package:flutter_chat_app/entity/chat.dart';
import 'package:flutter_chat_app/entity/local_message.dart';
import 'package:flutter_chat_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chats_view_model_test.mocks.dart';

@GenerateMocks([IDataprovider])
void main(){
  late ChatViewModel sut;
  late MockIDataprovider mockDataprovider;
  setUp(() {
    mockDataprovider = MockIDataprovider();
    sut = ChatViewModel(mockDataprovider);
  });

  final message = Message.fromJson({
    'from': '111',
    'to':'222',
    'contents':'hi',
    'timestamp': DateTime.parse('2024-01-01').toString(),
    'id':'4444'
  });

  test('начальные сообщения возвращают пустой список', () async {
    when(mockDataprovider.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });

  test('возвращает список сообщений из локального хранилища', () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chatId: chat.id!, message: message,receipt:  ReceiptStatus.deliverred);
    when(mockDataprovider.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await sut.getMessages('123');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });

  test('creates a new chat when sending first message', () async {
    when(mockDataprovider.findChat(any)).thenAnswer((_) async => null);
    await sut.sentMessage(message);
    verify(mockDataprovider.addChat(any)).called(1);
  });
  test('add new sent message to the chat', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(chatId: chat.id!,message: message,receipt:  ReceiptStatus.sent);
    when(mockDataprovider.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    await sut.getMessages(chat.id!);
    await sut.sentMessage(message);
    verifyNever(mockDataprovider.addChat(any));
    verify(mockDataprovider.addMessage(any)).called(1);
  });
  test('add new received message to the chat', () async {
    final chat = Chat('111');
    final localMessage =
        LocalMessage(chatId: chat.id!,message:  message, receipt:  ReceiptStatus.deliverred);
    when(mockDataprovider.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDataprovider.findChat(chat.id)).thenAnswer((_) async => chat);
    await sut.getMessages(chat.id!);
    await sut.receivedMessage(message);
    verifyNever(mockDataprovider.addChat(any));
    verify(mockDataprovider.addMessage(any)).called(1);
  });

}
