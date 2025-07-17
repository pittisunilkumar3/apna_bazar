

class TicketListModel {
    Data? data;

    TicketListModel({
        this.data,
    });

    factory TicketListModel.fromJson(Map<String, dynamic> json) => TicketListModel(
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
    dynamic  id;
    dynamic userId;
    dynamic ticket;
    dynamic subject;
    dynamic status;
    dynamic  lastReply;

    Datum({
        this.id,
        this.userId,
        this.ticket,
        this.subject,
        this.status,
        this.lastReply,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        ticket: json["ticket"],
        subject: json["subject"],
        status: json["status"],
        lastReply: json["last_reply"] == null ? null : DateTime.parse(json["last_reply"]),
    );

}
