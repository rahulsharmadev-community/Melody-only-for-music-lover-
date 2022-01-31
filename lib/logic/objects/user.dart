import 'dart:convert';

class User {
  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.profilePic,
    required this.authorization,
    required this.serverAuthCode,
  });

  final String userId;
  final String name;
  final String email;
  final String phoneNo;
  final String profilePic;
  final bool authorization;
  final String serverAuthCode;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        profilePic: json["profilePic"],
        authorization: json["authorization"],
        serverAuthCode: json["serverAuthCode"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNo": phoneNo,
        "profilePic": profilePic,
        "authorization": authorization,
        "serverAuthCode": serverAuthCode,
      };

  factory User.empty() => User(
        userId: '',
        name: '',
        email: '',
        phoneNo: '',
        profilePic: '',
        authorization: false,
        serverAuthCode: '',
      );
}
