import '/data/models/purchase_package_model.dart' as p;
import '/data/models/frontend_listing_details_model.dart' as fLModel;

class EditListingModel {
  Data? data;

  EditListingModel({this.data});

  factory EditListingModel.fromJson(Map<String, dynamic> json) =>
      EditListingModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Listing? listing;
  p.Datum? packageInfo;
  List<BusinessHour>? businessHours;
  List<SocialLink>? socialLinks;
  List<fLModel.ListingImage>? listingImages;
  List<dynamic>? listingAminities;
  List<ListingProduct>? listingProducts;
  ListingSeo? listingSeo;

  Data({
    this.listing,
    this.packageInfo,
    this.businessHours,
    this.socialLinks,
    this.listingImages,
    this.listingAminities,
    this.listingProducts,
    this.listingSeo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        listing:
            json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        packageInfo: json["package_info"] == null
            ? null
            : p.Datum.fromJson(json["package_info"]),
        businessHours: json["business_hours"] == null
            ? []
            : List<BusinessHour>.from(
                json["business_hours"]!.map((x) => BusinessHour.fromJson(x))),
        socialLinks: json["social_links"] == null
            ? []
            : List<SocialLink>.from(
                json["social_links"]!.map((x) => SocialLink.fromJson(x))),
        listingImages: json["listing_images"] == null
            ? []
            : List<fLModel.ListingImage>.from(
                json["listing_images"]!.map((x) =>fLModel. ListingImage.fromJson(x))),
        listingAminities: json["listing_aminities"] == null
            ? []
            : List<int>.from(json["listing_aminities"]!.map((x) => x)),
        listingProducts: json["listing_products"] == null
            ? []
            : List<ListingProduct>.from(json["listing_products"]!
                .map((x) => ListingProduct.fromJson(x))),
        listingSeo: json["listing_seo"] == null
            ? null
            : ListingSeo.fromJson(json["listing_seo"]),
      );
}

class BusinessHour {
  dynamic id;
  dynamic listingId;
  dynamic workingDay;
  dynamic startTime;
  dynamic endTime;

  BusinessHour({
    this.id,
    this.listingId,
    this.workingDay,
    this.startTime,
    this.endTime,
  });

  factory BusinessHour.fromJson(Map<String, dynamic> json) => BusinessHour(
        id: json["id"],
        listingId: json["listing_id"],
        workingDay: json["working_day"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );
}

class Listing {
  dynamic id;
  dynamic userId;
  List<dynamic>? categoryId;
  dynamic purchasePackageId;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic title;
  dynamic slug;
  dynamic email;
  dynamic phone;
  dynamic description;
  dynamic lat;
  dynamic long;
  dynamic youtubeVideoId;
  dynamic thumbnail;
  dynamic status;
  dynamic isActive;
  dynamic fbAppId;
  dynamic fbPageId;
  dynamic whatsappNumber;
  dynamic repliesText;
  dynamic bodyText;

  Listing({
    this.id,
    this.userId,
    this.categoryId,
    this.purchasePackageId,
    this.countryId,
    this.stateId,
    this.cityId,
    this.title,
    this.slug,
    this.email,
    this.phone,
    this.description,
    this.lat,
    this.long,
    this.youtubeVideoId,
    this.thumbnail,
    this.status,
    this.isActive,
    this.fbAppId,
    this.fbPageId,
    this.whatsappNumber,
    this.repliesText,
    this.bodyText,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"] == null
            ? []
            : List<dynamic>.from(json["category_id"]),
        purchasePackageId: json["purchase_package_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        title: json["title"],
        slug: json["slug"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        lat: json["lat"],
        long: json["long"],
        youtubeVideoId: json["youtube_video_id"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        isActive: json["is_active"],
        fbAppId: json["fb_app_id"],
        fbPageId: json["fb_page_id"],
        whatsappNumber: json["whatsapp_number"],
        repliesText: json["replies_text"],
        bodyText: json["body_text"],
      );
}


class ListingProduct {
  dynamic id;
  dynamic userId;
  dynamic listingId;
  dynamic productTitle;
  dynamic productPrice;
  dynamic productDescription;
  dynamic productThumbnail;
  List<ProductImage>? productImages;

  ListingProduct({
    this.id,
    this.userId,
    this.listingId,
    this.productTitle,
    this.productPrice,
    this.productDescription,
    this.productThumbnail,
    this.productImages,
  });

  factory ListingProduct.fromJson(Map<String, dynamic> json) => ListingProduct(
        id: json["id"],
        userId: json["user_id"],
        listingId: json["listing_id"],
        productTitle: json["product_title"],
        productPrice: json["product_price"],
        productDescription: json["product_description"],
        productThumbnail: json["product_thumbnail"],
        productImages: json["product_images"] == null
            ? []
            : List<ProductImage>.from(
                json["product_images"]!.map((x) => ProductImage.fromJson(x))),
      );
}

class ProductImage {
  dynamic id;
  dynamic productImage;

  ProductImage({
    this.id,
    this.productImage,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productImage: json["product_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
      };
}

class ListingSeo {
  dynamic id;
  dynamic metaTitle;
  dynamic metaKeywords;
  dynamic metaRobots;
  dynamic metaDescription;
  dynamic ogDescription;
  dynamic seoImage;

  ListingSeo({
    this.id,
    this.metaTitle,
    this.metaKeywords,
    this.metaRobots,
    this.metaDescription,
    this.ogDescription,
    this.seoImage,
  });

  factory ListingSeo.fromJson(Map<String, dynamic> json) => ListingSeo(
        id: json["id"],
        metaTitle: json["meta_title"],
        metaKeywords: json["meta_keywords"],
        metaRobots: json["meta_robots"],
        metaDescription: json["meta_description"],
        ogDescription: json["og_description"],
        seoImage: json["seo_image"],
      );
}


class SocialLink {
  dynamic id;
  dynamic listingId;
  dynamic socialIcon;
  dynamic socialUrl;

  SocialLink({
    this.id,
    this.listingId,
    this.socialIcon,
    this.socialUrl,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        id: json["id"],
        listingId: json["listing_id"],
        socialIcon: json["social_icon"],
        socialUrl: json["social_url"],
      );
}
