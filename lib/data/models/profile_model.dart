class ProfileModel {
  Data? data;

  ProfileModel({
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Profile? profile;

  Data({
    this.profile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );
}

class Profile {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic languageId;
  dynamic address_one;
  dynamic address_two;
  dynamic phone;
  dynamic phoneCode;
  dynamic country;
  dynamic countryCode;
  dynamic image;
  dynamic created_at;

  Profile({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.languageId,
    this.address_one,
    this.address_two,
    this.phone,
    this.phoneCode,
    this.country,
    this.countryCode,
    this.image,
    this.created_at,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        languageId: json["language_id"],
        address_one: json["address_one"],
        address_two: json["address_two"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        country: json["country"],
        countryCode: json["country_code"],
        image: json["image"],
        created_at: json["joined_at"].toString(),
      );
}
