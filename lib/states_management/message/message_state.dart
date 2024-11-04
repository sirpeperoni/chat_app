part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  factory MessageState.initial() => MessageInitial();
  factory MessageState.sent(Message message) => MessageSentSuccess(message: message);
  factory MessageState.received(Message message) => MessageReceivedSuccess(message: message);
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccess extends MessageState {
  final Message message;
  const MessageSentSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccess extends MessageState {
  final Message message;
  const MessageReceivedSuccess({required this.message});

  @override
  List<Object> get props => [message];
}