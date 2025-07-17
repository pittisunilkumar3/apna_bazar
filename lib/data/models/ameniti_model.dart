

class AmenitiModel {
    List<Datum>? data;

    AmenitiModel({
        this.data,
    });

    factory AmenitiModel.fromJson(Map<String, dynamic> json) => AmenitiModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
}

class Datum {
    dynamic id;
    dynamic icon;
    dynamic name;
    dynamic status;
    dynamic createdAt;

    Datum({
        this.id,
        this.icon,
        this.name,
        this.status,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        icon: json["icon"],
        name: json["name"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

}
