import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ReviewRepo {
  static Future<http.Response> getReviewList({required int page,required String listingId}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.reviews+"/$listingId" + "?page=$page");
}
