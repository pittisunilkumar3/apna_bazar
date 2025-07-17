import 'dart:convert';
import 'package:listplace/controllers/bindings/controller_index.dart';
import 'package:http/http.dart' as http;
import '../data/models/dashboard_model.dart' as dashboard;
import '../data/repositories/dashboard_repo.dart';
import '../utils/services/helpers.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find<DashboardController>();

  bool isLoading = false;
  dashboard.Data? data;

  Future getDashboard() async {
    isLoading = true;
    update();
    http.Response response = await DashboardRepo.dashboard();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        this.data = dashboard.DashboardModel.fromJson(data).data;
        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }
}
