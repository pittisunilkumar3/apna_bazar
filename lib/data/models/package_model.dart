class PackageModel {
  List<Datum>? data;

  PackageModel({this.data});

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic title;
  dynamic price;
  dynamic image;
  dynamic isFreePurchase;
  dynamic gatewayPlanId;
  dynamic isMultipleTimePurchase;
  dynamic expiryTime;
  dynamic expiryTimeType;
  dynamic noOfListing;
  dynamic isImage;
  dynamic noOfImgPerListing;
  dynamic noOfCategoriesPerListing;
  dynamic isProduct;
  dynamic noOfProduct;
  dynamic noOfImgPerProduct;
  dynamic isVideo;
  dynamic isAmenities;
  dynamic noOfAmenitiesPerListing;
  dynamic isBusinessHour;
  dynamic seo;
  dynamic isMessenger;
  dynamic isWhatsapp;
  dynamic dynamicFrom;
  dynamic isRenew;
  dynamic status;
  dynamic createdAt;

  Datum({
    this.id,
    this.title,
    this.price,
    this.image,
    this.isFreePurchase,
    this.gatewayPlanId,
    this.isMultipleTimePurchase,
    this.expiryTime,
    this.expiryTimeType,
    this.noOfListing,
    this.isImage,
    this.noOfImgPerListing,
    this.noOfCategoriesPerListing,
    this.isProduct,
    this.noOfProduct,
    this.noOfImgPerProduct,
    this.isVideo,
    this.isAmenities,
    this.noOfAmenitiesPerListing,
    this.isBusinessHour,
    this.seo,
    this.isMessenger,
    this.isWhatsapp,
    this.dynamicFrom,
    this.isRenew,
    this.status,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        price: json["price"] ?? "0",
        image: json["image"],
        isFreePurchase: json["is_free_purchase"],
        gatewayPlanId: json["gateway_plan_id"],
        isMultipleTimePurchase: json["is_multiple_time_purchase"],
        expiryTime: json["expiry_time"],
        expiryTimeType: json["expiry_time_type"],
        noOfListing: json["no_of_listing"],
        isImage: json["is_image"],
        noOfImgPerListing: json["no_of_img_per_listing"],
        noOfCategoriesPerListing: json["no_of_categories_per_listing"],
        isProduct: json["is_product"],
        noOfProduct: json["no_of_product"],
        noOfImgPerProduct: json["no_of_img_per_product"],
        isVideo: json["is_video"],
        isAmenities: json["is_amenities"],
        noOfAmenitiesPerListing: json["no_of_amenities_per_listing"],
        isBusinessHour: json["is_business_hour"],
        seo: json["seo"],
        isMessenger: json["is_messenger"],
        isWhatsapp: json["is_whatsapp"],
        dynamicFrom: json["dynamic_from"],
        isRenew: json["is_renew"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}
