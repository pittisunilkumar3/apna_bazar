import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repositories/listing_repo.dart';
import '../data/source/errors/check_api_status.dart';

class DynamicFormController extends GetxController {
  static DynamicFormController get to => Get.find<DynamicFormController>();

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DynamicFormDataModel> dynamicFormList = [];
  List<DynamicFormDataModel> dynamicFormList2 = [];
  String listingId = "0";
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getDynamicFormData(
          page: page, isLoadMoreRunning: true, listingId: this.listingId);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    dynamicFormList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  String selectedId = "";
  Future getDynamicFormData({
    required int page,
    required String listingId,
    bool isLoadMoreRunning = false,
  }) async {
    if (!isLoadMoreRunning) _isLoading = true;
    update();

    final response = await ListingRepo.getDynamicFormData(
      listingId: listingId,
      page: this.page,
    );

    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          for (var item in fetchedData) {
            if (item['input_form'] != null && item['input_form'] is Map) {
              item['input_form'].forEach((key, value) {
                // store both key and value
                dynamicFormList2.add(_mapToModel(item, value));
              });
            }
            // store only key
            dynamicFormList.add(_mapToModel(item));
          }
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      dynamicFormList = [];
    }
  }

  DynamicFormDataModel _mapToModel(dynamic item, [dynamic value]) {
    return DynamicFormDataModel(
      id: item['id'].toString(),
      formName: item['form_name'] ?? "",
      fieldName: value?['field_name'] ?? "",
      fieldVal: value?['field_value'] ?? "",
      type: value?['type'] ?? "",
      date: item['created_at'] ?? "",
    );
  }
}

class DynamicFormDataModel {
  final String id;
  final String formName;
  final String fieldName;
  final String fieldVal;
  final String type;
  final String date;
  DynamicFormDataModel({
    required this.id,
    required this.formName,
    required this.fieldName,
    required this.fieldVal,
    required this.type,
    required this.date,
  });
}
