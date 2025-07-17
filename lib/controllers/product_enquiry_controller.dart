import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/customer_enquiry_model.dart' as customer;
import '../data/repositories/product_enquiry_repo.dart';
import '../data/source/errors/check_api_status.dart';

class ProductEnquiryController extends GetxController {
  static ProductEnquiryController get to =>
      Get.find<ProductEnquiryController>();

  TextEditingController listingNameEditingCtrlr = TextEditingController();
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

  String enquiryType = "customer";

  List<customer.Datum> productEnquiryList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getCustomerEnquiryList(
          enquiryType: this.enquiryType,
          page: page,
          name: listingNameEditingCtrlr.text,
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
    productEnquiryList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getCustomerEnquiryList(
      {required int page,
      required String name,
      required String from_date,
      required String to_date,
      required String enquiryType,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ProductEnquiryRepo.getProductEnquiryList(
      page: page,
      name: name,
      from_date: from_date,
      to_date: to_date,
      enquiryType: enquiryType,
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
          productEnquiryList = [
            ...productEnquiryList,
            ...?customer.CustomerEnquiryModel.fromJson(data).data!.data
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          productEnquiryList = [
            ...productEnquiryList,
            ...?customer.CustomerEnquiryModel.fromJson(data).data!.data
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
      productEnquiryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    enquiryType = "customer";
    pageController = PageController(initialPage: 0);
    getCustomerEnquiryList(
        page: page,
        enquiryType: enquiryType,
        name: '',
        from_date: '',
        to_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    productEnquiryList.clear();
  }
}
