

class AnalyticsModel {
    Data? data;

    AnalyticsModel({
        this.data,
    });

    factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
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
    dynamic listingOwnerId;
    dynamic listingId;
    dynamic visitorIp;
    dynamic country;
    dynamic listingTitle;
    dynamic totalVisit;
    dynamic lastVisited;

    Datum({
        this.id,
        this.listingOwnerId,
        this.listingId,
        this.visitorIp,
        this.country,
        this.listingTitle,
        this.totalVisit,
        this.lastVisited,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        listingOwnerId: json["listing_owner_id"],
        listingId: json["listing_id"],
        visitorIp: json["visitor_ip"],
        country: json["country"],
        listingTitle: json["listing_title"],
        totalVisit: json["total_visit"],
        lastVisited: json["last_visited"] == null ? null : DateTime.parse(json["last_visited"]),
    );
}
