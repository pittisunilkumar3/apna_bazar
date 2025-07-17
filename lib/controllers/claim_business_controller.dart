import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/claim_business_model.dart' as claim;
import '../data/repositories/claim_business_repo.dart';
import '../data/source/errors/check_api_status.dart';

class ClaimBusinessController extends GetxController {
  static ClaimBusinessController get to => Get.find<ClaimBusinessController>();

  TextEditingController textEditingController = TextEditingController();
  TextEditingController fromDateEditingCtrlr = TextEditingController();
  TextEditingController toDateEditingCtrlr = TextEditingController();

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late PageController pageController;
  int selectedIndex = 0;

  String claimType = "customer";

  List<claim.Datum> claimBusinessList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getClaimBusinessList(
          claimType: this.claimType,
          page: page,
          from_date: fromDateEditingCtrlr.text,
          to_date: toDateEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    claimBusinessList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getClaimBusinessList(
      {required int page,
      required String from_date,
      required String to_date,
      required String claimType,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ClaimBusinessRepo.getClaimBusinessList(
      page: page,
      from_date: from_date,
      to_date: to_date,
      claimType: claimType,
    );
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          claimBusinessList = [
            ...claimBusinessList,
            ...?claim.ClaimBusinessModel.fromJson(data).data!.data
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          claimBusinessList = [
            ...claimBusinessList,
            ...?claim.ClaimBusinessModel.fromJson(data).data!.data
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
      }
    } else {
      claimBusinessList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    claimType = "customer";
    pageController = PageController(initialPage: 0);
    getClaimBusinessList(
        page: page, claimType: claimType, from_date: '', to_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    claimBusinessList.clear();
  }
}
