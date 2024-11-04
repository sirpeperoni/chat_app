enum ReceiptStatus {sent, deliverred, read}

extension EnumParsing on ReceiptStatus {
  String value(){
    return toString().split('.').last;
  }

  static ReceiptStatus fromString(String status){
    return ReceiptStatus.values.firstWhere((e) => e.value() == status);
  }
}

class Receipt {
  final String? recipient;
  final String? messageId;
  final ReceiptStatus? status;
  final DateTime? timestamp;
  String? _id;

  Receipt({required this.recipient, required this.messageId, required this.status, required this.timestamp});

  String? get id => _id;

  factory Receipt.fromJson(Map<String, dynamic> json){
    final receipt = Receipt(
      recipient: json['recipient'] as String?,
      messageId: json['message_id'] as String?,
      status: EnumParsing.fromString(json['status']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );
    receipt._id = json['id'];
    return receipt;
  }
      

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
        'recipient': instance.recipient,
        'message_id': instance.messageId,
        'status': instance.status?.value(),
        'timestamp': instance.timestamp?.toIso8601String(),
      };
}