part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();
  factory ReceiptState.initial() => ReceiptInitial();
  factory ReceiptState.sent(Receipt receipt) => ReceiptSentSuccess(receipt: receipt);
  factory ReceiptState.received(Receipt receipt) => ReceiptReceivedSuccess(receipt: receipt);
  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptSentSuccess extends ReceiptState {
  final Receipt receipt;
  const ReceiptSentSuccess({required this.receipt});

  @override
  List<Object> get props => [receipt];
}

class ReceiptReceivedSuccess extends ReceiptState {
  final Receipt receipt;
  const ReceiptReceivedSuccess({required this.receipt});

  @override
  List<Object> get props => [receipt];
}