import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/my_listing_model.dart' as listing;
import '../data/repositories/listing_repo.dart';
import '../data/source/errors/check_api_status.dart';

class MyListingController extends GetxController {
  static MyListingController get to => Get.find<MyListingController>();

  TextEditingController listingNameEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<listing.Datum> myListingList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getMyListings(
          page: _page,
          listing_name: listingNameEditingCtrlr.text,
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
    myListingList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future getMyListings(
      {required int page,
      required String listing_name,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await ListingRepo.getMyListings(page: page, name: listing_name);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          myListingList = [
            ...myListingList,
            ...?listing.MyListingModel.fromJson(data).data!.data
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================ticket list len: " +
                myListingList.length.toString());
          }
          update();
        } else {
          myListingList = [
            ...myListingList,
            ...?listing.MyListingModel.fromJson(data).data!.data
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
      myListingList = [];
    }
  }

  bool isDeleteListing = false;
  Future deleteListing({required String listingId}) async {
    isDeleteListing = true;
    update();
    http.Response response =
        await ListingRepo.deleteListing(listingId: listingId);
    isDeleteListing = false;
    update();

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == "success") {
        resetDataAfterSearching(isFromOnRefreshIndicator: true);
        getMyListings(page: _page, listing_name: "");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMyListings(page: _page, listing_name: "");
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _isLoading = false;
    myListingList.clear();
  }
}
