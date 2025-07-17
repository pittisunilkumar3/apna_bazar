

class FrontendListingModel {
    Data? data;

    FrontendListingModel({
        this.data,
    });

    factory FrontendListingModel.fromJson(Map<String, dynamic> json) => FrontendListingModel(
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
    dynamic userId;
    dynamic purchasePackageId;
    dynamic countryId;
    dynamic stateId;
    dynamic cityId;
    dynamic title;
    dynamic slug;
    dynamic categories;
    dynamic address;
    dynamic lat;
    dynamic long;
    dynamic thumbnail;
   dynamic status;
   dynamic isActive;
   dynamic favouriteCount;
   dynamic averageRating;
   dynamic createdAt;
    User? user;

    Datum({
        this.id,
        this.userId,
        this.purchasePackageId,
        this.countryId,
        this.stateId,
        this.cityId,
        this.title,
        this.slug,
        this.categories,
        this.address,
        this.lat,
        this.long,
        this.thumbnail,
        this.status,
        this.isActive,
        this.favouriteCount,
        this.averageRating,
        this.createdAt,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        purchasePackageId: json["purchase_package_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        title: json["title"],
        slug: json["slug"],
        categories: json["categories"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        isActive: json["is_active"],
        favouriteCount: json["favourite_count"],
        averageRating: json["average_rating"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );


}

class User {
    dynamic firstname;
    dynamic lastname;
    dynamic username;

    User({
        this.firstname,
        this.lastname,
        this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
    );

  
}
