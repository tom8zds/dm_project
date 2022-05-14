import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String username;
  final int userId;
  final String loginToken;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  const User(
      {required this.username, required this.userId, required this.loginToken});

  const User.guest({this.userId = 0, this.loginToken = "", this.username = ""});

  @override
  List<Object?> get props => [username, userId, loginToken];
}
