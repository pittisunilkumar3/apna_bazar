import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:listplace/data/repositories/analytics_repo.dart';
import '../data/models/analytics_model.dart' as a;
import '../data/source/errors/check_api_status.dart';

class AnalyticController extends GetxController {
  static AnalyticController get to => Get.find<AnalyticController>();

  TextEditingController listingNameEditingCtrlr = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController fromDateEditingCtrlr = TextEditingController();
  TextEditingController toDateEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  int get page => this._page;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool isLoading = false;

  List<a.Datum> analyticList = [];
  String listingId = "";
  Future loadMore() async {
    if (isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getAnalyticList(
          listingId: this.listingId.isEmpty ? null : this.listingId,
          page: _page,
          listing_name: listingNameEditingCtrlr.text,
          from_date: fromDateEditingCtrlr.text,
          to_date: toDateEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    analyticList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future getAnalyticList(
      {required int page,
      required String listing_name,
      required String from_date,
      required String to_date,
      String? listingId,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      isLoading = true;
    }
    update();
    http.Response response = await AnalyticsRepo.getAnalyticsList(
        page: page,
        listing_title: listing_name,
        from_date: from_date,
        to_date: to_date,
        listingId: listingId);
    if (isLoadMoreRunning == false) {
      isLoading = false;
    }
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          analyticList = [
            ...analyticList,
            ...?a.AnalyticsModel.fromJson(data).data!.data
          ];
          if (isLoadMoreRunning == false) {
            isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================ticket list len: " +
                analyticList.length.toString());
          }
          update();
        } else {
          analyticList = [
            ...analyticList,
            ...?a.AnalyticsModel.fromJson(data).data!.data
          ];
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      analyticList = [];
    }
  }

}
