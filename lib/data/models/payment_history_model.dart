

class PaymentHistoryModel {
    Data? data;

    PaymentHistoryModel({
        this.data,
    });

    factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
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
    dynamic paymentMethodId;
    dynamic paymentMethodName;
    dynamic paymentMethodImage;
    dynamic amount;
    dynamic trxId;
    dynamic purchaseType;
    dynamic purchaseItemName;
    dynamic remark;
    dynamic status;
    dynamic createdAt;

    Datum({
        this.id,
        this.userId,
        this.paymentMethodId,
        this.paymentMethodName,
        this.paymentMethodImage,
        this.amount,
        this.trxId,
        this.purchaseType,
        this.purchaseItemName,
        this.remark,
        this.status,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        paymentMethodId: json["payment_method_id"],
        paymentMethodName: json["payment_method_name"],
        paymentMethodImage: json["payment_method_image"],
        amount: json["amount"],
        trxId: json["trx_id"],
        purchaseType: json["purchase_type"],
        purchaseItemName: json["purchase_item_name"],
        remark: json["remark"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

}
