import 'package:rethink_db_ns/rethink_db_ns.dart';

Future<void> createDb(RethinkDb r, Connection connection) async {
  await r.dbCreate('test').run(connection).catchError((onError) => {});
  await r.tableCreate("users").run(connection).catchError((onError) => {});
  await r.tableCreate("messages").run(connection).catchError((onError) => {});
  await r.tableCreate("receipts").run(connection).catchError((onError) => {});
  await r.tableCreate("typing_events").run(connection).catchError((onError) => {});
}


Future<void> cleanDb(RethinkDb r, Connection connection) async {
  await r.table("users").delete().run(connection);
  await r.table("messages").delete().run(connection);
  await r.table("receipts").delete().run(connection);
  await r.table("typing_events").delete().run(connection);
}