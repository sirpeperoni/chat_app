import 'dart:async';

import 'package:chat/domain/entity/message.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/encryption/encryption_contract.dart';
import 'package:chat/domain/services/message/message_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';




class MessageService implements IMessageService {

  final Connection _c;
  final RethinkDb _r;
  final IEncryption _encryption;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changefeed;

  MessageService(
    this._r,
    this._c,
    this._encryption
  );

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    var data = message.toJson();
    data['contents'] = _encryption.encrypt(message.contents!);
    Map record = await _r.table('messages').insert(data).run(_c);
    return record['inserted'] == 1;
  }

  void _startReceivingMessages(User user){
    _changefeed = _r
      .table('messages')
      .filter({'to':user.id})
      .changes({'include_initial':true})
      .run(_c)
      .asStream()
      .cast<Feed>()
      .listen((event){
        event.forEach((feedData){
          if(feedData['new_val'] == null) return;

          final message = _messageFromFeed(feedData);
          _controller.sink.add(message);
          _removeDeliverredMessage(message);
        }).catchError((err) => print(err))
        .onError((error, stackTrace) => print(error));
      });
  }

  Message _messageFromFeed(feedData){
    var data = feedData['new_val'];
    data['contents'] = _encryption.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  void _removeDeliverredMessage(Message message){
    _r.table('messages').get(message.id).delete({'return_changes': false}).run(_c);
  }
}