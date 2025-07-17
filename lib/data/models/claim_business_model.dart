class ClaimBusinessModel {
  Data? data;

  ClaimBusinessModel({
    this.data,
  });

  factory ClaimBusinessModel.fromJson(Map<String, dynamic> json) =>
      ClaimBusinessModel(
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
  dynamic claimById;
  dynamic listingId;
  dynamic listingOwnerId;
  dynamic uuid;
  dynamic isChatStart;
  dynamic status;
  dynamic createdAt;
  Listing? listing;
  ListingClaimerClass? listingOwner;
  ListingClaimerClass? listingClaimer;

  Datum({
    this.id,
    this.claimById,
    this.listingId,
    this.listingOwnerId,
    this.uuid,
    this.isChatStart,
    this.status,
    this.createdAt,
    this.listing,
    this.listingOwner,
    this.listingClaimer,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        claimById: json["claim_by_id"],
        listingId: json["listing_id"],
        listingOwnerId: json["listing_owner_id"],
        uuid: json["uuid"],
        isChatStart: json["is_chat_start"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        listing:
            json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        listingOwner: json["listing_owner"] == null
            ? null
            : ListingClaimerClass.fromJson(json["listing_owner"]),
        listingClaimer: json["listing_claimer"] == null
            ? null
            : ListingClaimerClass.fromJson(json["listing_claimer"]),
      );
}

class Listing {
  dynamic title;
  dynamic slug;

  Listing({
    this.title,
    this.slug,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        title: json["title"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
      };
}

class ListingClaimerClass {
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic image;

  ListingClaimerClass({
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.image,
  });

  factory ListingClaimerClass.fromJson(Map<String, dynamic> json) =>
      ListingClaimerClass(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        image: json["image"],
      );
}
