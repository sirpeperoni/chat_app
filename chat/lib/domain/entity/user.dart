class User {
  final String? username;
  final String? photoUrl;
  String? _id;
  final bool? active;
  final DateTime? lastseen;

  String? get id => _id;

  User({
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastseen,
  });
  
  factory User.fromJson(Map<String, dynamic> json){
    final user = User(
      username: json['username'] as String?,
      photoUrl: json['photo_url'] as String?,
      active: json['active'] as bool?,
      lastseen: json['lastseen'] == null
          ? null
          : DateTime.parse(json['lastseen'] as String),
    );
    user._id = json['id'];
    return user;
  }
      

  Map<String, dynamic> toJson() => _$UserToJson(this);


  Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
        'username': instance.username,
        'photo_url': instance.photoUrl,
        'active': instance.active,
        'lastseen': instance.lastseen?.toIso8601String(),
      };

}
