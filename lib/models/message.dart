// ignore_for_file: unrelated_type_equality_checks

class Message {
  late final String msg;
  late final String read;
  late final String told;
  late final Type type;
  late final String fromId;
  late final String sent;

  Message({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['msg'] = msg;
    json['read'] = read;
    json['told'] = told;
    json['type'] = type.name;
    json['fromId'] = fromId;
    json['sent'] = sent;
    return json;
  }
}

enum Type { text, image }
