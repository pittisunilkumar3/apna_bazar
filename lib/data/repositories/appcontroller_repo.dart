import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class AppControllerRepo {
  static Future<http.Response> getLanguageById({required String id}) async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.languageUrl + '?id=$id');
}
