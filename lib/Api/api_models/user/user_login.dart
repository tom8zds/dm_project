// To parse this JSON data, do
//
//     final userLoginResponse = userLoginResponseFromMap(jsonString);

import 'dart:convert';

UserLoginResponse userLoginResponseFromMap(String str) =>
    UserLoginResponse.fromMap(json.decode(str));

String userLoginResponseToMap(UserLoginResponse data) =>
    json.encode(data.toMap());

class UserLoginResponse {
  UserLoginResponse({
    this.result,
    this.msg,
    this.data,
  });

  final int? result;
  final String? msg;
  final UserLoginData? data;

  factory UserLoginResponse.fromMap(Map<String, dynamic> json) =>
      UserLoginResponse(
        result: json["result"],
        msg: json["msg"],
        data: UserLoginData.fromMap(json["data"] ?? {})
      );

  Map<String, dynamic> toMap() => {
        "result": result,
        "msg": msg,
        "data": data?.toMap(),
      };
}

class UserLoginData {
  UserLoginData({
    this.uid,
    this.nickname,
    this.dmzjToken,
    this.photo,
    this.bindPhone,
    this.email,
    this.passwd,
  });

  final String? uid;
  final String? nickname;
  final String? dmzjToken;
  final String? photo;
  final String? bindPhone;
  final String? email;
  final String? passwd;

  factory UserLoginData.fromMap(Map<String, dynamic> json) => UserLoginData(
        uid: json["uid"],
        nickname: json["nickname"],
        dmzjToken: json["dmzj_token"],
        photo: json["photo"],
        bindPhone: json["bind_phone"],
        email: json["email"],
        passwd: json["passwd"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "nickname": nickname,
        "dmzj_token": dmzjToken,
        "photo": photo,
        "bind_phone": bindPhone,
        "email": email,
        "passwd": passwd,
      };
}
