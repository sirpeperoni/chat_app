part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
  factory MessageEvent.onSubscried(User user) => Subscried(user: user);
  factory MessageEvent.onMessageSent(Message message) => MessageSent(message: message);

  @override
  List<Object> get props => [];
}

class Subscried extends MessageEvent {
  final User user;
  const Subscried({required this.user});

  @override
  List<Object> get props => [user];
}

class MessageSent extends MessageEvent {
  final Message message;
  const MessageSent({required this.message});

  @override
  List<Object> get props => [message];
}

class _MessageReceived extends MessageEvent {
  
  final Message message;
  const _MessageReceived({required this.message});


  @override
  List<Object> get props => [message];
}