import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class ProfileRepo {
  static Future<http.Response> getProfile() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.profileUrl);

  static Future<http.Response> getLanguageList() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.languageUrl);

  static Future<http.Response> profileUpdate(
          {required Map<String, dynamic> data}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.profileUpdateUrl, fields: data);

  static Future<http.Response> profilePassUpdate(
          {required Map<String, dynamic> data}) async =>
      await ApiClient.post(
          ENDPOINT_URL: AppConstants.profilePassUpdateUrl, fields: data);

  static Future<http.Response> profileImageUpload(
          {required MultipartFile files, Map<String, String>? fields}) async =>
      await ApiClient.postMultipart(
          ENDPOINT_URL: AppConstants.profileUpdateUrl,
          files: files,
          fields: fields);

  static Future<http.Response> deleteAccount({required String userId}) async =>
      await ApiClient.delete(ENDPOINT_URL: AppConstants.deleteAccountUrl+"/$userId");
}
