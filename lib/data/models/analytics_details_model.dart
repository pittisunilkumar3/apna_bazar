

class AnalyticsDetailsModel {
    List<Datum>? data;

    AnalyticsDetailsModel({
        this.data,
    });

    factory AnalyticsDetailsModel.fromJson(Map<String, dynamic> json) => AnalyticsDetailsModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

}

class Datum {
    dynamic id;
    dynamic listingOwnerId;
    dynamic listingId;
    dynamic visitorIp;
    dynamic country;
    dynamic city;
    dynamic code;
    dynamic osPlatform;
    dynamic browser;
    dynamic createdAt;

    Datum({
        this.id,
        this.listingOwnerId,
        this.listingId,
        this.visitorIp,
        this.country,
        this.city,
        this.code,
        this.osPlatform,
        this.browser,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        listingOwnerId: json["listing_owner_id"],
        listingId: json["listing_id"],
        visitorIp: json["visitor_ip"],
        country: json["country"],
        city: json["city"],
        code: json["code"],
        osPlatform: json["os_platform"],
        browser: json["browser"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

}
