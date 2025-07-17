class FrontendListingDetailsModel {
  Data? data;

  FrontendListingDetailsModel({
    this.data,
  });

  factory FrontendListingDetailsModel.fromJson(Map<String, dynamic> json) =>
      FrontendListingDetailsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  dynamic id;
  dynamic userId;
  dynamic current_url;
  dynamic categories;
  dynamic purchasePackageId;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic title;
  dynamic slug;
  dynamic email;
  dynamic phone;
  dynamic description;
  dynamic address;
  dynamic lat;
  dynamic long;
  dynamic youtubeVideoId;
  dynamic thumbnail;
  dynamic status;
  dynamic totalListingViews;
  dynamic reviewDone;
  dynamic isActive;
  dynamic whatsappNumber;
  dynamic repliesText;
  dynamic bodyText;
  dynamic createdAt;
  dynamic averageRating;
  List<ListingImage>? listingImages;
  List<ListingAmenity>? listingAmenities;
  List<GetProduct>? getProducts;
  List<GetBusinessHour>? getBusinessHour;
  List<GetSocialInfo>? getSocialInfo;
  List<GetReview>? getReviews;
  Package? package;
  User? user;

  Data({
    this.id,
    this.userId,
    this.current_url,
    this.categories,
    this.purchasePackageId,
    this.countryId,
    this.stateId,
    this.cityId,
    this.title,
    this.slug,
    this.email,
    this.phone,
    this.description,
    this.address,
    this.lat,
    this.long,
    this.youtubeVideoId,
    this.thumbnail,
    this.status,
    this.totalListingViews,
    this.reviewDone,
    this.isActive,
    this.whatsappNumber,
    this.repliesText,
    this.bodyText,
    this.createdAt,
    this.averageRating,
    this.listingImages,
    this.listingAmenities,
    this.getProducts,
    this.getBusinessHour,
    this.getSocialInfo,
    this.getReviews,
    this.package,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        current_url: json["current_url"],
        categories: json["categories"],
        purchasePackageId: json["purchase_package_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        title: json["title"],
        slug: json["slug"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        youtubeVideoId: json["youtube_video_id"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        totalListingViews: json["total_listing_views"],
        reviewDone: json["reviewDone"],
        isActive: json["is_active"],
        whatsappNumber: json["whatsapp_number"],
        repliesText: json["replies_text"],
        bodyText: json["body_text"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        averageRating: json["average_rating"] ?? 0,
        listingImages: json["listing_images"] == null
            ? []
            : List<ListingImage>.from(
                json["listing_images"]!.map((x) => ListingImage.fromJson(x))),
        listingAmenities: json["listing_amenities"] == null
            ? []
            : List<ListingAmenity>.from(json["listing_amenities"]!
                .map((x) => ListingAmenity.fromJson(x))),
        getProducts: json["get_products"] == null
            ? []
            : List<GetProduct>.from(
                json["get_products"]!.map((x) => GetProduct.fromJson(x))),
        getBusinessHour: json["get_business_hour"] == null
            ? []
            : List<GetBusinessHour>.from(json["get_business_hour"]!
                .map((x) => GetBusinessHour.fromJson(x))),
        getSocialInfo: json["get_social_info"] == null
            ? []
            : List<GetSocialInfo>.from(
                json["get_social_info"]!.map((x) => GetSocialInfo.fromJson(x))),
        getReviews: json["get_reviews"] == null
            ? []
            : List<GetReview>.from(
                json["get_reviews"]!.map((x) => GetReview.fromJson(x))),
        package:
            json["package"] == null ? null : Package.fromJson(json["package"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
}

class GetBusinessHour {
  dynamic id;
  dynamic workingDay;
  dynamic startTime;
  dynamic endTime;

  GetBusinessHour({
    this.id,
    this.workingDay,
    this.startTime,
    this.endTime,
  });

  factory GetBusinessHour.fromJson(Map<String, dynamic> json) =>
      GetBusinessHour(
        id: json["id"],
        workingDay: json["working_day"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );
}

class GetProduct {
  dynamic id;
  dynamic productTitle;
  dynamic productPrice;
  dynamic productDescription;
  dynamic productThumbnail;
  List<ProductImage>? productImage;

  GetProduct({
    this.id,
    this.productTitle,
    this.productPrice,
    this.productDescription,
    this.productThumbnail,
    this.productImage,
  });

  factory GetProduct.fromJson(Map<String, dynamic> json) => GetProduct(
        id: json["id"],
        productTitle: json["product_title"],
        productPrice: json["product_price"],
        productDescription: json["product_description"],
        productThumbnail: json["product_thumbnail"],
        productImage: json["product_image"] == null
            ? []
            : List<ProductImage>.from(
                json["product_image"]!.map((x) => ProductImage.fromJson(x))),
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
}

class GetSocialInfo {
  dynamic id;
  dynamic socialIcon;
  dynamic socialUrl;
  dynamic userId;

  GetSocialInfo({
    this.id,
    this.socialIcon,
    this.socialUrl,
    this.userId,
  });

  factory GetSocialInfo.fromJson(Map<String, dynamic> json) => GetSocialInfo(
        id: json["id"],
        socialIcon: json["social_icon"],
        socialUrl: json["social_url"],
        userId: json["user_id"],
      );
}

class ListingAmenity {
  dynamic id;
  dynamic amenityId;
  dynamic title;
  dynamic icon;
  dynamic status;

  ListingAmenity({
    this.id,
    this.amenityId,
    this.title,
    this.icon,
    this.status,
  });

  factory ListingAmenity.fromJson(Map<String, dynamic> json) => ListingAmenity(
        id: json["id"],
        amenityId: json["amenity_id"],
        title: json["title"],
        icon: json["icon"],
        status: json["status"],
      );
}

class ListingImage {
  dynamic id;
  dynamic listingImage;

  ListingImage({
    this.id,
    this.listingImage,
  });

  factory ListingImage.fromJson(Map<String, dynamic> json) => ListingImage(
        id: json["id"],
        listingImage: json["listing_image"],
      );
}

class Package {
  dynamic id;
  dynamic packageId;
  dynamic isVideo;
  dynamic isProduct;
  dynamic isWhatsapp;
  dynamic isMessenger;

  Package({
    this.id,
    this.packageId,
    this.isVideo,
    this.isProduct,
    this.isWhatsapp,
    this.isMessenger,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        packageId: json["package_id"],
        isVideo: json["is_video"],
        isProduct: json["is_product"],
        isWhatsapp: json["is_whatsapp"],
        isMessenger: json["is_messenger"],
      );
}

class User {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic website;
  dynamic languageId;
  dynamic email;
  dynamic countryCode;
  dynamic country;
  dynamic phoneCode;
  dynamic phone;
  dynamic coverImage;
  dynamic image;
  dynamic addressOne;
  dynamic addressTwo;
  dynamic bio;
  dynamic followerCount;
  dynamic totalListingsAnUser;
  List<GetSocialInfo>? socialLinks;
  dynamic created_at;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.website,
    this.languageId,
    this.email,
    this.countryCode,
    this.country,
    this.phoneCode,
    this.phone,
    this.coverImage,
    this.image,
    this.addressOne,
    this.addressTwo,
    this.bio,
    this.followerCount,
    this.totalListingsAnUser,
    this.socialLinks,
    this.created_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        website: json["website"],
        languageId: json["language_id"],
        email: json["email"],
        countryCode: json["country_code"],
        country: json["country"],
        phoneCode: json["phone_code"],
        phone: json["phone"],
        coverImage: json["cover_image"],
        image: json["image"],
        addressOne: json["address_one"],
        addressTwo: json["address_two"],
        bio: json["bio"],
        followerCount: json["follower_count"],
        totalListingsAnUser: json["total_listings_an_user"],
        created_at: json["created_at"],
        socialLinks: json["social_links"] == null
            ? []
            : List<GetSocialInfo>.from(
                json["social_links"]!.map((x) => GetSocialInfo.fromJson(x))),
      );
}

class GetReview {
  dynamic id;
  dynamic userId;
  dynamic rating;
  dynamic review;
  dynamic username;
  dynamic image;
  dynamic createdAt;

  GetReview({
    this.id,
    this.userId,
    this.rating,
    this.review,
    this.username,
    this.image,
    this.createdAt,
  });

  factory GetReview.fromJson(Map<String, dynamic> json) => GetReview(
        id: json["id"],
        userId: json["user_id"],
        rating: json["rating"],
        review: json["review"],
        username: json["username"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}
