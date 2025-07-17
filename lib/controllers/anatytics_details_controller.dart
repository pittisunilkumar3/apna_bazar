import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:listplace/data/repositories/analytics_repo.dart';
import '../data/models/analytics_details_model.dart' as a;
import '../data/source/errors/check_api_status.dart';

class AnalyticDetailsController extends GetxController {
  static AnalyticDetailsController get to =>
      Get.find<AnalyticDetailsController>();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String id = "0";

  List<a.Datum> analyticDetailsList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await analyticsDetails(page: _page, isLoadMoreRunning: true, id: this.id);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    analyticDetailsList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future analyticsDetails(
      {required int page,
      bool? isLoadMoreRunning = false,
      required String id}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await AnalyticsRepo.analyticsDetails(page: page, id: id);
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = data['data'];
        if (fetchedData.isNotEmpty) {
          analyticDetailsList = [
            ...analyticDetailsList,
            ...?a.AnalyticsDetailsModel.fromJson(data).data
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================ticket list len: " +
                analyticDetailsList.length.toString());
          }
          update();
        } else {
          analyticDetailsList = [
            ...analyticDetailsList,
            ...?a.AnalyticsDetailsModel.fromJson(data).data
          ];
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        if (isLoadMoreRunning == false) {
          _isLoading = false;
        }
      }
    } else {
      analyticDetailsList = [];
      if (isLoadMoreRunning == false) {
        _isLoading = false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    analyticsDetails(page: _page, id: this.id);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _isLoading = false;
    analyticDetailsList.clear();
  }
}
