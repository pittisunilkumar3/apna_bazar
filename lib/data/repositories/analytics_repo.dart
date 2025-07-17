import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class AnalyticsRepo {
  static Future<http.Response> getAnalyticsList({
    required int page,
    required String listing_title,
    required String from_date,
    required String to_date,
    String? listingId,
  }) async {
    if (listingId != null) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.analytics +
              "/$listingId" +
              "?page=$page&listing_title=$listing_title&from_date=$from_date&to_date=$to_date");
    } else {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.analytics +
              "?page=$page&listing_title=$listing_title&from_date=$from_date&to_date=$to_date");
    }
  }

  static Future<http.Response> analyticsDetails(
          {required int page, required String id}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.analyticsDetails + "/$id?page=$page");
}
