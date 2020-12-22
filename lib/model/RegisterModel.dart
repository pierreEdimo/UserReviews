import 'package:flutter/foundation.dart';

class RegisterModel {
  final String userName;
  final String passWord;
  final String email;
  final String photoUrl;

  RegisterModel({
    @required this.userName,
    @required this.passWord,
    @required this.email,
    @required this.photoUrl,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        email: json['email'] as String,
        passWord: json['passWord'] as String,
        photoUrl: json['photoUrl'] as String,
        userName: json['userName'] as String,
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "passWord": passWord,
        "email": email,
        "photoUrl": photoUrl,
      };
}
