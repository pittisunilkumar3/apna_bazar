class MyListingModel {
  Data? data;

  MyListingModel({this.data});

  factory MyListingModel.fromJson(Map<String, dynamic> json) => MyListingModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Datum>? data;

  Data({this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic userId;
  dynamic purchasePackageId;
  dynamic purchasePackageName;
  dynamic categories;
  dynamic listingTitle;
  dynamic listingSlug;
  dynamic address;
  dynamic isActive;
  dynamic status;

  Datum({
    this.id,
    this.userId,
    this.purchasePackageId,
    this.purchasePackageName,
    this.categories,
    this.listingTitle,
    this.listingSlug,
    this.address,
    this.isActive,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        purchasePackageId: json["purchase_package_id"],
        purchasePackageName: json["purchase_package_name"],
        categories: json["categories"],
        listingTitle: json["listing_title"],
        listingSlug: json["listing_slug"],
        address: json["address"],
        isActive: json["is_active"],
        status: json["status"],
      );
}
