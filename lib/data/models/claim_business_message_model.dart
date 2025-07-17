class ClaimBusinessMessageModel {
  Data? data;

  ClaimBusinessMessageModel({
    this.data,
  });

  factory ClaimBusinessMessageModel.fromJson(Map<String, dynamic> json) =>
      ClaimBusinessMessageModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  dynamic id;
  dynamic claimById;
  dynamic listingId;
  dynamic listingOwnerId;
  dynamic uuid;
  dynamic isChatEnable;
  dynamic isChatStart;
  dynamic status;
  dynamic isListingAuthor;
  dynamic createdAt;
  List<ConversationPerson>? conversationPerson;
  Listing? listing;
  ListingClientClass? listingOwner;
  ListingClientClass? listingClient;
  List<Message>? messages;

  Data({
    this.id,
    this.claimById,
    this.listingId,
    this.listingOwnerId,
    this.uuid,
    this.isChatEnable,
    this.isChatStart,
    this.status,
    this.isListingAuthor,
    this.createdAt,
    this.conversationPerson,
    this.listing,
    this.listingOwner,
    this.listingClient,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        claimById: json["claim_by_id"],
        listingId: json["listing_id"],
        listingOwnerId: json["listing_owner_id"],
        uuid: json["uuid"],
        isChatEnable: json["is_chat_enable"],
        isChatStart: json["is_chat_start"],
        status: json["status"],
        isListingAuthor: json["isListingAuthor"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        conversationPerson: json["conversation_person"] == null
            ? []
            : List<ConversationPerson>.from(json["conversation_person"]!
                .map((x) => ConversationPerson.fromJson(x))),
        listing:
            json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        listingOwner: json["listing_owner"] == null
            ? null
            : ListingClientClass.fromJson(json["listing_owner"]),
        listingClient: json["listing_client"] == null
            ? null
            : ListingClientClass.fromJson(json["listing_client"]),
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
      );
}

class ConversationPerson {
  dynamic id;
  dynamic username;
  dynamic imgPath;

  ConversationPerson({
    this.id,
    this.username,
    this.imgPath,
  });

  factory ConversationPerson.fromJson(Map<String, dynamic> json) =>
      ConversationPerson(
        id: json["id"],
        username: json["username"],
        imgPath: json["imgPath"],
      );
}

class Listing {
  dynamic id;
  dynamic title;
  dynamic slug;
  dynamic thumbnail;
  dynamic status;
  dynamic isActive;

  Listing({
    this.id,
    this.title,
    this.slug,
    this.thumbnail,
    this.status,
    this.isActive,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        isActive: json["is_active"],
      );
}

class ListingClientClass {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic website;
  dynamic image;
  dynamic fullAddress;

  ListingClientClass({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.website,
    this.image,
    this.fullAddress,
  });

  factory ListingClientClass.fromJson(Map<String, dynamic> json) =>
      ListingClientClass(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        website: json["website"],
        image: json["image"],
        fullAddress: json["fullAddress"],
      );
}

class Message {
  dynamic id;
  dynamic userableType;
  dynamic userableId;
  dynamic title;
  dynamic description;
  dynamic createdAt;

  Message({
    this.id,
    this.userableType,
    this.userableId,
    this.title,
    this.description,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        userableType: json["userable_type"],
        userableId: json["userable_id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}
