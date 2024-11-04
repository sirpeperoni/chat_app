import 'package:chat/domain/entity/receipt.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/receipt/receipt_service_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  late Connection c ;
  RethinkDb r = RethinkDb();
  late ReceiptService sut;
  setUp(() async {
    c = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, c);
    sut = ReceiptService(r, c);
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

  test('test name', () async {
    Receipt receipt = Receipt(recipient: '444', messageId: '1234', status: ReceiptStatus.deliverred, timestamp: DateTime.now());
    final res= await sut.send(receipt);
    expect(res, true);
  });

  test('подписка и получение', () async {
    sut.receipts(user).listen(expectAsync1((receipt) {
      expect(receipt.recipient, user.id);
    }, count: 2));
    Receipt receipt = Receipt(recipient: user.id, messageId: '1234', status: ReceiptStatus.deliverred, timestamp: DateTime.now());
    Receipt receipt2 = Receipt(recipient: user.id, messageId: '1234', status: ReceiptStatus.read, timestamp: DateTime.now());
    await sut.send(receipt);
    await sut.send(receipt2);
  });
}