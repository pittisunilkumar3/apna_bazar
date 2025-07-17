import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/network/api_client.dart';

class DashboardRepo {
  static Future<http.Response> dashboard() async =>
      await ApiClient.get(ENDPOINT_URL: AppConstants.dashboard);
}