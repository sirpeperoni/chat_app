enum Typing {start, stop}

extension TypingParser on Typing{
  String value(){
    return toString().split('.').last;
  }

  static Typing fromString(String status){
    return Typing.values.firstWhere((e) => e.value() == status);
  }
}

class TypingEvent {
  final String? from;
  final String? to;
  final Typing event;
  String? _id;

  String? get id => _id;

  TypingEvent({required this.from, required this.to, required this.event});
  

  factory TypingEvent.fromJson(Map<String, dynamic> json){
    final event = TypingEvent(
      from: json['from'] as String?,
      to: json['to'] as String?,
      event: TypingParser.fromString(json['event']),
    );
    event._id = json['id'];
    return event;
  }
      

  Map<String, dynamic> toJson() => _$TypingEventToJson(this);

  Map<String, dynamic> _$TypingEventToJson(TypingEvent instance) => <String, dynamic>{
        'from': instance.from,
        'to': instance.to,
        'event': instance.event.value(),
      };
}