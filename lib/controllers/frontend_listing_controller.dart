import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:listplace/controllers/manage_listing_controller.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/frontend_listing_model.dart' as l;
import '../data/models/frontend_listing_details_model.dart' as ld;
import '../data/models/author_profile_model.dart' as author;
import '../data/repositories/frontend_listing_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../utils/services/helpers.dart';
import '../views/widgets/google_map_screen.dart';
import 'wishlist_controller.dart';
import 'package:flutter_map/flutter_map.dart' as leaflet;
import 'package:latlong2/latlong.dart' as latlng;

class FrontendListingController extends GetxController {
  static FrontendListingController get to =>
      Get.find<FrontendListingController>();

  bool isListSelected = false;
  bool isGridSelected = true;
  int selectedIndex = 0;
  int carouselIndex = 0;
  List<String> categoryList = [
    "About",
    "Video",
    "Amenities",
    "Products",
    "Social",
    "Reviews",
  ];

  TextEditingController searchEditingCtrlr = TextEditingController();
  List<l.Datum> searchedListingList = [];
  bool isListingSearch = false;
  onListingSearch(v) {
    if (v.toString().isEmpty) {
      isListingSearch = false;
    } else {
      isListingSearch = true;
    }
    searchedListingList = listingList
        .where(
            (element) => element.title!.toLowerCase().contains(v.toLowerCase()))
        .toList();
    update();
  }

  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<l.Datum> listingList = [];
  Future loadMore() async {
    if (!_isLoading &&
        !isLoadMore &&
        hasNextPage &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getFrontendListngList(
          page: page,
          search: searchEditingCtrlr.text,
          country_id: ManageListingController.to.selectedCountryId ?? "",
          city_id: ManageListingController.to.selectedCityId ?? "",
          categoryId: this.selectedCategoryId,
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
    listingList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  String selectedCategoryId = "";
  List<map.LatLng> latLngList = [];
  Set<map.Marker>? googleMapMarker = {};
  List<leaflet.Marker> leafletmarker = [];
  Future getFrontendListngList(
      {required int page,
      required String search,
      required String country_id,
      required String city_id,
      String? categoryId,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await FrontendListingRepo.getFrontendListngList(
        page: page,
        search: search,
        country_id: country_id,
        city_id: city_id,
        categoryId: categoryId);
    latLngList.clear();
    leafletmarker.clear();
    googleMapMarker!.clear();
    WishlistController.to.wishListItem.clear();
    WishlistController.to.update();
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['data']['data'];
        if (fetchedData.isNotEmpty) {
          listingList = [
            ...listingList,
            ...?l.FrontendListingModel.fromJson(data).data!.data
          ];
          await _processFetchData();

          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          listingList = [
            ...listingList,
            ...?l.FrontendListingModel.fromJson(data).data!.data
          ];
          await _processFetchData();

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
      listingList = [];
    }
  }

  Future<void> _processFetchData() async {
    if (listingList.isNotEmpty) {
      for (var i in listingList) {
        // get lat, lng
        if (i.lat != null && i.long != null) {
          // Add marker to Leaflet
          leafletmarker.add(leaflet.Marker(
            point: latlng.LatLng(double.parse(i.lat.toString()),
                double.parse(i.long.toString())),
            child: Image.asset(
              "$rootImageDir/marker.png",
              height: 40,
              width: 40,
            ),
          ));

          // Add marker to Google Map
          final customMarker = await getCustomGoogleMapMarker();
          var latLng = map.LatLng(
              double.parse(i.lat.toString()), double.parse(i.long.toString()));

          googleMapMarker!.add(map.Marker(
            markerId: map.MarkerId("marker_${i.id}"),
            position: latLng,
            icon: customMarker,
            infoWindow: map.InfoWindow(
                title: i.address ?? "Listing location", snippet: i.title ?? ""),
          ));

          latLngList.add(latLng);
        }

        // Add to wishlist if favorite
        if (i.favouriteCount == 1) {
          WishlistController.to.wishListItem.add(i.id);
        }
      }
      WishlistController.to.update();
    }
  }

  List<ld.Data> listingDetailsList = [];
  bool isCopiedVideId = false;
  Future getFrontendListingDetailsList({required String slug}) async {
    _isLoading = true;
    update();
    http.Response response =
        await FrontendListingRepo.getFrontendListingDetailsList(slug: slug);
    listingDetailsList.clear();
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        if (data['data'] != null) {
          listingDetailsList
              .add(ld.FrontendListingDetailsModel.fromJson(data).data!);
          if (listingDetailsList.isNotEmpty) {
            // check if the leaflet map properly initiated or not
            // if once the mapController initiated then increase the value
            ManageListingController.to.leafletMapViewCount += 1;
            ManageListingController.to.update();
          }
          await getDynamicFormData(data['data']['dynamic_form']);
          await filterData();
        }

        _isLoading = false;
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        _isLoading = false;
        update();
      }
    } else {
      listingDetailsList = [];
      _isLoading = false;
      update();
    }
  }

  //---------------add rating------------------------//
  TextEditingController reviewEditingCtrlr = TextEditingController();
  bool isReviewSubmitting = false;
  Future addRating({Map<String, dynamic>? fields}) async {
    isReviewSubmitting = true;
    update();
    http.Response response =
        await FrontendListingRepo.addReview(fields: fields);
    isReviewSubmitting = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == "success") {
        rating = 0.00;
        reviewEditingCtrlr.clear();
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

  double rating = 0.00;
  onRatingUpdate(v) {
    rating = v;
    update();
  }

  onReviwSubmit({required Map<String, dynamic> fields}) async {
    if (rating == 0.00) {
      Helpers.showSnackBar(msg: "Please provide a rating to proceed.");
    } else if (reviewEditingCtrlr.text.isEmpty) {
      Helpers.showSnackBar(msg: "Review field is required");
    } else {
      Helpers.hideKeyboard();
      await addRating(fields: fields);
    }
    update();
  }

  Widget ratingExpression() {
    if (rating == 0.00) {
      return SizedBox();
    } else if (rating >= 1 && rating <= 1.5) {
      return Icon(
        Icons.sentiment_dissatisfied_sharp,
        size: 30.h,
      );
    } else if (rating >= 2 && rating <= 2.5) {
      return Icon(
        Icons.mood_bad,
        size: 30.h,
      );
    } else if (rating >= 3 && rating <= 3.5) {
      return Icon(
        Icons.sentiment_dissatisfied,
        size: 30.h,
      );
    } else if (rating >= 4 && rating <= 4.5) {
      return Icon(
        Icons.sentiment_satisfied_alt,
        size: 30.h,
      );
    } else if (rating == 5) {
      return Icon(
        Icons.mood,
        size: 30.h,
      );
    }
    update();
    return SizedBox();
  }

  //---------------claim listing------------------------//
  TextEditingController claimBusinessFullNameEditingCtrl =
      TextEditingController();
  TextEditingController claimBusinessMsgEditingCtrl = TextEditingController();

  bool isCaliming = false;
  Future claimBusinessSubmit(
      {Map<String, dynamic>? fields,
      required String listingId,
      required BuildContext context}) async {
    isCaliming = true;
    update();
    http.Response response = await FrontendListingRepo.claimBusinessSubmit(
        fields: fields, listingId: listingId);
    isCaliming = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      claimBusinessFullNameEditingCtrl.clear();
      claimBusinessMsgEditingCtrl.clear();
      if (data['status'] == "success") {
        Navigator.pop(context);
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

  onClaimBusinessSubmit(
      {required String listingId, required BuildContext context}) async {
    if (claimBusinessFullNameEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Full Name is required.");
    } else if (claimBusinessMsgEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Message field is required.");
    } else {
      Helpers.hideKeyboard();
      await claimBusinessSubmit(
          context: context,
          fields: {
            "claimer_name": claimBusinessFullNameEditingCtrl.text,
            "claim_message": claimBusinessMsgEditingCtrl.text,
          },
          listingId: listingId);
    }
    update();
  }

  //---------------send a message------------------------//
  TextEditingController sendMsgFullNameEditingCtrl = TextEditingController();
  TextEditingController sendMsgMessageEditingCtrl = TextEditingController();

  bool isSubmittingListingMsg = false;
  Future listingMsgSubmit(
      {Map<String, dynamic>? fields,
      required String listingId,
      required BuildContext context}) async {
    isSubmittingListingMsg = true;
    update();
    http.Response response = await FrontendListingRepo.listingMsgSubmit(
        fields: fields, listingId: listingId);
    isSubmittingListingMsg = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      sendMsgFullNameEditingCtrl.clear();
      sendMsgMessageEditingCtrl.clear();
      if (data['status'] == "success") {
        Navigator.pop(context);
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

  onlistingMsgSubmit(
      {required String listingId, required BuildContext context}) async {
    if (sendMsgFullNameEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Full Name is required.");
    } else if (sendMsgMessageEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Message field is required.");
    } else {
      Helpers.hideKeyboard();
      await listingMsgSubmit(
          context: context,
          fields: {
            "name": sendMsgMessageEditingCtrl.text,
            "message": sendMsgMessageEditingCtrl.text,
          },
          listingId: listingId);
    }
    update();
  }

  //---------------make query------------------------//
  TextEditingController queryMessageEditingCtrl = TextEditingController();

  Future querySubmit({Map<String, dynamic>? fields}) async {
    _isLoading = true;
    update();
    http.Response response =
        await FrontendListingRepo.querySubmit(fields: fields);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      queryMessageEditingCtrl.clear();
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

  //---------------get dynamic form data------------------------//
  String formName = "";
  String formButtonName = "";
  String formId = "";
  List<ListingDynamicForm> dynamicFormList = [];
  List<ListingDynamicForm> dropdownList = [];
  Future getDynamicFormData(data) async {
    dynamicFormList.clear();
    dropdownList.clear();
    if (data != null && data is Map) {
      Map dForm = data;
      formId = dForm['id'].toString();
      formName = dForm['name'].toString();
      formButtonName = dForm['button_text'].toString();

      if (dForm['input_form'] != null && dForm['input_form'] is Map) {
        Map<String, dynamic> inputForm = dForm['input_form'];

        for (var i in inputForm.entries) {
          if (i.value['option'] != null && i.value['option'] is Map) {
            Map optionMap = i.value['option'];

            List<String> optionList = [];
            for (var j in optionMap.entries) {
              optionList.add(j.value);
            }

            // Check if the type is "select"
            if (i.value['type'] == "select") {
              if (!dropdownList.contains(i.key)) {
                dropdownList.add(ListingDynamicForm(
                  key: i.key,
                  fieldName: i.value['field_name'],
                  type: i.value['type'],
                  validation: i.value['validation'],
                  optionList: optionList,
                ));
              }
            }

            dynamicFormList.add(ListingDynamicForm(
              key: i.key.toString(),
              fieldName: i.value['field_name'] ?? "",
              type: i.value['type'] ?? "",
              validation: i.value['validation'] ?? "",
              optionList: optionList,
            ));
          } else {
            dynamicFormList.add(ListingDynamicForm(
              key: i.key.toString(),
              fieldName: i.value['field_name'] ?? "",
              type: i.value['type'] ?? "",
              validation: i.value['validation'] ?? "",
            ));
          }
        }
      }
    }
    update();
  }

  // submit dynamic form
  bool isSubmittingDynamicForm = false;
  Future submitListingFormData(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isSubmittingDynamicForm = true;
    update();
    http.Response response = await FrontendListingRepo.submitListingFormData(
        fields: fields, fileList: fileList);
    isSubmittingDynamicForm = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        refreshDynamicData();
      }
      update();
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

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<ListingDynamicForm> fileType = [];
  List<ListingDynamicForm> requiredFile = [];
  Color fileColorOfDField = Colors.transparent;

  Future filterData() async {
    fileColorOfDField = Colors.transparent;

    // check if the field type is text, textarea, number or date
    var textType =
        await dynamicFormList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.key] = TextEditingController();
    }

    // check if the field type is file
    fileType = await dynamicFormList.where((e) => e.type == 'file').toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
    update();
  }

  Map<String, dynamic> dynamicData = {};
  List<String> imgPathList = [];

  Future renderDynamicFieldData() async {
    imgPathList.clear();
    textEditingControllerMap.forEach((key, controller) {
      dynamicData[key] = controller.text;
    });
    await Future.forEach(imagePickerResults.keys, (String key) async {
      String filePath = imagePickerResults[key]!.path;
      imgPathList.add(imagePickerResults[key]!.path);
      dynamicData[key] = await http.MultipartFile.fromPath("", filePath);
    });

    // if (kDebugMode) {
    //   print("Posting data: $dynamicData");
    // }
  }

  final formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        final File imageFile = File(pickedImageFile!.path);
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB >= 4) {
          Helpers.showSnackBar(
              msg: "Image size exceeds 4 MB. Please choose a smaller image.");
        } else {
          imagePickerResults[fieldName] = pickedImageFile;
          requiredFile.removeWhere((e) => e.key == fieldName);
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
          fileMap[fieldName] = file;
        }

        update();
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  refreshDynamicData() {
    dynamicFormList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    fileMap.clear();
    pickedFile = null;
  }

  //--------------GET AUTHOR PROFILE------------------//
  List<author.Data> authorProfileList = [];
  String authorUsername = "";
  Future getAuthorProfile({required String userName}) async {
    _isLoading = true;
    update();
    http.Response response =
        await FrontendListingRepo.getAuthorProfile(userName: userName);
    authorProfileList.clear();
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        if (data['data'] != null) {
          authorProfileList.add(author.AuthorProfileModel.fromJson(data).data!);
          if (authorProfileList.isNotEmpty) {
            isFollowingToAuthor = authorProfileList[0].checkFollowing != null &&
                    authorProfileList[0].checkFollowing == 1
                ? true
                : false;
          }
        }

        _isLoading = false;
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        _isLoading = false;
        update();
      }
    } else {
      authorProfileList = [];
      _isLoading = false;
      update();
    }
  }

  //---------------SEND MESSAGE TO LISTING AUTHOR-----//
  TextEditingController authorSendMsgFullNameEditingCtrl =
      TextEditingController();
  TextEditingController authorSendMsgMessageEditingCtrl =
      TextEditingController();

  bool isSubmittingMsgToAuthor = false;
  Future msgToAuthor(
      {Map<String, dynamic>? fields,
      required String authorId,
      required BuildContext context}) async {
    isSubmittingMsgToAuthor = true;
    update();
    http.Response response = await FrontendListingRepo.msgToAuthor(
        fields: fields, authorId: authorId);
    isSubmittingMsgToAuthor = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == "success") {
        authorSendMsgFullNameEditingCtrl.clear();
        authorSendMsgMessageEditingCtrl.clear();
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

  Future onMsgToListingAuthor(
      {required String authorId, required BuildContext context}) async {
    if (authorSendMsgFullNameEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Full Name is required.");
    } else if (authorSendMsgMessageEditingCtrl.text.isEmpty) {
      Helpers.showSnackBar(msg: "Message field is required.");
    } else {
      Helpers.hideKeyboard();
      await msgToAuthor(
          context: context,
          fields: {
            "name": authorSendMsgFullNameEditingCtrl.text,
            "message": authorSendMsgMessageEditingCtrl.text,
          },
          authorId: authorId);
    }
    update();
  }

  //----------SEND MESSAGE TO LISTING AUTHOR----------//
  bool isFollowingToAuthor = false;
  bool isFollow = false;
  Future followToAuthor(
      {Map<String, dynamic>? fields,
      required String authorId,
      required BuildContext context}) async {
    isFollow = true;
    update();
    http.Response response = await FrontendListingRepo.followToAuthor(
        fields: fields, authorId: authorId);
    isFollow = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        if (data['data'] == 'Followed') {
          isFollowingToAuthor = true;
        } else {
          isFollowingToAuthor = false;
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
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
  //--------------------------------------------------//

  refreshData() {
    dynamicFormList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();

    fileMap.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getFrontendListngList(page: page, search: '', country_id: '', city_id: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    listingList.clear();
  }
}

class ListingDynamicForm {
  String key;
  String fieldName;
  String type;
  String validation;
  List<String>? optionList;
  ListingDynamicForm(
      {required this.key,
      required this.fieldName,
      required this.type,
      required this.validation,
      this.optionList});
}

class DynamicDropdownForm {
  String key;
  String fieldName;
  String type;
  String validation;
  List<String>? optionList;
  DynamicDropdownForm(
      {required this.key,
      required this.fieldName,
      required this.type,
      required this.validation,
      this.optionList});
}
