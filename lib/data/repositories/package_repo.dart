import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class PackageRepo {
  static Future<http.Response> getPackageList({
    required int page,
    required String name,
    required String purchase_date,
    required String expire_date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.purchasePackage +
              "?page=$page&name=$name&purchase_date=$purchase_date&expire_date=$expire_date");

  static Future<http.Response> getPaymentHistoryList({
    required String id,
    required int page,
    required String transaction_id,
    required String remark,
    required String date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.paymentHistoryList +
              "/$id" +
              "?page=$page&transaction_id=$transaction_id&remark=$remark&date=$date");
}
