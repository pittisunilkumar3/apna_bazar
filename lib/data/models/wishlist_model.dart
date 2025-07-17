

class WishlistModel {
    Data? data;

    WishlistModel({
        this.data,
    });

    factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
}

class Data {
    List<Datum>? data;

    Data({
        this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
}

class Datum {
    dynamic id;
    dynamic listingId;
    dynamic listingTitle;
    dynamic listingSlug;
    dynamic categories;
    dynamic thumbnail;
    dynamic createdAt;

    Datum({
        this.id,
        this.listingId,
        this.listingTitle,
        this.listingSlug,
        this.categories,
        this.thumbnail,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        listingId: json["listing_id"],
        listingTitle: json["listing_title"],
        listingSlug: json["listing_slug"],
        categories: json["categories"],
        thumbnail: json["thumbnail"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );
}
