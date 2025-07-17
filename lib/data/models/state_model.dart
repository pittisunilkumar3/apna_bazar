class StateListModel {
  List<Datum>? data;

  StateListModel({this.data});

  factory StateListModel.fromJson(Map<String, dynamic> json) =>
      StateListModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic country_id;
  dynamic status;
  dynamic name;

  Datum({
    this.id,
    this.country_id,
    this.status,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        country_id: json["country_id"],
        status: json["status"],
        name: json["name"],
      );
}
