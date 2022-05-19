part of 'app_config_model.dart';

class DisplayModeConverter
    implements JsonConverter<DisplayMode, Map<String, dynamic>> {
  const DisplayModeConverter();

  @override
  DisplayMode fromJson(Map<String, dynamic> json) {
    return DisplayMode(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        refreshRate: json["refreshRate"]);
  }

  @override
  Map<String, dynamic> toJson(DisplayMode object) {
    return {
      "id": object.id,
      "width": object.width,
      "height": object.height,
      "refreshRate": object.refreshRate,
    };
  }
}
