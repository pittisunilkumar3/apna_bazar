

class CustomerEnquiryModel {
    Data? data;

    CustomerEnquiryModel({
        this.data,
    });

    factory CustomerEnquiryModel.fromJson(Map<String, dynamic> json) => CustomerEnquiryModel(
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
    dynamic clientId;
    dynamic listingId;
    dynamic productId;
    dynamic customerEnquiry;
    dynamic myEnquiry;
    dynamic createdAt;
    Listing? listing;
    Product? product;
    ListingClientClass? listingOwner;
    ListingClientClass? listingClient;

    Datum({
        this.id,
        this.userId,
        this.clientId,
        this.listingId,
        this.productId,
        this.customerEnquiry,
        this.myEnquiry,
        this.createdAt,
        this.listing,
        this.product,
        this.listingOwner,
        this.listingClient,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        clientId: json["client_id"],
        listingId: json["listing_id"],
        productId: json["product_id"],
        customerEnquiry: json["customer_enquiry"],
        myEnquiry: json["my_enquiry"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        listing: json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        listingOwner: json["listing_owner"] == null ? null : ListingClientClass.fromJson(json["listing_owner"]),
        listingClient: json["listing_client"] == null ? null : ListingClientClass.fromJson(json["listing_client"]),
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

}

class ListingClientClass {
    dynamic firstname;
    dynamic lastname;
    dynamic username;
    dynamic email;
    dynamic imgPath;

    ListingClientClass({
        this.firstname,
        this.lastname,
        this.username,
        this.email,
        this.imgPath,
    });

    factory ListingClientClass.fromJson(Map<String, dynamic> json) => ListingClientClass(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        imgPath: json["imgPath"],
    );


}

class Product {
    dynamic title;

    Product({
        this.title,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        title: json["title"],
    );

}
