class CityListModel {
  List<Datum>? data;

  CityListModel({
    this.data,
  });

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic state_id;
  dynamic status;
  dynamic name;
  dynamic latitude;
  dynamic longitude;
  dynamic createdAt;

  Datum({
    this.id,
    this.state_id,
    this.status,
    this.name,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        state_id: json["state_id"],
        status: json["status"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
