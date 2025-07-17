class AuthorProfileModel {
  Data? data;

  AuthorProfileModel({
    this.data,
  });

  factory AuthorProfileModel.fromJson(Map<String, dynamic> json) =>
      AuthorProfileModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic bio;
  dynamic website;
  dynamic email;
  dynamic coverImage;
  dynamic image;
  dynamic address;
  dynamic status;
  dynamic checkFollowing;
  dynamic createdAt;
  dynamic totalListing;
  dynamic totalViews;
  dynamic totalFollower;
  dynamic totalFollowing;
  List<FollowInfo>? followerInfo;
  List<FollowInfo>? followingInfo;
  List<SocialLink>? socialLinks;

  Data({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.bio,
    this.website,
    this.email,
    this.coverImage,
    this.image,
    this.address,
    this.status,
    this.checkFollowing,
    this.createdAt,
    this.totalListing,
    this.totalViews,
    this.totalFollower,
    this.totalFollowing,
    this.followerInfo,
    this.followingInfo,
    this.socialLinks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        bio: json["bio"],
        website: json["website"],
        email: json["email"],
        coverImage: json["cover_image"],
        image: json["image"],
        address: json["address"],
        status: json["status"],
        checkFollowing: json["check_following"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        totalListing: json["total_listing"] ?? "0",
        totalViews: json["total_views"] ?? "0",
        totalFollower: json["total_follower"] ?? "0",
        totalFollowing: json["total_following"] ?? "0",
        followerInfo: json["follower_info"] == null
            ? []
            : List<FollowInfo>.from(
                json["follower_info"]!.map((x) => FollowInfo.fromJson(x))),
        followingInfo: json["following_info"] == null
            ? []
            : List<FollowInfo>.from(
                json["following_info"]!.map((x) => FollowInfo.fromJson(x))),
        socialLinks: json["social_links"] == null
            ? []
            : List<SocialLink>.from(
                json["social_links"]!.map((x) => SocialLink.fromJson(x))),
      );
}

class FollowInfo {
  dynamic id;
  dynamic userId;
  dynamic followingId;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic coverImage;
  dynamic image;
  dynamic createdAt;

  FollowInfo({
    this.id,
    this.userId,
    this.followingId,
    this.firstname,
    this.lastname,
    this.username,
    this.coverImage,
    this.image,
    this.createdAt,
  });

  factory FollowInfo.fromJson(Map<String, dynamic> json) => FollowInfo(
        id: json["id"],
        userId: json["user_id"],
        followingId: json["following_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        coverImage: json["cover_image"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );
}

class SocialLink {
  dynamic socialIcon;
  dynamic socialUrl;

  SocialLink({
    this.socialIcon,
    this.socialUrl,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        socialIcon: json["social_icon"],
        socialUrl: json["social_url"],
      );
}
