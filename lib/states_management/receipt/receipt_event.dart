part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();
  factory ReceiptEvent.onSubscried(User user) => Subscried(user: user);
  factory ReceiptEvent.onMessageSent(Receipt receipt) => ReceiptSent(receipt: receipt);

  @override
  List<Object> get props => [];
}

class Subscried extends ReceiptEvent {
  final User user;
  const Subscried({required this.user});

  @override
  List<Object> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final Receipt receipt;
  const ReceiptSent({required this.receipt});

  @override
  List<Object> get props => [receipt];
}

class _ReceiptReceived extends ReceiptEvent {
  
  final Receipt receipt;
  const _ReceiptReceived({required this.receipt});


  @override
  List<Object> get props => [receipt];
}