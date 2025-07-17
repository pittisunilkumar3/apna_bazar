class ProductEnquiryConvModel {
  Data? data;

  ProductEnquiryConvModel({
    this.data,
  });

  factory ProductEnquiryConvModel.fromJson(Map<String, dynamic> json) =>
      ProductEnquiryConvModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  dynamic id;
  dynamic userId;
  dynamic clientId;
  dynamic listingId;
  dynamic productId;
  dynamic message;
  dynamic customerEnquiry;
  dynamic myEnquiry;
  dynamic createdAt;
  Listing? listing;
  Product? product;
  Client? user;
  Client? client;
  List<Reply>? replies;

  Data({
    this.id,
    this.userId,
    this.clientId,
    this.listingId,
    this.productId,
    this.message,
    this.customerEnquiry,
    this.myEnquiry,
    this.createdAt,
    this.listing,
    this.product,
    this.user,
    this.client,
    this.replies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        clientId: json["client_id"],
        listingId: json["listing_id"],
        productId: json["product_id"],
        message: json["message"],
        customerEnquiry: json["customer_enquiry"],
        myEnquiry: json["my_enquiry"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        listing:
            json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        user: json["user"] == null ? null : Client.fromJson(json["user"]),
        client: json["client"] == null ? null : Client.fromJson(json["client"]),
        replies: json["replies"] == null
            ? []
            : List<Reply>.from(json["replies"]!.map((x) => Reply.fromJson(x))),
      );
}

class Client {
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic website;
  dynamic email;
  dynamic address;
  dynamic imgPath;

  Client({
    this.firstname,
    this.lastname,
    this.username,
    this.website,
    this.email,
    this.address,
    this.imgPath,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        website: json["website"],
        email: json["email"],
        address: json["address"],
        imgPath: json["imgPath"],
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

class Product {
  dynamic title;
  dynamic price;
  dynamic thumbnail;

  Product({
    this.title,
    this.price,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        title: json["title"],
        price: json["price"] ?? "0",
        thumbnail: json["thumbnail"],
      );
}

class Reply {
  dynamic id;
  dynamic userId;
  dynamic clientId;
  dynamic reply;
  dynamic file;
  dynamic status;
  dynamic createdAt;
  dynamic sentAt;

  Reply({
    this.id,
    this.userId,
    this.clientId,
    this.reply,
    this.file,
    this.status,
    this.createdAt,
    this.sentAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        userId: json["user_id"],
        clientId: json["client_id"],
        reply: json["reply"],
        file: json["file"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        sentAt: json["sent_at"],
      );
}
