class PurchasePackageModel {
  Data? data;

  PurchasePackageModel({
    this.data,
  });

  factory PurchasePackageModel.fromJson(Map<String, dynamic> json) =>
      PurchasePackageModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Datum>? data;

  Data({
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic userId;
  dynamic packageId;
  dynamic trxId;
  dynamic depositId;
  dynamic apiSubscriptionId;
  dynamic title;
  dynamic price;
  dynamic isRenew;
  dynamic isImage;
  dynamic isVideo;
  dynamic isAmenities;
  dynamic expiryTime;
  dynamic isProduct;
  dynamic isCreateFrom;
  dynamic isBusinessHour;
  dynamic noOfListing;
  dynamic noOfImgPerListing;
  dynamic noOfCategoriesPerListing;
  dynamic noOfAmenitiesPerListing;
  dynamic noOfProduct;
  dynamic noOfImgPerProduct;
  dynamic seo;
  dynamic isWhatsapp;
  dynamic isMessenger;
  dynamic purchaseFrom;
  dynamic type;
  dynamic status;
  dynamic purchaseDate;
  dynamic expireDate;
  dynamic createdAt;

  Datum({
    this.id,
    this.userId,
    this.packageId,
    this.trxId,
    this.depositId,
    this.apiSubscriptionId,
    this.title,
    this.price,
    this.isRenew,
    this.isImage,
    this.isVideo,
    this.isAmenities,
    this.expiryTime,
    this.isProduct,
    this.isCreateFrom,
    this.isBusinessHour,
    this.noOfListing,
    this.noOfImgPerListing,
    this.noOfCategoriesPerListing,
    this.noOfAmenitiesPerListing,
    this.noOfProduct,
    this.noOfImgPerProduct,
    this.seo,
    this.isWhatsapp,
    this.isMessenger,
    this.purchaseFrom,
    this.type,
    this.status,
    this.purchaseDate,
    this.expireDate,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        packageId: json["package_id"],
        trxId: json["trx_id"],
        depositId: json["deposit_id"],
        apiSubscriptionId: json["api_subscription_id"],
        title: json["title"],
        price: json["price"] ?? "0",
        isRenew: json["is_renew"],
        isImage: json["is_image"],
        isVideo: json["is_video"],
        isAmenities: json["is_amenities"],
        expiryTime: json["expiry_time"],
        isProduct: json["is_product"],
        isCreateFrom: json["is_create_from"],
        isBusinessHour: json["is_business_hour"],
        noOfListing: json["no_of_listing"],
        noOfImgPerListing: json["no_of_img_per_listing"],
        noOfCategoriesPerListing: json["no_of_categories_per_listing"],
        noOfAmenitiesPerListing: json["no_of_amenities_per_listing"],
        noOfProduct: json["no_of_product"],
        noOfImgPerProduct: json["no_of_img_per_product"],
        seo: json["seo"],
        isWhatsapp: json["is_whatsapp"],
        isMessenger: json["is_messenger"],
        purchaseFrom: json["purchase_from"],
        type: json["type"],
        status: json["status"],
        purchaseDate: json["purchase_date"] == null
            ? DateTime.parse("2024-11-22T07:48:35.000000Z")
            : DateTime.parse(json["purchase_date"]),
        expireDate: json["expire_date"] == null
            ? DateTime.parse("2024-11-22T07:48:35.000000Z")
            : DateTime.parse(json["expire_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}
