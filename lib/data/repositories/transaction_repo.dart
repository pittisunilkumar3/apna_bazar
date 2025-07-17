import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class TransactionRepo {
  static Future<http.Response> getTransactionList({
    required int page,
    required String transaction_id,
    required String date,
    required String remark,
  }) async => await ApiClient.get(
        ENDPOINT_URL: AppConstants.transactionUrl +
            "?page=$page&transaction_id=$transaction_id&date=$date&remark=$remark");
}
