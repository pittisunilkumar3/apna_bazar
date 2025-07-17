

class GatewayModel {
  List<Gateways>? gateways;

  GatewayModel({this.gateways});

  GatewayModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      gateways = <Gateways>[];
      json['data'].forEach((v) {
        gateways!.add(new Gateways.fromJson(v));
      });
    }
  }
}

class Gateways {
  dynamic id;
  dynamic code;
  dynamic name;
  dynamic image;
  dynamic description;
  List<dynamic>? supportedCurrency;
  List<ReceivableCurrencies>? receivableCurrencies;
  dynamic currency_type;

  Gateways(
      {this.id,
      this.code,
      this.name,
      this.image,
      this.description,
      this.supportedCurrency,
      this.receivableCurrencies,
      this.currency_type});

  Gateways.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    currency_type = json['currency_type'];
    supportedCurrency = json['supported_currency'].cast<String>();
    if (json['receivable_currencies'] != null &&
        json['receivable_currencies'] is List) {
      receivableCurrencies = <ReceivableCurrencies>[];
      json['receivable_currencies'].forEach((v) {
        receivableCurrencies!.add(new ReceivableCurrencies.fromJson(v));
      });
    }
  }

}

class ReceivableCurrencies {
  dynamic name;
  dynamic currency;
  dynamic conversionRate;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic percentageCharge;
  dynamic fixedCharge;

  ReceivableCurrencies(
      {this.name,
      this.currency,
      this.conversionRate,
      this.minLimit,
      this.maxLimit,
      this.percentageCharge,
      this.fixedCharge});

  ReceivableCurrencies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    minLimit = json['min_limit'];
    maxLimit = json['max_limit'];
    percentageCharge = json['percentage_charge'];
    fixedCharge = json['fixed_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['currency'] = this.currency;
    data['conversion_rate'] = this.conversionRate;
    data['min_limit'] = this.minLimit;
    data['max_limit'] = this.maxLimit;
    data['percentage_charge'] = this.percentageCharge;
    data['fixed_charge'] = this.fixedCharge;
    return data;
  }
}
