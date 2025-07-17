import 'dart:convert';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/helpers.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/screens/listing/add_listing/add_listing_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../config/app_colors.dart';
import '../data/models/listing_categories_model.dart' as l;
import '../data/models/country_list_model.dart' as cM;
import '../data/models/state_model.dart' as sM;
import '../data/models/city_model.dart' as city;
import '../data/models/ameniti_model.dart' as amenity;
import '../data/models/purchase_package_model.dart' as p;
import '../data/models/edit_listing_model.dart' as editListing;
import '../data/repositories/listing_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/localstorage/keys.dart';
import '../views/screens/listing/add_listing/BasicInfo.dart';
import '../views/screens/listing/add_listing/amenity.dart';
import '../views/screens/listing/add_listing/communication.dart';
import '../views/screens/listing/add_listing/custom_form.dart';
import '../views/screens/listing/add_listing/photo.dart';
import '../views/screens/listing/add_listing/products.dart';
import '../views/screens/listing/add_listing/seo.dart';
import '../views/screens/listing/add_listing/video.dart';
import 'frontend_listing_controller.dart';
import 'profile_controller.dart';

class ManageListingController extends GetxController {
  static ManageListingController get to => Get.find<ManageListingController>();

  // add listing categores
  List<String> categoryDemoList() {
    return <String>[
      "Basic Info",
      if (selectedSinglePackage.isVideo == 1) "Video",
      if (selectedSinglePackage.isImage == 1) "Photos",
      if (selectedSinglePackage.isAmenities == 1) "Amenities",
      if (selectedSinglePackage.isProduct == 1) "Products",
      if (selectedSinglePackage.seo == 1) "SEO",
      if (selectedSinglePackage.isMessenger == 1 &&
          selectedSinglePackage.isWhatsapp == 1)
        "Communication",
      if (selectedSinglePackage.isCreateFrom == 1) "Custom Form",
    ];
  }

