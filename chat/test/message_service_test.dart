import 'package:chat/domain/entity/message.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/encryption/encryption_impl.dart';
import 'package:chat/domain/services/message/message_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main(){
  late Connection c ;
  RethinkDb r = RethinkDb();
  late MessageService sut;
  setUp(() async {
    c = await r.connect(host: "127.0.0.1", port: 28015);
    final enctyption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(r, c);
    sut = MessageService(r, c, enctyption);
  });

  // tearDown(() async {
  //   await cleanDb(r, c);
  // });

  final user = User.fromJson(
    {
      'id': '1234',
      'active': true,
      'last_seen': DateTime.now(),
    }
  );

  final user2 = User.fromJson(
    {
      'id': '4321',
      'active': true,
      'last_seen': DateTime.now(),
    }
  );

  test('test name', () async {
    Message message = Message(from: user.id, to: '3456', timestamp: DateTime.now(), contents: 'message sent');
    final res = await sut.send(message);
    expect(res, true);
  });

  test('receive messages', () async {
    const contents = 'message sent';
    sut.messages(activeUser: user2).listen(expectAsync1((message) {
      expect(message.to, user2.id);
      expect(message.id, isNotEmpty);
      expect(message.contents, contents);
    }, count: 2));
    Message message1 = Message(from: user.id, to: user2.id, timestamp: DateTime.now(), contents: contents);
    Message message2 = Message(from: user.id, to: user2.id, timestamp: DateTime.now(), contents: contents);
    await sut.send(message1);
    await sut.send(message2);
  });

  test('успешно подписались и получаем новые сообщения', () async {
    Message message1 = Message(from: user.id, to: user2.id, timestamp: DateTime.now(), contents: 'message sent');
    Message message2 = Message(from: user.id, to: user2.id, timestamp: DateTime.now(), contents: 'message sent');
    await sut.send(message1);
    await sut.send(message2).whenComplete(
      () => sut.messages(activeUser: user2).listen(
        expectAsync1((message) {
          expect(message.to, user2.id);
        },count: 2),
      )
    );
  });
}