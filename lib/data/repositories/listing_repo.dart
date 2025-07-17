import 'package:http/http.dart' as http;
import 'package:listplace/controllers/manage_listing_controller.dart';
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ListingRepo {
  static Future<http.Response> getPurchasePackage() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.purchasePackage);

  static Future<http.Response> getListingCategories() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.listingCategories);

  static Future<http.Response> getCountryList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.countryList);

  static Future<http.Response> getAmenitiesList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.amenitiesList);

  static Future<http.Response> getStateList(
          {required String countryId}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.stateList + "/$countryId");

  static Future<http.Response> geteditListing(
          {required String listingId}) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.editListing + "/$listingId");

  static Future<http.Response> getDynamicFormData(
          {required String listingId, required int page}) async =>
      await ApiClient.get(
        ENDPOINT_URL:
            AppConstants.getDynamicFormData + "/$listingId" + "?page=$page",
      );

  static Future<http.Response> getCityList(
      {required String StateId, bool? isAllCities = false}) async {
    if (isAllCities == true) {
      return await ApiClient.get(ENDPOINT_URL: AppConstants.allCityList);
    } else {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.cityList + "/$StateId");
    }
  }

  static Future<http.Response> getMyListings({
    required int page,
    required String name,
  }) async {
    Uri uri = Uri.parse(AppConstants.myListings).replace(queryParameters: {
      "page": page.toString(),
      "name": name,
      if (ManageListingController.to.selectedCategoryIdList.isNotEmpty)
        for (int i = 0;
            i < ManageListingController.to.selectedCategoryIdList.length;
            i++)
          "category[$i]":
              "${ManageListingController.to.selectedCategoryIdList[i]}",
    });
    return await ApiClient.get(ENDPOINT_URL: uri.toString());
  }

  static Future<http.Response> addListing(
      {String? packageId,
      String? listingId,
      Map<String, String>? fields,
      Iterable<http.MultipartFile>? fileList,
      bool? isFromUpdateListing = false}) async {
    if (isFromUpdateListing == true) {
      return await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.updateListing + "/$listingId",
          fields: fields,
          fileList: fileList);
    } else {
      return await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.addListings + "/$packageId",
          fields: fields,
          fileList: fileList);
    }
  }

  static Future<http.Response> deleteListing(
          {required String listingId}) async =>
      await ApiClient.delete(
          ENDPOINT_URL: AppConstants.deleteListing + "/$listingId");
}
