class ChatUser {
  late final String createdAt;
  late final bool isOnline;
  late final String lastActive;
  late final String image;
  late final String id;
  late final String about;
  late final String name;
  late final String email;
  late final String pushToken;

  ChatUser(
      {required this.createdAt,
      required this.isOnline,
      required this.lastActive,
      required this.image,
      required this.id,
      required this.about,
      required this.name,
      required this.email,
      required this.pushToken});

  ChatUser.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last-active'] ?? '';
    image = json['image'] ?? '';
    id = json['id'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last-active'] = lastActive;
    data['image'] = image;
    data['id'] = id;
    data['about'] = about;
    data['name'] = name;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}