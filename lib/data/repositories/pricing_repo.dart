import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class PricingRepo {
  static Future<http.Response> getPackageList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.packages);

  static Future<http.Response> pricingPlanPayment({required String id}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.pricingPlanPayment + "/$id");

  static Future<http.Response> getGateways() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.gateways);

  static Future<http.Response> manualPayment(
          {required String trxid,
          required Iterable<http.MultipartFile>? fileList,
          required Map<String, String> fields}) async =>
      await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.manualPaymentUrl + "/$trxid",
          fields: fields,
          fileList: fileList);

  static Future<http.Response> webviewPayment({required String trxId}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.webviewPayment + "/$trxId");

  static Future<http.Response> addFundRequest(
          {required Map<String, String> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.paymentRequest, fields: fields);

  static Future<http.Response> cardPayment(
          {required Map<String, String> fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.cardPayment, fields: fields);

  static Future<http.Response> onPaymentDone({required String trxId}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.onPaymentDone, fields: {"trx_id": trxId});
}
