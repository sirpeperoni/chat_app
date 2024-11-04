// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';


part 'message_event.dart';
part 'message_state.dart';


class MessageBloc extends Bloc<MessageEvent, MessageState> {
  
  final IMessageService _messageService;
  StreamSubscription? _subscription;

  MessageBloc(
    this._messageService,
  ) : super(MessageState.initial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if(event is Subscried){
      await _subscription?.cancel();
      _subscription = _messageService
        .messages(activeUser: event.user)
        .listen((message) => add(_MessageReceived(message: message))
      );
    }

    if(event is _MessageReceived){
      yield MessageState.received(event.message);
    }

    if(event is MessageSent){
      await _messageService.send(event.message);
      yield MessageState.sent(event.message);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
