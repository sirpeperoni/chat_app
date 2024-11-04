import 'package:chat/domain/entity/typing_event.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/typing/typing_notification_service_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main(){
  late Connection c ;
  RethinkDb r = RethinkDb();
  late TypingNotificationService sut;
  setUp(() async {
    c = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, c);
    sut = TypingNotificationService(r, c);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, c);
  });

  final user = User.fromJson({
    'id':'1234',
    'active':true,
    'lastseen':DateTime.now().toString()
  });

  final user2 = User.fromJson({
    'id':'1111',
    'active':true,
    'lastseen':DateTime.now().toString()
  });

  test('test name', () async {
    TypingEvent typingEvent = 
      TypingEvent(from: user2.id, to: user.id, event: Typing.start);

    final res = await sut.send(event: typingEvent, to: user);
    expect(res, true);
  });

  test('подписка и получение', () async {
    sut.subscribe(user2, [user.id]).listen(expectAsync1((event) {
      expect(event.from, user.id);
    }, count: 2));
    TypingEvent typing = TypingEvent(to: user2.id, from: user.id, event: Typing.start);
    TypingEvent typing2 = TypingEvent(to: user2.id, from: user.id, event: Typing.stop);
    await sut.send(event: typing, to: user2);
    await sut.send(event: typing2, to: user2);
  });
}