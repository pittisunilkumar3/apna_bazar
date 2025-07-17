class LanguageModel {
  Data? data;

  LanguageModel({this.data});

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Language>? languages;

  Data({this.languages});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: json["languages"] == null
            ? []
            : List<Language>.from(
                json["languages"]!.map((x) => Language.fromJson(x))),
      );
}

class Language {
  dynamic id;
  dynamic name;
  dynamic shortName;
  dynamic flag;

  Language({this.id, this.name, this.shortName, this.flag});

  factory Language.fromJson(Map<String, dynamic> json) => Language(
      id: json["id"],
      name: json["name"],
      shortName: json["short_name"],
      flag: json["flag"]);
}
