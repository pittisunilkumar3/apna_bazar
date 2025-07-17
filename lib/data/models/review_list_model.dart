class ReviewListModel {
  Data? data;

  ReviewListModel({
    this.data,
  });

  factory ReviewListModel.fromJson(Map<String, dynamic> json) =>
      ReviewListModel(
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
  dynamic listingId;
  dynamic listingTitle;
  dynamic rating;
  dynamic avgRating;
  dynamic review;
  ReviewerInfo? reviewerInfo;
  dynamic createdAt;

  Datum({
    this.id,
    this.userId,
    this.listingId,
    this.listingTitle,
    this.rating,
    this.avgRating,
    this.review,
    this.reviewerInfo,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        listingId: json["listing_id"],
        listingTitle: json["listing_title"],
        rating: json["rating"],
        avgRating: json["avgRating"],
        review: json["review"],
        reviewerInfo: json["reviewer_info"] == null
            ? null
            : ReviewerInfo.fromJson(json["reviewer_info"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}

class ReviewerInfo {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic image;

  ReviewerInfo({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.image,
  });

  factory ReviewerInfo.fromJson(Map<String, dynamic> json) => ReviewerInfo(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        image: json["image"],
      );
}
