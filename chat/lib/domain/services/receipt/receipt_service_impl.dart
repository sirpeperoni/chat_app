import 'dart:async';

import 'package:chat/domain/entity/receipt.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/receipt/receipt_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class ReceiptService implements IReceiptService {
  final Connection _c;
  final RethinkDb r;

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription? _changefeed;

  ReceiptService(
    this.r,
    this._c,
  );

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    var data = receipt.toJson();
    Map record = await r.table('receipts').insert(data).run(_c);
    return record['inserted'] == 1;
  }

  void _startReceivingReceipts(User user){
    _changefeed = r
      .table('receipts')
      .filter({'recipient':user.id})
      .changes({'include_initial':true})
      .run(_c)
      .asStream()
      .cast<Feed>()
      .listen((event){
        event.forEach((feedData){
          if(feedData['new_val'] == null) return;

          final receipt = _receiptFromFeed(feedData);
          _controller.sink.add(receipt);
        }).catchError((err) => print(err))
        .onError((error, stackTrace) => print(error));
      });
  }

  Receipt _receiptFromFeed(feedData){
    var data = feedData['new_val'];
    return Receipt.fromJson(data);
  }


}