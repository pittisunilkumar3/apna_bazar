

class ListingCategoryModel {
    List<Datum>? data;

    ListingCategoryModel({
        this.data,
    });

    factory ListingCategoryModel.fromJson(Map<String, dynamic> json) => ListingCategoryModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
}

class Datum {
    dynamic id;
    dynamic icon;
    dynamic name;
    dynamic languageId;
    dynamic status;
    dynamic total_listing;
    dynamic image;

    Datum({
        this.id,
        this.icon,
        this.name,
        this.languageId,
        this.status,
        this.total_listing,
        this.image,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        icon: json["icon"],
        name: json["name"],
        languageId: json["language_id"],
        status: json["status"],
        image: json["image"],
        total_listing: json["total_listing"] ?? 0,
    );
}
