// To parse this JSON data, do
//
//     final userLogin = userLoginFromMap(jsonString);

import 'dart:convert';

UserLogin userLoginFromMap(String str) => UserLogin.fromMap(json.decode(str));

String userLoginToMap(UserLogin data) => json.encode(data.toMap());

class UserLogin {
  UserLogin({
    this.result,
    this.msg,
    this.data,
  });

  final int result;
  final String msg;
  final UserData data;

  factory UserLogin.fromMap(Map<String, dynamic> json) => UserLogin(
        result: json["result"],
        msg: json["msg"],
        data: UserData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "result": result,
        "msg": msg,
        "data": data.toMap(),
      };
}

class UserData {
  UserData({
    this.uid,
    this.nickname,
    this.dmzjToken,
    this.photo,
    this.bindPhone,
    this.email,
    this.passwd,
  });

  final String uid;
  final String nickname;
  final String dmzjToken;
  final String photo;
  final String bindPhone;
  final String email;
  final String passwd;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
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
