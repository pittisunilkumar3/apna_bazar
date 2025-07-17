import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ClaimBusinessRepo {
  static Future<http.Response> getClaimBusinessList({
    required int page,
    required String from_date,
    required String to_date,
    required String claimType,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.claimBusiness +
              "/$claimType-claim?" +
              "?page=$page&from_date=$from_date&to_date=$to_date");

  static Future<http.Response> getClaimBusinessConversation({
    required String uuid,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.claimBusinessConversation + "/$uuid");

  static Future<http.Response> claimBusinessConversationReply({Map<String, dynamic>? fields}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.claimBusinessConversationReply,fields: fields);
}
