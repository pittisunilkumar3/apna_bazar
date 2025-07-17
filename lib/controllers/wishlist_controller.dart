import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/app_colors.dart';
import '../data/models/wishlist_model.dart' as w;
import '../data/repositories/wishlist_repo.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class WishlistController extends GetxController {
  static WishlistController get to => Get.find<WishlistController>();

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

  List<w.Datum> wishList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getwishlist(
          page: page,
          listing_name: listingNameEditingCtrlr.text,
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
    wishList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getwishlist(
      {required int page,
      required String listing_name,
      required String from_date,
      required String to_date,
      bool? isFromWallet = false,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await WishlistRepo.getwishlist(
        page: page,
        listing_name: listing_name,
        from_date: from_date,
        to_date: to_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          wishList = [
            ...wishList,
            ...w.WishlistModel.fromJson(data).data!.data!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          wishList = [
            ...wishList,
            ...w.WishlistModel.fromJson(data).data!.data!
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
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      wishList = [];
    }
  }

  //---------------add to wishlist------------------------//
  dynamic isAddedToWishlist = null;
  List<int> wishListItem = [];

  Future addToWishlist(
      {Map<String, dynamic>? fields,
      bool? isFromAllListingPage = false,
      required int listingId}) async {
    _isLoading = true;
    update();
    http.Response response = await WishlistRepo.addWishlist(fields: fields);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Helpers.showToast(
          msg: data['data']['message'].toString(),
          bgColor: AppColors.whiteColor,
          textColor: AppColors.blackColor);
      if (data['status'] == "success") {
        if (data['data'].toString().toLowerCase().contains("added")) {
          isAddedToWishlist = true;
          if (!wishListItem.contains(listingId)) {
            wishListItem.add(listingId);
          }
          update();
        } else if (data['data'].toString().toLowerCase().contains("removed")) {
          isAddedToWishlist = false;
          if (wishListItem.contains(listingId)) {
            wishListItem.remove(listingId);
          }
          update();
        }
        if (isFromAllListingPage == false) {
          resetDataAfterSearching();
          await getwishlist(
              page: 1, listing_name: '', from_date: '', to_date: '');
        }
        update();
      }
    } else {
      if (response.statusCode == 401) {
        Helpers.showSnackBar(
            title: 'Alert!',
            bgColor: Colors.yellow.shade800,
            msg: response.body.toString());
      } else {
        Helpers.showSnackBar(msg: "Something went wrong!");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (HiveHelp.read(Keys.token) != null) {
      getwishlist(page: page, listing_name: '', from_date: '', to_date: '');
    }
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    wishList.clear();
  }
}
