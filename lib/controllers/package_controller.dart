import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:listplace/data/repositories/package_repo.dart';
import '../data/models/purchase_package_model.dart' as p;
import '../data/source/errors/check_api_status.dart';

class PackageController extends GetxController {
  static PackageController get to => Get.find<PackageController>();

  TextEditingController packageNameEditingCtrlr = TextEditingController();
  TextEditingController expireEditingCtrlr = TextEditingController();
  TextEditingController purchaseEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Datum> packageList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getPackageList(
          page: page,
          name: packageNameEditingCtrlr.text,
          purchase_date: purchaseEditingCtrlr.text,
          expire_date: expireEditingCtrlr.text,
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
    packageList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getPackageList(
      {required int page,
      required String name,
      required String purchase_date,
      required String expire_date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await PackageRepo.getPackageList(
      page: page,
      name: name,
      purchase_date: purchase_date,
      expire_date: expire_date,
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
          packageList = [
            ...packageList,
            ...?p.PurchasePackageModel.fromJson(data).data!.data
          ];

          // Sorting list based on number of listings
          if (packageList.isNotEmpty) {
            packageList.sort((a, b) {
              int aListings = a.noOfListing == null
                  ? 0
                  : int.parse(a.noOfListing.toString()); // Default to 0 if null
              int bListings = b.noOfListing == null
                  ? 0
                  : int.parse(b.noOfListing.toString());

              return bListings.compareTo(aListings);
            });
          }
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          packageList = [
            ...packageList,
            ...?p.PurchasePackageModel.fromJson(data).data!.data
          ];

          // Sorting list based on number of listings
          if (packageList.isNotEmpty) {
            packageList.sort((a, b) {
              int aListings = a.noOfListing == null
                  ? 0
                  : int.parse(a.noOfListing.toString()); // Default to 0 if null
              int bListings = b.noOfListing == null
                  ? 0
                  : int.parse(b.noOfListing.toString());

              return bListings.compareTo(aListings);
            });
          }
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
      packageList = [];
    }
  }

  String getValidityMessage(DateTime expireDate, DateTime purchaseDate) {
    Duration difference = expireDate.difference(purchaseDate);

    if (difference.inDays <= 0) {
      return "Expired";
    }

    int years = difference.inDays ~/ 365;
    int months = (difference.inDays % 365) ~/ 30;
    int days = (difference.inDays % 365) % 30;

    String validity = "";
    if (years > 0) {
      validity += "$years year${years > 1 ? 's' : ''} ";
    } else if (months > 0) {
      validity += "$months month${months > 1 ? 's' : ''} ";
    } else if (days > 0) {
      validity += "$days day${days > 1 ? 's' : ''}";
    }
    return validity.trim();
  }

  @override
  void onInit() {
    super.onInit();
    getPackageList(page: page, name: '', purchase_date: '', expire_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    packageList.clear();
  }
}
