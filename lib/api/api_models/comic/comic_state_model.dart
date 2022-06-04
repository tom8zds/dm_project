enum Status { ongoing, finish, none }

final statusValues = EnumValues(
    {"连载中": Status.ongoing, "已完结": Status.finish, "未知": Status.none});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverse = map.map((k, v) => MapEntry(v, k));

  EnumValues(this.map);
}
