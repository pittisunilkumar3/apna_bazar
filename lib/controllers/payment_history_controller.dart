import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:listplace/data/repositories/package_repo.dart';
import '../data/models/payment_history_model.dart' as p;
import '../data/source/errors/check_api_status.dart';

class PaymentHistoryController extends GetxController {
  static PaymentHistoryController get to =>
      Get.find<PaymentHistoryController>();

  TextEditingController transactionEditingCtrlr = TextEditingController();
  TextEditingController remarkEditingCtrlr = TextEditingController();
  TextEditingController dateEditingCtrlr = TextEditingController();
  String id = "11";
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Datum> paymentHistoryList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getPaymentHistoryList(
          id: id,
          page: page,
          transaction_id: transactionEditingCtrlr.text,
          remark: remarkEditingCtrlr.text,
          date: dateEditingCtrlr.text,
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
    paymentHistoryList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getPaymentHistoryList(
      {required int page,
      required String id,
      required String transaction_id,
      required String remark,
      required String date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await PackageRepo.getPaymentHistoryList(
      id: id,
      page: page,
      transaction_id: transaction_id,
      remark: remark,
      date: date,
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
          paymentHistoryList = [
            ...paymentHistoryList,
            ...?p.PaymentHistoryModel.fromJson(data).data!.data
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          paymentHistoryList = [
            ...paymentHistoryList,
            ...?p.PaymentHistoryModel.fromJson(data).data!.data
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
      paymentHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPaymentHistoryList(
        id: id, page: page, transaction_id: "", remark: "", date: "");
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    paymentHistoryList.clear();
  }
}
