class CountryListModel {
  List<Datum>? data;

  CountryListModel({
    this.data,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic iso2;
  dynamic iso3;
  dynamic name;
  dynamic latitude;
  dynamic longitude;
  dynamic createdAt;

  Datum({
    this.id,
    this.iso2,
    this.iso3,
    this.name,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        iso2: json["iso2"],
        iso3: json["iso3"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}
