import 'package:http/http.dart' as http;
import 'package:listplace/utils/services/localstorage/hive.dart';
import '../../controllers/bindings/controller_index.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_constants.dart';
import '../../utils/services/localstorage/keys.dart';
import '../source/network/api_client.dart';

class FrontendListingRepo {
  static Future<http.Response> getFrontendListngList({
    required int page,
    required String search,
    required String country_id,
    required String city_id,
    String? categoryId,
  }) async {
    // Check if the user authenticated or not
    String apiUrl = HiveHelp.read(Keys.token) != null
        ? AppConstants.frontendListingList
        : AppConstants.frontendListingListWithoutAuth;
    if (categoryId != null && categoryId.isNotEmpty) {
      return await ApiClient.get(
          ENDPOINT_URL: apiUrl +
              "/$categoryId" +
              "?page=$page&search=$search&country_id=$country_id&city_id=$city_id");
    } else {
      return await ApiClient.get(
          ENDPOINT_URL: apiUrl +
              "?page=$page&search=$search&country_id=$country_id&city_id=$city_id");
    }
  }

  static Future<http.Response> getFrontendListingDetailsList(
          {required String slug}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.frontendListingDetailsList + "/$slug");

  static Future<http.Response> getAuthorProfile(
          {required String userName}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.authorProfile + "/$userName");

  static Future<http.Response> addReview({Map<String, dynamic>? fields}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.addReview, fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> claimBusinessSubmit(
      {Map<String, dynamic>? fields, required String listingId}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.claimBusinessSubmit + "/$listingId",
          fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> listingMsgSubmit(
      {Map<String, dynamic>? fields, required String listingId}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.listingMsgSubmit + "/$listingId",
          fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> querySubmit(
      {Map<String, dynamic>? fields}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.querySubmit, fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> msgToAuthor(
      {Map<String, dynamic>? fields, required String authorId}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.msgToAuthor + "/$authorId",
          fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> followToAuthor(
      {Map<String, dynamic>? fields, required String authorId}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.post(
          ENDPOINT_URL: AppConstants.followToAuthor + "/$authorId",
          fields: fields);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }

  static Future<http.Response> submitListingFormData(
      {Map<String, String>? fields,
      Iterable<http.MultipartFile>? fileList}) async {
    if (HiveHelp.read(Keys.token) != null) {
      return await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.submitListingFormData,
          fields: fields,
          fileList: fileList);
    } else {
      Get.toNamed(RoutesName.loginScreen);
      return http.Response(
          'Log in to continue exploring and access more features.', 401);
    }
  }
}
