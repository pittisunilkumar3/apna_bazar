

class ViewTicketModel {
    Data? data;

    ViewTicketModel({
        this.data,
    });

    factory ViewTicketModel.fromJson(Map<String, dynamic> json) => ViewTicketModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );


}

class Data {
    List<Ticket>? ticket;

    Data({
        this.ticket,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        ticket: json["ticket"] == null ? [] : List<Ticket>.from(json["ticket"]!.map((x) => Ticket.fromJson(x))),
    );


}

class Ticket {
    dynamic id;
    dynamic userId;
    dynamic ticket;
    dynamic subject;
    dynamic status;
    dynamic lastReply;
    List<Message>? messages;

    Ticket({
        this.id,
        this.userId,
        this.ticket,
        this.subject,
        this.status,
        this.lastReply,
        this.messages,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        userId: json["user_id"],
        ticket: json["ticket"],
        subject: json["subject"],
        status: json["status"],
        lastReply: json["last_reply"] == null ? null : DateTime.parse(json["last_reply"]),
        messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
    );

}

class Message {
    dynamic id;
    dynamic supportTicketId;
    dynamic adminId;
    dynamic admin_image;
    dynamic message;
    dynamic created_at;
    List<Attachment>? attachments;

    Message({
        this.id,
        this.supportTicketId,
        this.adminId,
        this.admin_image,
        this.message,
        this.created_at,
        this.attachments,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        supportTicketId: json["support_ticket_id"],
        adminId: json["admin_id"],
        admin_image: json["admin_image"],
        message: json["message"],
        created_at: json["created_at"],
        attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    );


}

class Attachment {
    dynamic id;
    dynamic supportTicketMessageId;
    dynamic file;
    dynamic driver;

    Attachment({
        this.id,
        this.supportTicketMessageId,
        this.file,
        this.driver,
    });

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        supportTicketMessageId: json["support_ticket_message_id"],
        file: json["file"],
        driver: json["driver"],
    );

}
