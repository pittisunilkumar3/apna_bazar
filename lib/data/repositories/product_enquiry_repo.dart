import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ProductEnquiryRepo {
  static Future<http.Response> getProductEnquiryList({
    required int page,
    required String name,
    required String from_date,
    required String to_date,
    required String enquiryType,
  }) async =>
      await ApiClient.get(
          ENDPOINT_URL: AppConstants.productEnquiry +
              "/$enquiryType-enquiry" +
              "?page=$page&name=$name&from_date=$from_date&to_date=$to_date");

  static Future<http.Response> getProductEnquiryConvList(
          {required String id}) async =>
      await ApiClient.get(
          ENDPOINT_URL:
              AppConstants.productEnquiryConvList + "/$id");
  
    static Future<http.Response> productEnquiryConvConversationReply({Map<String, String>? fields,http.MultipartFile? files}) async =>
      await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.productEnquiryReply,fields: fields,files:files );

  static Future<http.Response> deleteProductEnqu({required String id}) async =>
      await ApiClient.delete(
          ENDPOINT_URL: AppConstants.productEnquiryDelete + "/$id");
}
