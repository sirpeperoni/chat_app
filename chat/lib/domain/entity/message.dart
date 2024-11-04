class Message{
  final String? from;
  final String? to;
  final DateTime? timestamp;
  final String? contents;
  String? _id;

  String? get id => _id;

  Message({required this.from, required this.to, required this.timestamp, required this.contents});
  
  factory Message.fromJson(Map<String, dynamic> json){
    final message = Message(
      from: json['from'] as String,
      to: json['to'] as String,
      contents: json['contents'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );
    message._id = json['id'];
    return message;
  }
      

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
        'from': instance.from,
        'to': instance.to,
        'contents': instance.contents,
        'timestamp': instance.timestamp?.toIso8601String(),
      };
}