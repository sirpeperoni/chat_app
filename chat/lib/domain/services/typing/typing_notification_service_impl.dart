import 'dart:async';

import 'package:chat/domain/entity/typing_event.dart';
import 'package:chat/domain/entity/user.dart';
import 'package:chat/domain/services/typing/typing_notification_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class TypingNotificationService implements ITypingNotification {
  final Connection _c;
  final RethinkDb _r;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changefeed;

  TypingNotificationService(this._r, this._c);

  @override
  Future<bool> send({required TypingEvent event, required User? to}) async {
    bool active = to?.active ?? false;
    if(!active) return false;
    Map record = await _r.table('typing_events').insert(event.toJson(), {'conflict':'update'}).run(_c);
    return record['inserted'] == 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String?> usersIds) {
    _startReceivingMessages(user, usersIds);
    return _controller.stream;
  }
  
  @override
  void dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  void _startReceivingMessages(User user, List<String?> userIds){
    _changefeed = _r
      .table('typing_events')
      .filter((event) {
        return event('to')
          .eq(user.id)
          .and(_r.expr(userIds).contains(event('from')));
      })
      .changes({'include_initial':true})
      .run(_c)
      .asStream()
      .cast<Feed>()
      .listen((event){
        event.forEach((feedData){
          if(feedData['new_val'] == null) return;

          final typing = _eventFromFeed(feedData);
          _controller.sink.add(typing);
          _removeEvent(typing);
        }).catchError((err) => print(err))
        .onError((error, stackTrace) => print(error));
      });
  }

  TypingEvent _eventFromFeed(feedData){
    return TypingEvent.fromJson(feedData['new_val']);
  }

  void _removeEvent(TypingEvent event){
    _r.table('typing_events').get(event.id).delete({'return_changes': false}).run(_c);
  }

}