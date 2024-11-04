import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/user/user_service_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:test/test.dart';
import 'helpers.dart';

void main(){
  late Connection c ;
  RethinkDb r = RethinkDb();
  late UserService sut;
  setUp(() async {
    c = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, c);
    sut = UserService(r, c);
  });

  // tearDown(() async {
  //   await cleanDb(r, c);
  // });

  test('test name', () async {
    final user = User(username: "t2", photoUrl: "url", active: true, lastseen: DateTime.now());
    final userWithId = await sut.connect(user);
    expect(userWithId.id, isNotEmpty);
  });
}

