import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/transaction_model.dart' as t;
import '../data/repositories/transaction_repo.dart';
import '../data/source/errors/check_api_status.dart';

class TransactionController extends GetxController {
  static TransactionController get to => Get.find<TransactionController>();

  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController dateEditingCtrlr = TextEditingController();
  TextEditingController remarkEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<t.Datum> transactionList = [];
  Future loadMore() async {
    if (_canLoadMore()) {
      isLoadMore = true;
      update();
      page += 1;
      await getTransactionList(
          page: page,
          transaction_id: transactionIdEditingCtrlr.text,
          date: dateEditingCtrlr.text,
          remark: remarkEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool _canLoadMore() {
    return !_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300;
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    transactionList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getTransactionList({
    required int page,
    required String transaction_id,
    required String date,
    required String remark,
    bool isFromWallet = false,
    bool isLoadMoreRunning = false,
  }) async {
    if (!isLoadMoreRunning) _isLoading = true;
    update();

    final response = await TransactionRepo.getTransactionList(
      page: page,
      transaction_id: transaction_id,
      date: date,
      remark: remark,
    );

    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = t.TransactionModel.fromJson(data).data?.data ?? [];
        transactionList = [...transactionList, ...fetchedData];
        hasNextPage = fetchedData.isNotEmpty;
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      transactionList = [];
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    getTransactionList(page: page, transaction_id: '', date: '', remark: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    transactionList.clear();
  }
}
