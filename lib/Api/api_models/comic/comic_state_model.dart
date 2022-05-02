enum Status { ONGOING, FINISH , NONE}

final statusValues = EnumValues({"连载中": Status.ONGOING, "已完结": Status.FINISH, "未知": Status.NONE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverse = map.map((k, v) => new MapEntry(v, k));

  EnumValues(this.map);
}
