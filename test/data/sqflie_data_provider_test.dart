import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_providers/sqflite_data_provider.dart';
import 'package:flutter_chat_app/entity/chat.dart';
import 'package:flutter_chat_app/entity/local_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflie_data_provider_test.mocks.dart';


// class MockSqfliteDatabase extends Mock implements Database{

// }

// class MockBatch extends Mock implements Batch {

// }


@GenerateMocks([Database, Batch])
void main(){
  late SqfliteDataProvider sut;
  late MockDatabase database;
  late MockBatch batch;
  setUp(() {
    database = MockDatabase();
    batch = MockBatch();
    sut = SqfliteDataProvider(database);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hi',
    'timestamp': DateTime.parse("2024-01-01").toString(),
    'id': '4444'
  });

  test('вставка чата в бд', () async {
    final chat = Chat('1234');
    when(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);
    
    await sut.addChat(chat);
    
    verify(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform insert of message to the database', () async {
    //arrange
    final localMessage = LocalMessage(chatId: '1234', message: message, receipt: ReceiptStatus.sent);
    when(database.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);
    //act
    await sut.addMessage(localMessage);
    //assert
    verify(database.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
  test('should perform a database query and return message', () async {
    //arrange
    final messagesMap = [
      {
        'chat_id': '111',
        'id': '4444',
        'from': '111',
        'to': '222',
        'contents': 'hey',
        'receipt': ReceiptStatus.sent,
        'timestamp': DateTime.parse("2021-04-01"),
      }
    ];
    when(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);
    //act
    var messages = await sut.findMessages('111');
    //assert
    expect(messages.length, 1);
    expect(messages.first.chatId, '111');
    verify(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).called(1);
  });
  test('should perform database update on messages', () async {
    //arrange
    final localMessage = LocalMessage(chatId: '1234', message: message, receipt: ReceiptStatus.sent);
    when(database.update('messages', localMessage.toMap(),
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs'), conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);
    //act
    await sut.updateMessage(localMessage);
    //assert
    verify(database.update('messages', localMessage.toMap(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
  test('should perform database batch delete of chat', () async {

    const chatId = '111';
    when(batch.commit(noResult: true)).thenAnswer((_) async => <Object?>[]);
    when(database.batch()).thenReturn(batch);

    await sut.deleteChat(chatId);

    verifyInOrder([
      database.batch(),
      batch.delete('messages', where: anyNamed('where'), whereArgs: [chatId]),
      batch.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      batch.commit(noResult: true)
    ]);
  });
}