  // add listing categores tabbar view pages
  List<Widget> categoryTabViewList(isFromEditListing) {
    return [
      BasicInfoTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isVideo == 1)
        VideosTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isImage == 1)
        PhotoTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isAmenities == 1)
        AmenitiesTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isProduct == 1)
        ProductsTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.seo == 1)
        SEOTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isMessenger == 1 &&
          selectedSinglePackage.isWhatsapp == 1)
        CommunicationTab(isFromEditListing: isFromEditListing),
      if (selectedSinglePackage.isCreateFrom == 1)
        CustomFormTab(isFromEditListing: isFromEditListing),
    ];
  }

  //--------------------BASIC INFO BEGIN-----------//
  TextEditingController basicInfoTitleEditingCtrlr = TextEditingController();
  TextEditingController slugEditingCtrlr = TextEditingController();
  TextEditingController emailEditingCtrlr = TextEditingController();
  TextEditingController phoneEditingCtrlr = TextEditingController();
  TextEditingController descriptionEditingCtrlr = TextEditingController();

  final GlobalKey<FormState> basicInfoFormKey = GlobalKey<FormState>();

  int selectedTabIndex = 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // GET PURCHASE PACKAGE LIST
  List<p.Datum> purchasePackageList = [];
  Future getPurchasePackage() async {
    _isLoading = true;
    update();
    http.Response response = await ListingRepo.getPurchasePackage();
    _isLoading = false;
    purchasePackageList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        purchasePackageList = [
          ...purchasePackageList,
          ...?p.PurchasePackageModel.fromJson(data).data!.data
        ];
        // get only not expired items
        purchasePackageList = List.from(purchasePackageList.where((e) {
          return DateTime.parse(e.expireDate.toString())
              .isAfter(DateTime.now());
        }).toList());
        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      purchasePackageList = [];
    }
  }

  // dropdown menu
  TextEditingController availableListingEditingCtrl = TextEditingController();
  List<p.Datum> selectedPurchasePackageList = [];
  dynamic selectedPurchasePackage;
  p.Datum selectedSinglePackage = p.Datum();
  int selectedPackageId = 0;

  void onChangePackage(int? selectedId) {
    if (selectedId == null) return;
    selectedPackageId = selectedId;

    selectedSinglePackage =
        purchasePackageList.firstWhere((e) => e.id == selectedPackageId);
    selectedPurchasePackage = selectedSinglePackage.id;

    availableListingEditingCtrl.text =
        selectedSinglePackage.noOfListing.toString();

    update();
  }

  // GET LISTING CATEGORY
  int selectedCategoryIndex = 0;
  List<l.Datum> listingCategoryFrontendList = [];
  List<l.Datum> listingCategoryList = [];
  List<l.Datum> searchListingCategoryList = [];
  List<l.Datum> topListingCategoryList = [];
  dynamic selectedCategory;
  String selectedCategoryId = "";
  TextEditingController categoryEditingCtrl = TextEditingController();
  Future getListingCategories() async {
    _isLoading = true;
    update();
    http.Response response = await ListingRepo.getListingCategories();
    _isLoading = false;
    listingCategoryList = [];
    topListingCategoryList = [];
    listingCategoryFrontendList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        listingCategoryList = [
          ...listingCategoryList,
          ...?l.ListingCategoryModel.fromJson(data).data
        ];
        listingCategoryFrontendList
            .add(l.Datum(name: 'All', image: '$rootImageDir/all.png'));
        listingCategoryFrontendList.addAll(listingCategoryList);

        if (listingCategoryList.isNotEmpty) {
          listingCategoryList.sort((a, b) =>
              int.parse(b.total_listing.toString())
                  .compareTo(int.parse(a.total_listing.toString())));
          topListingCategoryList = listingCategoryList.take(4).toList();
        }

        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      listingCategoryList = [];
    }
  }

  // search on category
  bool isCategorySearching = false;
  TextEditingController searchCategoryEditingCtrlr = TextEditingController();
  onSearchChanged(v) {
    if (v.toString().isEmpty) {
      isCategorySearching = false;
      searchListingCategoryList.clear();
    } else {
      isCategorySearching = true;
    }
    searchListingCategoryList = listingCategoryList
        .where((e) => e.name.toLowerCase().contains(v.toLowerCase()))
        .toList();
    update();
  }

  onChangedCategories(List<String> x) async {
    selectedCategoryIdList.clear();
    try {
      selectedCategoryList = x;
      for (int i = 0; i < selectedCategoryList.length; i += 1) {
        var l = listingCategoryList
            .where((e) => e.name == selectedCategoryList[i])
            .toList();
        for (int j = 0; j < l.length; j += 1) {
          selectedCategoryIdList.add(l[j].id.toString());
        }
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  List<String> selectedCategoryList = [];
  List<String> selectedCategoryIdList = [];

  dynamic selectedCountry;
  dynamic selectedCountryId;
  dynamic selectedState;
  dynamic selectedStateId;
  dynamic selectedCity;
  dynamic selectedCityId;
  TextEditingController countryEditingCtrlr = TextEditingController();
  TextEditingController stateEditingCtrlr = TextEditingController();
  TextEditingController cityEditingCtrlr = TextEditingController();
  TextEditingController searchedPlaceEditingCtrlr = TextEditingController();
  TextEditingController latEditingCtrlr = TextEditingController();
  TextEditingController lngEditingCtrlr = TextEditingController();
  double defaultLat = 23.872413317988265;
  double defaultLng = 90.40044151202481;

  onChangedCountry(v) async {
    try {
      selectedState = null;
      if (isAllCities == false) {
        selectedCity = null;
      }
      selectedCountry = v;
      selectedCountryId =
          countryList.firstWhere((cM.Datum e) => e.name == v).id.toString();
      latEditingCtrlr.clear();
      lngEditingCtrlr.clear();
      await getStateList(countryId: selectedCountryId);
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  onChangedState(v) async {
    try {
      selectedCity = null;
      selectedState = v;
      selectedStateId =
          stateList.firstWhere((sM.Datum e) => e.name == v).id.toString();
      latEditingCtrlr.clear();
      lngEditingCtrlr.clear();
      await getCityList(StateId: selectedStateId);
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  bool isAllCities = false;
  onChangedCity(v) async {
    try {
      selectedCity = v;
      var data = cityList.firstWhere((city.Datum e) => e.name == v);
      selectedCityId = data.id.toString();
      // if user is not from Alllisting page
      if (isAllCities == false) {
        if (ProfileController.to.isLeafLetMap != true) {
          searchedPlaceEditingCtrlr.text = v;
        }
        if (ProfileController.to.isLeafLetMap == true) {
          leafLetSearchEditingCtrl.text = v;
          if (data.latitude != null && data.longitude != null) {
            latlng.LatLng latLng = LatLng(
                double.parse(data.latitude.toString()),
                double.parse(data.longitude.toString()));
            selectedLat = latLng.latitude.toString();
            selectedLng = latLng.longitude.toString();
            addMarker(latLng);
          } else {
            Helpers.showSnackBar(msg: "Lat and Long not found");
          }
        }
      }

      latEditingCtrlr.text = data.latitude ?? "$defaultLat";
      lngEditingCtrlr.text = data.longitude ?? "$defaultLng";
      basicInfoValidation();
      update();
    } catch (e) {
      print(e);
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  // GET COUNTRY LIST
  List<cM.Datum> countryList = [];
  Future getCountryList() async {
    _isLoading = true;
    update();
    http.Response response = await ListingRepo.getCountryList();
    _isLoading = false;
    countryList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        countryList = [
          ...countryList,
          ...?cM.CountryListModel.fromJson(data).data
        ];
        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      countryList = [];
    }
  }

  // GET STATE LIST
  List<sM.Datum> stateList = [];
  Future getStateList({required String countryId}) async {
    _isLoading = true;
    update();
    http.Response response =
        await ListingRepo.getStateList(countryId: countryId);
    _isLoading = false;
    stateList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        stateList = [...stateList, ...?sM.StateListModel.fromJson(data).data];
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      countryList = [];
    }
  }

// GET CITY LIST
  List<city.Datum> cityList = <city.Datum>[];
  Set<int> cityIds = {}; // To track unique city IDs
  Set<String> cityNames = {}; // To track unique city names

  Future getCityList(
      {required String StateId, bool? isAllCities = false}) async {
    _isLoading = true;
    update();

    http.Response response = await ListingRepo.getCityList(
        StateId: StateId, isAllCities: isAllCities);

    _isLoading = false;
    cityList.clear();
    cityIds.clear();
    cityNames.clear();
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<city.Datum> allCities =
            city.CityListModel.fromJson(data).data ?? [];

        for (var item in allCities) {
          // Add city if both ID and name are unique
          if (cityIds.add(item.id) && cityNames.add(item.name.toLowerCase())) {
            cityList.add(item);
          }
        }

        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      cityList = [];
    }
  }

  // GET GEOCODING ADDRESS FOR GOOGLE MAP
  Future getGoogleMapAddressFromLatLng(double lat, double lng) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'DEFAULT_KEY';
    final url = Uri.parse(
        '${dotenv.env['GEOCODING_ADDR_SEARCH']}?latlng=$lat,$lng&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        searchedPlaceEditingCtrlr.text =
            data['results'][0]['formatted_address'].toString();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: response.body);
    }
  }

  // SEARCH PLACE FOR LEAFLET MAP
  TextEditingController leafLetSearchEditingCtrl = TextEditingController();
  Future<List<Map<String, dynamic>>> searchLeaftLetPlaces({
    required String queryString,
  }) async {
    try {
      final request = http.Request(
        'GET',
        Uri.parse(
          "${dotenv.env['LEAFLET_MAP_SEARCH']}?q=$queryString&format=json&addressdetails=1&limit=5&polygon_svg=0",
        ),
      );
      request.headers.addAll({'Content-Type': 'application/json'});
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((place) {
          return {
            'name': place['display_name'],
            'lat': double.parse(place['lat']),
            'lon': double.parse(place['lon']),
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
      return [];
    }
  }

  Future getLeafletAddressFromLatLng(double latitude, double longitude) async {
    final url = Uri.parse(
        '${dotenv.env['LEAFLET_ADDRESS_SEARCH']}?lat=$latitude&lon=$longitude&format=json&accept-language=en');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['address'] != null) {
        leafLetSearchEditingCtrl.text = data['display_name'];
      }
      update();
    } else {
      Helpers.showSnackBar(msg: jsonEncode(response.body));
    }
  }

  List<Map<String, dynamic>> suggestions = [];
  bool isSearching = false;
  latlng.LatLng currentCenter = latlng.LatLng(51.509865, -0.118092);

  Future<void> handleSearch(String query) async {
    if (query.isEmpty) {
      suggestions = [];
      update();
      return;
    }

    isSearching = true;
    update();

    final results = await searchLeaftLetPlaces(queryString: query.trim());

    suggestions = results;
    isSearching = false;
    update();
  }

  latlng.LatLng center = latlng.LatLng(51.509865, -0.118092);
  MapController mapController = MapController();
  // check map controller properly initiated or not
  int leafletMapViewCount = 0;

  void selectSuggestion(Map<String, dynamic> place) {
    latlng.LatLng center = latlng.LatLng(place['lat'], place['lon']);
    latEditingCtrlr.text = place['lat'].toString();
    lngEditingCtrlr.text = place['lon'].toString();
    leafLetSearchEditingCtrl.text = place['name'];
    mapController.move(center, 13.0);
    addMarker(center);

    selectedLat = center.latitude.toString();
    selectedLng = center.longitude.toString();
    update();
  }

  // add marker to the leaflet map
  final List<Marker> markers = [];
  void addMarker(LatLng position) {
    markers.clear();
    markers.add(Marker(
      point: position,
      child: Image.asset(
        "$rootImageDir/marker.png",
        height: 40,
        width: 40,
      ),
    ));
    latEditingCtrlr.text = position.latitude.toString();
    lngEditingCtrlr.text = position.longitude.toString();
    center = position;
    mapController.move(center, 13.0);

    update();
  }

  //-------BUSINESS HOURS
  // get weeks
  List<String> weekdays = List.generate(7, (index) {
    final day = DateTime.now().add(Duration(days: index));
    return DateFormat('EEEE').format(day);
  });

  Time startTime =
      Time(hour: 9, minute: 30, second: 20).setPeriod(DayPeriod.am);
  Time endTime = Time(hour: 5, minute: 30, second: 20).setPeriod(DayPeriod.pm);

  List<BusinessHourModel> businessHours = [BusinessHourModel()].obs;

  void addBusinessHour() {
    businessHours.add(BusinessHourModel());
    Helpers.showSnackBar(title: "Success", msg: "New time slot added");
    update();
  }

  void removeBusinessHour(int index) {
    if (businessHours.length > 1) {
      businessHours.removeAt(index);
      Helpers.showSnackBar(title: 'Success', msg: "Slot removed");
      update();
    } else {
      Helpers.showSnackBar(
          msg:
              "At least one time slot must be selected and cannot be deleted.");
    }
  }

  //------WEBSITE AND SOCIAL LINKS

  List<SocialModel> socialList = [SocialModel()].obs;
  List<TextEditingController> urlCtrlList = [TextEditingController()].obs;

  void addSocial() {
    socialList.add(SocialModel());
    urlCtrlList.add(TextEditingController());
    Helpers.showSnackBar(title: "Success", msg: "New slot added");
    update();
  }

  void removeSocial(int index) {
    if (socialList.length > 1) {
      socialList.removeAt(index);
      Helpers.showSnackBar(title: 'Success', msg: "Slot removed");
      update();
    } else {
      Helpers.showSnackBar(
          msg: "At least one slot must be selected and cannot be deleted.");
    }
  }

  final Map<String, IconData> socialIcons = {
    'facebook': FontAwesomeIcons.facebook,
    'whatsapp': FontAwesomeIcons.whatsapp,
    'telegram': FontAwesomeIcons.telegram,
    'globe': FontAwesomeIcons.globe,
    'instagram': FontAwesomeIcons.instagram,
    'twitter': FontAwesomeIcons.twitter,
    'youtube': FontAwesomeIcons.youtube,
    'linkedin': FontAwesomeIcons.linkedin,
    'google': FontAwesomeIcons.google,
    'discord': FontAwesomeIcons.discord,
  };

  Future basicInfoValidation() async {
    if (basicInfoTitleEditingCtrlr.text.isEmpty) {
      titleColor = AppColors.redColor;
    }
    if (basicInfoTitleEditingCtrlr.text.isNotEmpty) {
      titleColor = Colors.transparent;
    }
    if (descriptionEditingCtrlr.text.isEmpty) {
      desColor = AppColors.redColor;
    }
    if (descriptionEditingCtrlr.text.isNotEmpty) {
      desColor = Colors.transparent;
    }
    if (latEditingCtrlr.text.isEmpty) {
      latColor = AppColors.redColor;
    }
    if (latEditingCtrlr.text.isNotEmpty) {
      latColor = Colors.transparent;
    }
    if (lngEditingCtrlr.text.isEmpty) {
      lngColor = AppColors.redColor;
    }
    if (lngEditingCtrlr.text.isNotEmpty) {
      lngColor = Colors.transparent;
    }
    if (searchedPlaceEditingCtrlr.text.isEmpty) {
      addrColor = AppColors.redColor;
    }
    if (searchedPlaceEditingCtrlr.text.isNotEmpty) {
      addrColor = Colors.transparent;
    }
  }
  //--------------------BASIC INFO END-----------//

  //--------------------VIDEO START-----------//
  TextEditingController youtubeUrlCtrl = TextEditingController();
  YoutubePlayerController youtubePlayerController =
      YoutubePlayerController(initialVideoId: '');

  void updateYoutubeController(String id) {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(autoPlay: false),
    );
    update();
  }

  //--------------------VIDEO END-----------//

  //--------------------Photo Start-----------//

  final List<String> _fileNamesFromPhotosSection = [];

  FilePickerResult? resultFromPhotosSection;
  List<dynamic> selectedFilePathsFromPhotosSection = [];
  List<http.MultipartFile> filesFromPhotosSection = [];
  String selectedSinglePathFromPhotosSection = "";

  Future<void> pickPhotosSection(
      {bool? allowMuptiple = false, String? fieldName = ""}) async {
    try {
      filesFromPhotosSection.clear();
      selectedFilePathsFromPhotosSection.clear();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: allowMuptiple ?? false,
          allowedExtensions: ['jpg', 'png', 'jpeg']);

      if (result != null) {
        if (allowMuptiple == true) {
          _fileNamesFromPhotosSection.addAll(result.paths.map((path) => path!));
          selectedFilePathsFromPhotosSection
              .addAll(result.paths.whereType<String>());
          for (int i = 0; i < selectedFilePathsFromPhotosSection.length; i++) {
            filesFromPhotosSection.addAll([
              await http.MultipartFile.fromPath(
                  "$fieldName[$i]", selectedFilePathsFromPhotosSection[i]),
            ]);
          }
        } else {
          selectedSinglePathFromPhotosSection =
              result.files.single.path.toString();
          filesFromPhotosSection.addAll([
            await http.MultipartFile.fromPath(
                "$fieldName", selectedSinglePathFromPhotosSection),
          ]);
        }
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
      if (kDebugMode) {
        print("Error while picking files: $e");
      }
    }
  }

  void removeFile(int i) {
    selectedFilePathsFromPhotosSection.removeAt(i);
    if (filesFromPhotosSection.isNotEmpty) {
      filesFromPhotosSection.removeAt(i);
    }
    if (photosOldImgIdList.isNotEmpty) {
      photosOldImgIdList.removeAt(i);
    }

    update();
  }
  //--------------------Photo END-----------//

  //--------------------Amenities Start-----------//
  TextEditingController ameniCtrl = TextEditingController();
  // GET AMENITY LIST
  List<amenity.Datum> amenitiList = [];
  Future getAmenitiesList() async {
    _isLoading = true;
    update();
    http.Response response = await ListingRepo.getAmenitiesList();
    _isLoading = false;
    amenitiList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        amenitiList = [
          ...amenitiList,
          ...?amenity.AmenitiModel.fromJson(data).data
        ];
        update();
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      amenitiList = [];
    }
  }

  onChangedAmenities(List<String> x) async {
    selectedAmenityIdList.clear();
    try {
      selectedAmenityList = x;
      for (int i = 0; i < selectedAmenityList.length; i += 1) {
        var l =
            amenitiList.where((e) => e.name == selectedAmenityList[i]).toList();
        for (int j = 0; j < l.length; j += 1) {
          selectedAmenityIdList.add(l[j].id.toString());
        }
      }
      update();
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  List<String> selectedAmenityList = [];
  List<String> selectedAmenityIdList = [];

  //--------------------Amenities END-----------//

  //--------------------Products Start-----------//
  List<String> onChangedProductItemList = [];

  Future<void> pickProductSection({
    bool? allowMuptiple = false,
    String? fieldName = "",
    required ProductModel product,
  }) async {
    try {
      // Attempt to pick files
      product.result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: allowMuptiple ?? false,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (product.result != null) {
        // Handle multiple file selection
        if (allowMuptiple == true) {
          product.fileNames.addAll(product.result!.paths.whereType<String>());
          product.filePath.addAll(product.result!.paths.whereType<String>());

          for (int i = 0; i < product.filePath.length; i++) {
            // Ensure file path is not null or invalid
            var filePath = product.filePath[i];
            if (filePath.isNotEmpty) {
              product.multiPartList.add(
                await http.MultipartFile.fromPath("$fieldName[$i]", filePath),
              );
            }
          }
        } else {
          // Handle single file selection
          final singleFile = product.result!.files.single;
          if (singleFile.path != null && singleFile.path!.isNotEmpty) {
            product.singlePath = singleFile.path!;
            filesFromPhotosSection.add(
              await http.MultipartFile.fromPath(
                  "$fieldName", product.singlePath.toString()),
            );
          } else {
            throw Exception("Invalid file selected.");
          }
        }

        update();
      } else {
        Helpers.showSnackBar(msg: "No file selected.");
      }
    } catch (e, s) {
      // Error handling
      Helpers.showSnackBar(msg: e.toString());
      if (kDebugMode) {
        print("Error while picking files: $s");
      }
    }
  }

  void removeFileFromProduct(int i, int j) {
    if (productList[i].filePath.isNotEmpty) productList[i].filePath.removeAt(j);
    if (productList[i].fileNames.isNotEmpty)
      productList[i].fileNames.removeAt(j);
    if (productList[i].multiPartList.isNotEmpty)
      productList[i].multiPartList.removeAt(j);
    if (productList[i].oldImgId.isNotEmpty) {
      productList[i].oldImgId.removeAt(j);
    }
    update();
  }

  List<ProductModel> productList = [
    ProductModel(
        titleEditingController: TextEditingController(),
        priceEditingController: TextEditingController(),
        descriptionEditingController: TextEditingController(),
        filePath: [],
        multiPartList: [],
        fileNames: [],
        oldImgId: [])
  ].obs;

  void addProductModel() {
    if (selectedSinglePackage.noOfProduct > 0) {
      selectedSinglePackage.noOfProduct -= 1;
      productList.add(ProductModel(
          titleEditingController: TextEditingController(),
          priceEditingController: TextEditingController(),
          descriptionEditingController: TextEditingController(),
          filePath: [],
          multiPartList: [],
          fileNames: [],
          oldImgId: []));
      Helpers.showSnackBar(title: "Success", msg: "New product slot added");
      update();
    } else {
      Helpers.showSnackBar(
          msg: "You have reached the limit for adding products.");
    }
  }

  void removeProductModel(index) {
    if (productList.length > 1) {
      productList.removeAt(index);
      Helpers.showSnackBar(title: "Success", msg: "Product slot removed");
      selectedSinglePackage.noOfProduct += 1;
      update();
    } else {
      Helpers.showSnackBar(
          msg: "At least one slot must be selected and cannot be deleted.");
    }
  }

  // If the user has modified any value in the product section,
  // all fields within that section must be selected, and all fields should be marked as required.
  // If not modified any value then this from will be count as optional.
  Future productValidation() async {
    onChangedProductItemList.clear();
    for (var x in productList) {
      if (x.titleEditingController.text.isNotEmpty)
        onChangedProductItemList.add(x.titleEditingController.text.toString());

      if (x.priceEditingController.text.isNotEmpty)
        onChangedProductItemList.add(x.priceEditingController.text.toString());

      if (x.descriptionEditingController.text.isNotEmpty)
        onChangedProductItemList
            .add(x.descriptionEditingController.text.toString());

      for (var i in x.filePath) onChangedProductItemList.add(i);
      if (x.singlePath.isNotEmpty)
        onChangedProductItemList.add(x.singlePath.toString());
    }

    update();
  }
  //--------------------Products END-----------//

  //--------------------SEO Start-----------//
  TextEditingController SEOTitleEditingCtrl = TextEditingController();
  TextEditingController SEOKeywordEditingCtrl = TextEditingController();
  TextEditingController SEODescriptionEditingCtrl = TextEditingController();

  String selectedSinglePathFromSEOSection = "";
  List<http.MultipartFile> filesFromSEOSection = [];

  Future<void> pickSEOSection({String? fieldName = ""}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['jpg', 'png', 'jpeg']);

      if (result != null) {
        selectedSinglePathFromSEOSection = result.files.single.path.toString();
        filesFromSEOSection.addAll([
          await http.MultipartFile.fromPath(
              "$fieldName", selectedSinglePathFromSEOSection),
        ]);

        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
      if (kDebugMode) {
        print("Error while picking files: $e");
      }
    }
  }

  List<String> keywordList = [];
  addKeyword() {
    keywordList.add(SEOKeywordEditingCtrl.text);
    SEOKeywordEditingCtrl.clear();
    update();
  }

  removeKeyword(int index) {
    keywordList.removeAt(index);
    update();
  }

  //--------------------SEO END-----------//

  //--------------------Communication Start-----------//
  TextEditingController appIdEditingCtrl = TextEditingController();
  TextEditingController pageIdEditingCtrl = TextEditingController();
  TextEditingController whatsappEditingCtrl = TextEditingController();
  TextEditingController typicallyEditingCtrl = TextEditingController();
  TextEditingController communicationDescriptionEditingCtrl =
      TextEditingController();

  String youtubeUrl =
      "https://www.youtube.com/watch?v=MQszEDuWFeQ&ab_channel=BugFinder";
  Future<void> launchYouTube() async {
    final Uri url = Uri.parse(youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $youtubeUrl';
    }
  }

  //--------------------Communication END-----------//

  //--------------------Custom Form Start-----------//
  TextEditingController formNameEditingCtrl = TextEditingController();
  TextEditingController formButtonEditingCtrl = TextEditingController();
  TextEditingController fieldNameEditingCtrl = TextEditingController();
  dynamic validationType;
  dynamic inputType;

  List<String> inputTypeList = [
    "Text",
    "Textarea",
    "File",
    "Number",
    "Date ",
    "Select",
  ];
  List<String> validationTypeList = [
    "Required",
    "Optional",
  ];

  List<CustomForm> customFromList =
      [CustomForm(fieldName: TextEditingController(), optionsModel: [])].obs;

  void addCustomForm() {
    customFromList
        .add(CustomForm(fieldName: TextEditingController(), optionsModel: []));
    Helpers.showSnackBar(title: "Success", msg: "New Custom Form slot added");
    update();
  }

  removeCustomForm(int i) {
    if (customFromList.length > 1) {
      customFromList.removeAt(i);
      Helpers.showSnackBar(title: 'Success', msg: "Slot removed");
    } else {
      customFromList[i].fieldName.clear();
      customFromList[i].validationType = "";
      customFromList[i].inputType = "";
      Helpers.showSnackBar(
          msg: "At least one slot must be selected and cannot be deleted.");
    }
    update();
  }

  void addOption(List<OptionsModel> optionsModel) {
    optionsModel.add(OptionsModel(
        optionName: TextEditingController(),
        optionVal: TextEditingController()));
    Helpers.showSnackBar(title: "Success", msg: "New option slot added");
    update();
  }

  removeOption(int i, List<OptionsModel> optionsModel) {
    if (optionsModel.length > 1) {
      optionsModel.removeAt(i);
      Helpers.showSnackBar(title: 'Success', msg: "Option Slot removed");
    } else {
      optionsModel.clear();
      Helpers.showSnackBar(
          msg: "At least one slot must be selected and cannot be deleted.");
    }
    update();
  }

  // validation
  List<String> onChangedCustomFormItemList = [];
  bool isInputTypeSelect = false;
  bool isAllOptionFieldFilled = true;

  // If the user modifies any value in the custom form section,
  // all fields within that section must be selected and marked as required.
  // If no modifications are made, the form will be considered and optional.
  Future customFormValidation() async {
    try {
      onChangedCustomFormItemList.clear();

      if (formNameEditingCtrl.text.isNotEmpty)
        onChangedCustomFormItemList.add(formNameEditingCtrl.text);

      if (formButtonEditingCtrl.text.isNotEmpty)
        onChangedCustomFormItemList.add(formButtonEditingCtrl.text);

      for (int i = 0; i < customFromList.length; i += 1) {
        if (customFromList[i].fieldName.text.isNotEmpty)
          onChangedCustomFormItemList.add(customFromList[i].fieldName.text);

        if (customFromList[i].validationType.isNotEmpty)
          onChangedCustomFormItemList.add(customFromList[i].validationType);

        if (customFromList[i].inputType.isNotEmpty)
          onChangedCustomFormItemList.add(customFromList[i].inputType);

        if (customFromList[i].inputType == "Select") {
          isInputTypeSelect = true;

          for (int j = 0; j < customFromList[i].optionsModel.length; j += 1) {
            if ((customFromList[i].optionsModel[j].optionName.text.isEmpty ||
                customFromList[i].optionsModel[j].optionVal.text.isEmpty)) {
              isAllOptionFieldFilled = false;
            } else if (customFromList[i]
                    .optionsModel[j]
                    .optionName
                    .text
                    .isNotEmpty &&
                customFromList[i].optionsModel[j].optionVal.text.isNotEmpty) {
              isAllOptionFieldFilled = true;
            }
          }
        } else {
          isInputTypeSelect = false;
        }
      }
      update();
    } catch (e, s) {
      print(s);
      Helpers.showSnackBar(msg: e.toString());
    }
  }
  //--------------------Custom Form END-----------//

  //--------------------AddListing or UpdateListing Post API Start-----------//
  String listingId = "";
  Future addOrUpdateListing(
      {bool? isFromUpdateListing = false,
      required BuildContext context}) async {
    _isLoading = true;
    update();

    http.Response response = await ListingRepo.addListing(
        isFromUpdateListing: isFromUpdateListing,
        listingId: this.listingId,
        packageId: this.selectedPackageId.toString(),
        fileList: [
          //---photos
          if (selectedSinglePathFromPhotosSection.isNotEmpty &&
              !selectedSinglePathFromPhotosSection.contains("http"))
            await http.MultipartFile.fromPath(
                "thumbnail", selectedSinglePathFromPhotosSection),

          if (selectedFilePathsFromPhotosSection.isNotEmpty)
            for (int i = 0;
                i < selectedFilePathsFromPhotosSection.length;
                i += 1)
              if (!selectedFilePathsFromPhotosSection[i]
                  .toString()
                  .contains("http"))
                await http.MultipartFile.fromPath(
                    "listing_image[$i]", selectedFilePathsFromPhotosSection[i]),

          //---products
          for (int i = 0; i < productList.length; i += 1)
            if (productList[i].singlePath.isNotEmpty &&
                !productList[i].singlePath.toString().contains("http"))
              await http.MultipartFile.fromPath("product_thumbnail[$i]",
                  productList[i].singlePath.toString()),

          for (int i = 0; i < productList.length; i += 1)
            for (int j = 0; j < productList[i].filePath.length; j += 1)
              if (productList[i].filePath.isNotEmpty &&
                  !productList[i].filePath.toString().contains("http"))
                await http.MultipartFile.fromPath(
                    "product_image[${i + 1}][$j]", productList[i].filePath[j]),
          // I have to submit the product images like this index
          //product:1\\ thumb: [0], img: [1][0],[1][1],[1][2]
          //product:2\\ thumb: [1], img: [2][0],[2][1],[2][2]

          //---seo
          if (selectedSinglePathFromSEOSection.isNotEmpty &&
              !selectedSinglePathFromSEOSection.contains("http"))
            await http.MultipartFile.fromPath(
                "seo_image", selectedSinglePathFromSEOSection),
        ],
        fields: {
          //---basic info start--//
          "title": basicInfoTitleEditingCtrlr.text,
          "slug": slugEditingCtrlr.text,
          for (int i = 0; i < selectedCategoryIdList.length; i += 1)
            "category_id[$i]": selectedCategoryIdList[i],
          "email": emailEditingCtrlr.text,
          "phone": phoneEditingCtrlr.text,
          "description": descriptionEditingCtrlr.text,
          "country_id": selectedCountryId,
          "state_id": selectedStateId,
          "city_id": selectedCityId,
          "address": ProfileController.to.isLeafLetMap == true
              ? leafLetSearchEditingCtrl.text
              : searchedPlaceEditingCtrlr.text,
          "lat": latEditingCtrlr.text,
          "long": lngEditingCtrlr.text,
          for (int i = 0; i < businessHours.length; i += 1)
            "working_day[$i]": businessHours[i].selectedWeek,
          for (int i = 0; i < businessHours.length; i += 1)
            "start_time[$i]": businessHours[i].startTime,
          for (int i = 0; i < businessHours.length; i += 1)
            "end_time[$i]": businessHours[i].endTime,
          for (int i = 0; i < socialList.length; i += 1)
            "social_icon[$i]": socialList[i].icon,
          for (int i = 0; i < socialList.length; i += 1)
            "social_url[$i]": socialList[i].url,
          //---basic info end--//

          //---video start--//
          "youtube_video_id": youtubeUrlCtrl.text,
          //---video end--//

          //---photos start--//
          if (isFromUpdateListing == true)
            for (int i = 0; i < photosOldImgIdList.length; i += 1)
              "old_listing_image[$i]": "${photosOldImgIdList[i].toString()}",
          //---photos end--//

          //---amenity start--//
          for (int i = 0; i < selectedAmenityIdList.length; i += 1)
            "amenity_id[$i]": selectedAmenityIdList[i],
          //---amenity end--//

          //---product start--//
          for (int i = 0; i < productList.length; i += 1)
            "product_id[$i]": productList[i].productId.toString(),
          for (int i = 0; i < productList.length; i += 1)
            "product_title[$i]": productList[i].titleEditingController.text,
          for (int i = 0; i < productList.length; i += 1)
            "product_price[$i]": productList[i].priceEditingController.text,
          for (int i = 0; i < productList.length; i += 1)
            "product_description[$i]":
                productList[i].descriptionEditingController.text,

          if (isFromUpdateListing == true)
            for (int i = 0; i < productList.length; i += 1)
              for (int j = 0; j < productList[i].oldImgId.length; j += 1)
                "old_product_image[${productList[i].productId}][$j]":
                    "${productList[i].oldImgId[j].toString()}",
          // "old_product_image[106][0]": "59",

          //---product end--//

          //---seo start--//
          "meta_title": SEOTitleEditingCtrl.text,
          "meta_keywords": keywordList.join(","),
          "meta_description": SEODescriptionEditingCtrl.text,
          //---seo end--//

          //---communication start--//
          "fb_app_id": appIdEditingCtrl.text,
          "fb_page_id": pageIdEditingCtrl.text,
          "whatsapp_number": whatsappEditingCtrl.text,
          "replies_text": typicallyEditingCtrl.text,
          "body_text": communicationDescriptionEditingCtrl.text,
          //---communication end--//

          //---custom form start--//
          "form_name": formNameEditingCtrl.text,
          "form_btn_text": formButtonEditingCtrl.text,
          // Generate a unique key for each custom form field, especially for updates
          // isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1
          for (int i = 0; i < customFromList.length; i += 1)
            // If the user wants to update data, then I have to send the old custom form key number.
            // If the user wants to add a listing or add a new custom form with an existing form,
            // then I have to send the index of the list.
            "field_name[${customFromList[i].keyNumber.isNotEmpty ? customFromList[i].keyNumber : isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1 : i}]":
                customFromList[i].fieldName.text,
          for (int i = 0; i < customFromList.length; i += 1)
            "is_required[${customFromList[i].keyNumber.isNotEmpty ? customFromList[i].keyNumber : isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1 : i}]":
                customFromList[i].validationType.toLowerCase(),
          for (int i = 0; i < customFromList.length; i += 1)
            "input_type[${customFromList[i].keyNumber.isNotEmpty ? customFromList[i].keyNumber : isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1 : i}]":
                customFromList[i].inputType.toLowerCase(),
          for (int i = 0; i < customFromList.length; i += 1)
            for (int j = 0; j < customFromList[i].optionsModel.length; j += 1)
              "option_name[${customFromList[i].keyNumber.isNotEmpty ? customFromList[i].keyNumber : isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1 : i}][$j]":
                  customFromList[i].optionsModel[j].optionName.text,
          for (int i = 0; i < customFromList.length; i += 1)
            for (int j = 0; j < customFromList[i].optionsModel.length; j += 1)
              "option_value[${customFromList[i].keyNumber.isNotEmpty ? customFromList[i].keyNumber : isFromUpdateListing == true ? customFromList[i].keyNumber.contains('${i + i}') ? i + 2 : i + 1 : i}][$j]":
                  customFromList[i].optionsModel[j].optionVal.text,
          //---custom form end--//
        });
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        if (isFromUpdateListing == true) {
          Navigator.pop(context);
          ApiStatus.checkStatus(data['status'], data['data']);
        } else {
          Get.offAllNamed(RoutesName.mainDrawerScreen);
        }
        update();
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!!!");
    }
  }

  Color titleColor = Colors.transparent;
  Color desColor = Colors.transparent;
  Color latColor = Colors.transparent;
  Color lngColor = Colors.transparent;
  Color addrColor = Colors.transparent;
  bool isSubmitBtnTapped = false;
  Future onSubmit(context, {bool? isFromUpdateListing = false}) async {
    isSubmitBtnTapped = true;
    try {
      await basicInfoValidation();
      await productValidation();
      await customFormValidation();
      if (((basicInfoFormKey.currentState?.validate() ?? true) &&
          selectedCountry != null &&
          selectedState != null &&
          selectedCity != null)) {
        // count the modified or onChanged section length
        if (onChangedProductItemList.length > 0 &&
            onChangedProductItemList.length < 5 &&
            isFromUpdateListing == false) {
          Helpers.showSnackBar(msg: "Please fill in all the product fields.");
        } else if ((!isInputTypeSelect &&
                onChangedCustomFormItemList.length > 0 &&
                onChangedCustomFormItemList.length < 5) ||
            (isInputTypeSelect && !isAllOptionFieldFilled) &&
                isFromUpdateListing == false) {
          Helpers.showSnackBar(
              msg: "Please fill in all the Custom form fields.");
        } else {
          await addOrUpdateListing(
              isFromUpdateListing: isFromUpdateListing, context: context);
        }
      } else {
        tabControllFunc(context).index = 0;
        selectedTabIndex = 0;
        Helpers.showSnackBar(
            msg: "Please complete all basic info required fields.");
      }
    } catch (e, s) {
      _isLoading = false;
      update();
      print(s);
      Helpers.showSnackBar(msg: e.toString());
    }

    update();
  }

  TabController tabControllFunc(context) => DefaultTabController.of(context);
  //--------------------AddList Post API END-----------//

  //--------------------EDIT LISTING START-----------//
  // GET EDIT LISTING DATA

  List<editListing.Data> editListingList = [];
  List<String> photosOldImgIdList = [];
  String selectedLat = "0.00";
  String selectedLng = "0.00";
  bool isGettingEdit = false;
  refreshEditListingList() {
    socialList = [];
    keywordList = [];
    urlCtrlList = [];
    productList = [];
    businessHours = [];
    customFromList = [];
    editListingList = [];
    photosOldImgIdList = [];
    selectedAmenityList = [];
    selectedCategoryList = [];
    selectedAmenityIdList = [];
    selectedCategoryIdList = [];
    selectedFilePathsFromPhotosSection = [];
  }

  Future geteditListing({required String listingId}) async {
    isGettingEdit = true;
    update();
    http.Response response =
        await ListingRepo.geteditListing(listingId: listingId);
    isGettingEdit = false;
    refreshEditListingList();
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        try {
          editListingList
              .add(editListing.EditListingModel.fromJson(data).data!);
          if (editListingList.isNotEmpty) {
            var listingData = editListingList[0];

            // get package info
            if (listingData.packageInfo != null) {
              selectedPackageId =
                  int.parse(listingData.packageInfo!.packageId.toString());
              selectedSinglePackage = listingData.packageInfo ?? p.Datum();

              availableListingEditingCtrl.text =
                  selectedSinglePackage.noOfListing.toString();
            }

            //-------------- get basic info data
            if (listingData.listing != null) {
              basicInfoTitleEditingCtrlr.text =
                  listingData.listing!.title ?? "";
              slugEditingCtrlr.text = listingData.listing!.slug ?? "";
              emailEditingCtrlr.text = listingData.listing!.email ?? "";
              phoneEditingCtrlr.text = listingData.listing!.phone == null
                  ? ""
                  : listingData.listing!.phone.toString();
              descriptionEditingCtrlr.text =
                  listingData.listing!.description ?? "";
            }

            // category list
            if (listingData.listing != null &&
                listingData.listing!.categoryId != null) {
              for (int i = 0;
                  i < listingData.listing!.categoryId!.length;
                  i += 1) {
                var l = listingCategoryList
                    .where((e) =>
                        e.id.toString() ==
                        listingData.listing!.categoryId![i].toString())
                    .toList();
                for (var j in l) {
                  selectedCategoryList.add(j.name.toString());
                  selectedCategoryIdList.add(j.id.toString());
                }
              }
            }

            // location
            if (listingData.listing != null) {
              // country
              if (listingData.listing!.countryId.toString() != "null") {
                var lCountry = countryList.firstWhere((e) {
                  return e.id.toString() ==
                      listingData.listing!.countryId.toString();
                });
                selectedCountry = lCountry.name!.toString();
                selectedCountryId = lCountry.id!.toString();
                await getStateList(countryId: selectedCountryId);
              }

              // state
              if (listingData.listing!.stateId.toString() != "null") {
                var lState = stateList.firstWhere((e) {
                  return e.id.toString() ==
                      listingData.listing!.stateId.toString();
                });
                selectedState = lState.name!.toString();
                selectedStateId = lState.id!.toString();
                await getCityList(StateId: selectedStateId);
              }

              // city
              if (listingData.listing!.cityId.toString() != "null") {
                var lCity = cityList.firstWhere((e) {
                  return e.id.toString() ==
                      listingData.listing!.cityId.toString();
                });
                selectedCity = lCity.name!.toString();
                selectedCityId = lCity.id!.toString();

                selectedLat = listingData.listing!.lat ?? "0.00";
                selectedLng = listingData.listing!.long ?? "0.00";
              }

              // if user is not from Alllisting page
              if (isAllCities == false) {
                if (ProfileController.to.isLeafLetMap != true) {
                  searchedPlaceEditingCtrlr.text = selectedCity ?? "";
                }
                if (ProfileController.to.isLeafLetMap == true) {
                  leafLetSearchEditingCtrl.text = selectedCity ?? "";
                }
              }

              latEditingCtrlr.text = listingData.listing!.lat ?? "$defaultLat";
              lngEditingCtrlr.text = listingData.listing!.long ?? "$defaultLng";
              basicInfoValidation();
            }

            // business hour
            if (listingData.businessHours != null) {
              for (var i in listingData.businessHours!) {
                businessHours.add(BusinessHourModel(
                    selectedWeek: i.workingDay ?? "",
                    startTime: i.startTime == null || i.startTime == ""
                        ? ""
                        : i.startTime.toString() == "00:00:00"
                            ? ""
                            : DateFormat("h:mm a").format(DateFormat("HH:mm:ss")
                                .parse(i.startTime.toString())),
                    endTime: i.endTime == null || i.endTime == ""
                        ? ""
                        : i.endTime.toString() == "00:00:00"
                            ? ""
                            : DateFormat("h:mm a").format(DateFormat("HH:mm:ss")
                                .parse(i.endTime.toString()))));
              }
            }
            // add default value if business hour is empty
            if (listingData.businessHours == null ||
                listingData.businessHours!.isEmpty) {
              businessHours = [BusinessHourModel()].obs;
            }

            // social links and icons
            if (listingData.socialLinks != null) {
              for (var i in listingData.socialLinks!) {
                socialList.add(SocialModel(
                    icon: i.socialIcon ?? "", url: i.socialUrl ?? ""));
                urlCtrlList.add(TextEditingController(text: i.socialUrl ?? ""));
              }
            }
            // add default value if socialLink is empty
            if (listingData.socialLinks == null ||
                listingData.socialLinks!.isEmpty) {
              socialList = [SocialModel()].obs;
            }

            // ----------------video
            youtubeUrlCtrl.text = listingData.listing == null
                ? ""
                : listingData.listing!.youtubeVideoId ?? "";
            youtubePlayerController = YoutubePlayerController(
              initialVideoId: listingData.listing == null
                  ? ""
                  : listingData.listing!.youtubeVideoId ?? "",
              flags: YoutubePlayerFlags(autoPlay: false),
            );

            // ----------------photo
            selectedSinglePathFromPhotosSection = listingData.listing == null
                ? ""
                : listingData.listing!.thumbnail ?? "";
            if (listingData.listingImages != null) {
              for (var i in listingData.listingImages!) {
                selectedFilePathsFromPhotosSection
                    .add(i.listingImage.toString());
                photosOldImgIdList.add(i.id.toString());
              }
            }

            // -----------------amenities
            if (listingData.listingAminities != null) {
              for (var i in listingData.listingAminities!) {
                selectedAmenityIdList.add(i.toString());
                var l = amenitiList
                    .where((e) => e.id.toString() == i.toString())
                    .toList();
                for (var j in l) {
                  selectedAmenityList.add(j.name);
                }
              }
            }

            // -----------------products
            if (listingData.listingProducts != null) {
              for (var i in listingData.listingProducts!) {
                List<dynamic> filePath = [];
                List<dynamic> imgIdList = [];

                for (var j in i.productImages!) {
                  filePath.add(j.productImage ?? "");
                  imgIdList.add(j.id.toString());
                }
                productList.add(ProductModel(
                  productId: i.id.toString(),
                  titleEditingController:
                      TextEditingController(text: i.productTitle ?? ""),
                  priceEditingController:
                      TextEditingController(text: i.productPrice.toString()),
                  descriptionEditingController:
                      TextEditingController(text: i.productDescription ?? ""),
                  singlePath: i.productThumbnail ?? "",
                  filePath: filePath,
                  fileNames: [],
                  result: null,
                  multiPartList: [],
                  oldImgId: imgIdList,
                ));
              }
            }
            // add default value if product is empty
            if (listingData.listingProducts == null ||
                listingData.listingProducts!.isEmpty) {
              productList = [
                ProductModel(
                    titleEditingController: TextEditingController(),
                    priceEditingController: TextEditingController(),
                    descriptionEditingController: TextEditingController(),
                    filePath: [],
                    multiPartList: [],
                    fileNames: [],
                    oldImgId: [])
              ].obs;
            }

            // -----------------seo
            if (listingData.listingSeo != null) {
              SEOTitleEditingCtrl.text =
                  listingData.listingSeo!.metaTitle ?? "";
              keywordList = listingData.listingSeo!.metaKeywords
                  .toString()
                  .split(',')
                  .map((keyword) => keyword.trim())
                  .toList();
              SEODescriptionEditingCtrl.text =
                  listingData.listingSeo!.metaDescription ?? "";
              selectedSinglePathFromSEOSection =
                  listingData.listingSeo!.seoImage ?? "";
            }

            // -----------------communication
            if (listingData.listing != null) {
              appIdEditingCtrl.text = listingData.listing!.fbAppId ?? "";
              pageIdEditingCtrl.text = listingData.listing!.fbPageId ?? "";
              whatsappEditingCtrl.text =
                  listingData.listing!.whatsappNumber ?? "";
              typicallyEditingCtrl.text =
                  listingData.listing!.repliesText ?? "";
              communicationDescriptionEditingCtrl.text =
                  listingData.listing!.bodyText ?? "";
            }

            // -----------------custom form
            if (data['data']['listing_form'] != null &&
                data['data']['listing_form'] is Map) {
              Map formData = data['data']['listing_form'];
              formNameEditingCtrl.text = formData['name'] ?? "";
              formButtonEditingCtrl.text = formData['button_text'] ?? "";

              if (formData['input_form'] != null &&
                  formData['input_form'] is Map) {
                Map<String, dynamic> formMap = formData['input_form'];

                for (var i in formMap.entries) {
                  List<OptionsModel> optionList = [];
                  if (i.value['option'] != null) {
                    Map optionMap = i.value['option'];
                    for (var j in optionMap.entries) {
                      optionList.add(OptionsModel(
                          optionName:
                              TextEditingController(text: j.value ?? ""),
                          optionVal:
                              TextEditingController(text: j.value ?? "")));
                    }
                  }

                  customFromList.add(CustomForm(
                    keyNumber: i.key.toString(),
                    fieldName:
                        TextEditingController(text: i.value['field_name']),
                    inputType: i.value['type'].toString().toCapital(),
                    validationType:
                        i.value['validation'].toString().toCapital(),
                    optionsModel: optionList,
                  ));
                }
              } else {
                // add default value if custom from is empty
                customFromList = [
                  CustomForm(
                      fieldName: TextEditingController(), optionsModel: [])
                ].obs;
              }
            }
            // add default value if custom from is empty
            if (data['data']['listing_form'] == null) {
              customFromList = [
                CustomForm(fieldName: TextEditingController(), optionsModel: [])
              ].obs;
            }
          }
          Get.back();

          // check if the leaflet map properly initiated or not
          // if once the mapController initiated then increase the value
          leafletMapViewCount += 1;

          Get.to(() => AddListingScreen(isFromEditListing: true));
          update();
        } catch (e, s) {
          isGettingEdit = false;
          update();
          print(s);
          Helpers.showSnackBar(msg: e.toString());
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      editListingList = [];
    }
  }

  refreshAllValue() {
    selectedPurchasePackage = null;
    availableListingEditingCtrl.clear();
    businessHours.clear();
    socialList.clear();
    productList.clear();
    customFromList.clear();
    businessHours = [BusinessHourModel()].obs;
    socialList = [SocialModel()].obs;
    productList = [
      ProductModel(
          titleEditingController: TextEditingController(),
          priceEditingController: TextEditingController(),
          descriptionEditingController: TextEditingController(),
          filePath: [],
          multiPartList: [],
          fileNames: [],
          oldImgId: [])
    ].obs;
    customFromList =
        [CustomForm(fieldName: TextEditingController(), optionsModel: [])].obs;
    selectedSinglePathFromPhotosSection = "";
    selectedSinglePathFromSEOSection = "";
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    selectedCountryId = null;
    selectedCountryId = null;
    selectedStateId = null;
    selectedCityId = null;
    selectedFilePathsFromPhotosSection.clear();
    selectedCategoryList.clear();
    selectedCategoryIdList.clear();
    basicInfoTitleEditingCtrlr.clear();
    slugEditingCtrlr.clear();
    emailEditingCtrlr.clear();
    phoneEditingCtrlr.clear();
    descriptionEditingCtrlr.clear();
    leafLetSearchEditingCtrl.clear();
    searchedPlaceEditingCtrlr.clear();
    latEditingCtrlr.clear();
    lngEditingCtrlr.clear();
    youtubeUrlCtrl.clear();
    photosOldImgIdList.clear();
    selectedAmenityList.clear();
    selectedAmenityIdList.clear();
    SEOTitleEditingCtrl.clear();
    SEODescriptionEditingCtrl.clear();
    keywordList.clear();
    appIdEditingCtrl.clear();
    pageIdEditingCtrl.clear();
    whatsappEditingCtrl.clear();
    typicallyEditingCtrl.clear();
    communicationDescriptionEditingCtrl.clear();
    formNameEditingCtrl.clear();
    formButtonEditingCtrl.clear();
    appIdEditingCtrl.clear();
    appIdEditingCtrl.clear();
    appIdEditingCtrl.clear();
    update();
  }
  //--------------------EDIT LISTING END-----------//

  //--------------------FRONTEND LISTING DEMO SECTION START-----------//
  TextEditingController searchCtrl = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  resetFrontendSearchData() {
    FrontendListingController.to.searchEditingCtrlr.clear();
    selectedCountryId = null;
    selectedCityId = null;
    selectedCountry = null;
    selectedCity = null;
    selectedCategory = null;
    selectedCategoryId = "";
    selectedCategoryIndex = 0;
    update();
  }

  //--------------------FRONTEND LISTING DEMO SECTION END-----------//

  @override
  void onInit() {
    if (HiveHelp.read(Keys.token) != null) getPurchasePackage();
    if (HiveHelp.read(Keys.token) == null)
      getCityList(StateId: '', isAllCities: true);
    getListingCategories();
    getCountryList();
    getAmenitiesList();
    super.onInit();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }
}

class BusinessHourModel {
  String selectedWeek = "";
  String startTime = "";
  String endTime = "";
  BusinessHourModel(
      {this.selectedWeek = "", this.startTime = "", this.endTime = ""});
}

class SocialModel {
  String icon = "";
  String url = "";
  SocialModel({this.icon = "", this.url = ""});
}

class ProductModel {
  String productId = "0";
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  List<dynamic> filePath = [];
  List<dynamic> oldImgId = [];
  List<http.MultipartFile> multiPartList = [];
  String singlePath = "";
  FilePickerResult? result = null;
  List<String> fileNames = [];
  ProductModel(
      {required this.titleEditingController,
      required this.priceEditingController,
      required this.descriptionEditingController,
      required this.filePath,
      required this.multiPartList,
      this.singlePath = "",
      this.productId = "",
      this.result,
      required this.fileNames,
      required this.oldImgId});
}

class CustomForm {
  String keyNumber = "";
  String inputType = "";
  String validationType = "";
  TextEditingController fieldName = TextEditingController();
  List<OptionsModel> optionsModel;
  CustomForm({
    this.keyNumber = "",
    this.inputType = "",
    this.validationType = "",
    required this.fieldName, 
    required this.optionsModel,
  });
}

class OptionsModel {
  TextEditingController optionName = TextEditingController();
  TextEditingController optionVal = TextEditingController();
  OptionsModel({required this.optionName, required this.optionVal});
}
