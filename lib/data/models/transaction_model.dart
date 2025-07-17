

class TransactionModel {
    Data? data;

    TransactionModel({
        this.data,
    });

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
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
    dynamic transactionalId;
    dynamic gatewayId;
  dynamic gatewayName;
 dynamic amount;
    dynamic charge;
    dynamic trxId;
    dynamic purchaseTitle;
   dynamic createdAt;

    Datum({
        this.id,
        this.transactionalId,
        this.gatewayId,
        this.gatewayName,
        this.amount,
        this.charge,
        this.trxId,
        this.purchaseTitle,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        transactionalId: json["transactional_id"],
        gatewayId: json["gateway_id"],
        gatewayName: json["gateway_name"],
        amount: json["amount"],
        charge: json["charge"]?.toDouble(),
        trxId: json["trx_id"],
        purchaseTitle: json["purchase_title"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

}
