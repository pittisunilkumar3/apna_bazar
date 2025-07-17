import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../routes/routes_name.dart';
import '../../utils/app_constants.dart';
import '../../utils/services/localstorage/hive.dart';
import '../../utils/services/localstorage/keys.dart';
import '../source/network/api_client.dart';

class WishlistRepo {
  static Future<http.Response> getwishlist({
    required int page,
    required String listing_name,
    required String from_date,
    required String to_date,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.wishlist +
              "?page=$page&listing_name=$listing_name&from_date=$from_date&to_date=$to_date");

  static Future<http.Response> addWishlist(
      {Map<String, dynamic>? fields}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          fields: fields, ENDPOINT_URL: AppConstants.addWishlist);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }
}
