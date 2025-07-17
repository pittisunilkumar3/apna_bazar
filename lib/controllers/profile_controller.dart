import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/app_colors.dart';
import '../data/models/language_model.dart' as language;
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  bool isLoading = false;

  // -----------------------edit profile--------------------------
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController addressEditingController1 = TextEditingController();
  TextEditingController addressEditingController2 = TextEditingController();
  TextEditingController deleteEditingController = TextEditingController();

  Future validateEditProfile(context) async {
    if (firstNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'First Name is required');
    } else if (lastNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'Last Name is required');
    } else if (userNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'User Name is required');
    } else if (phoneNumberEditingController.text.isEmpty) {
      Helpers.showSnackBar(msg: 'Phone Nubmer is required');
    } else {
      await updateProfile(context);
    }
  }

  String base_currency = "";
  String currency_symbol = "";
  List<Profile> profileList = [];
  List<language.Language> languageList = [];
  String userId = '';
  String userPhoto = '';
  String userName = '';
  String join_date = '';
  String addressVerificationMsg = "";
  String selectedLanguage = "English";
  String selectedLanguageId = "1";
  bool isLanguageSelected = false;
  String userEmail = "";
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';
  String languageId = "1";
  String website = "";
  bool isLeafLetMap = false;

  //--- get profile
  String totalFollowers = "";
  String totalFollowing = "";
  String totalViews = "";
  Future getProfile() async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.getProfile();
    profileList.clear();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        totalFollowers =
            data == null ? "" : data['data']['profile']['views'].toString();
        totalFollowing =
            data == null ? "" : data['data']['profile']['follower'].toString();
        totalViews =
            data == null ? "" : data['data']['profile']['following'].toString();
        base_currency =
            data == null ? "" : data['data']['base_currency'].toString();
        currency_symbol =
            data == null ? "" : data['data']['currency_symbol'].toString();
        HiveHelp.write(Keys.isLeafletMap,
            data['data']['is_google_map'].toString() == "0" ? true : false);
        isLeafLetMap = HiveHelp.read(Keys.isLeafletMap);
        HiveHelp.write(Keys.baseCurrency, base_currency);
        HiveHelp.write(Keys.currencySymbol, currency_symbol);
        if (data['data']['profile'] != null)
          profileList.add(ProfileModel.fromJson(data).data!.profile!);
        languageId = data['data']['profile']['language_id'] == null
            ? "1"
            : data['data']['profile']['language_id'].toString();
        website = data['data']['profile']['website'].toString();
        if (profileList.isNotEmpty) {
          var data = profileList[0];
          await _getInfo(data);
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  _getInfo(Profile? data) {
    userId = data == null ? '' : data.id.toString();
    userName = data == null ? '' : data.firstname! + " " + data.lastname!;
    userEmail = data == null ? '' : data.email ?? '';
    userPhoto = data == null ? '' : data.image ?? "";
    firstNameEditingController.text = data == null ? '' : data.firstname ?? "";
    lastNameEditingController.text = data == null ? '' : data.lastname ?? "";
    userNameEditingController.text = data == null ? '' : data.username ?? "";
    emailEditingController.text = data == null ? '' : data.email ?? "";
    phoneNumberEditingController.text = data == null ? '' : data.phone ?? "";
    addressEditingController1.text = data == null ? '' : data.address_one ?? "";
    addressEditingController2.text = data == null ? '' : data.address_two ?? "";
    selectedLanguageId = data == null
        ? "1"
        : data.languageId == null
            ? "1"
            : data.languageId.toString();
    phoneCode = data == null ? "" : data.phoneCode ?? "";
    countryName = data == null ? "" : data.country ?? "";
    countryCode = data == null ? "" : data.countryCode ?? "";
    join_date = data == null ? '' : data.created_at ?? "";

    HiveHelp.write(Keys.userEmail, userEmail);
    HiveHelp.write(Keys.userFullName,
        firstNameEditingController.text + " " + lastNameEditingController.text);
    HiveHelp.write(Keys.UNIQUE_ID, join_date);
    HiveHelp.write(Keys.userPhone, phoneNumberEditingController.text);
    HiveHelp.write(Keys.userId, data == null ? "1" : data.id.toString());
  }

//--- update profile
  bool isUpdateProfile = false;
  Future updateProfile(context) async {
    isUpdateProfile = true;
    update();
    http.Response response = await ProfileRepo.profileUpdate(data: {
      "first_name": firstNameEditingController.text,
      "last_name": lastNameEditingController.text,
      "username": userNameEditingController.text,
      "email": emailEditingController.text,
      "phone": phoneNumberEditingController.text,
      "language_id": selectedLanguageId,
      "address_one": addressEditingController1.text,
      "address_two": addressEditingController2.text,
      "phone_code": phoneCode,
      "country": countryName,
      "country_code": countryCode,
      "bio": "",
      "city": "",
      "state": "",
      "zip_code": "",
    });
    isUpdateProfile = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        await getProfile();
        getLanguageList();
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //--- get language list
  Future getLanguageList() async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.getLanguageList();
    languageList.clear();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        languageList = [
          ...languageList,
          ...?language.LanguageModel.fromJson(data).data!.languages
        ];
        if (languageList.isNotEmpty) {
          var l = languageList.firstWhere((e) => e.id.toString() == languageId);
          selectedLanguage = l.name.toString();
          update();
        }
      } else {
        Helpers.showSnackBar(msg: '${data['data']}');
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  var selectedLanguageInitialVal;
  onChangedLanguage(value) async {
    selectedLanguageInitialVal = value;
    language.Language selectedList = await languageList
        .firstWhere((e) => e.name.toString() == value.toString());
    selectedLanguageId = selectedList.id.toString();
    isLanguageSelected = true;
    update();
  }

  XFile? pickedImage;
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: source);
    final File imageFile = File(pickedImageFile!.path);
    final int fileSizeInBytes = await imageFile.length();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    pickedImage = pickedImageFile;
    if (pickedImage != null) {
      if (fileSizeInMB >= 4) {
        Helpers.showSnackBar(
            msg: "Image size exceeds 4 MB. Please choose a smaller image.");
      } else {
        await ProfileController.to
            .updateProfilePhoto(filePath: pickedImage!.path);
      }
    }
    update();
  }

  bool isUploadingPhoto = false;
  Future updateProfilePhoto({required String filePath}) async {
    isUploadingPhoto = true;
    update();
    http.Response response = await ProfileRepo.profileImageUpload(fields: {
      "first_name": firstNameEditingController.text,
      "last_name": lastNameEditingController.text,
      "username": userNameEditingController.text,
      "email": emailEditingController.text,
      "phone": phoneNumberEditingController.text,
      "language_id": selectedLanguageId,
      "address_one": addressEditingController1.text,
      "address_two": addressEditingController2.text,
      "phone_code": phoneCode,
      "country": countryName,
      "country_code": countryCode,
      "bio": "",
      "city": "",
      "state": "",
      "zip_code": "",
    }, files: await http.MultipartFile.fromPath('image', filePath));
    isUploadingPhoto = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        await getProfile();
        await getLanguageList();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //--------------------------change password--------------------------
  TextEditingController currentPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmEditingController = TextEditingController();

  RxString currentPassVal = "".obs;
  RxString newPassVal = "".obs;
  RxString confirmPassVal = "".obs;

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  void validateUpdatePass(context) async {
    if (newPassVal.value != confirmPassVal.value) {
      Helpers.showSnackBar(
          msg: "New Password and Confirm Password didn't match!");
    } else {
      await updateProfilePass(context);
    }
  }

  clearChangePasswordVal() {
    currentPassEditingController.clear();
    newPassEditingController.clear();
    confirmEditingController.clear();
    currentPassVal.value = '';
    newPassVal.value = '';
    confirmPassVal.value = '';
  }

  Future updateProfilePass(context) async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.profilePassUpdate(data: {
      "current_password": currentPassVal.value,
      "password": newPassVal.value,
      "password_confirmation": confirmPassVal.value,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        clearChangePasswordVal();
        Navigator.of(context).pop();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //--- delete account
  bool isDeleteAccount = false;
  Color deleteFieldColor = AppColors.sliderInActiveColor;
  Future deleteAccount({required String userId}) async {
    isDeleteAccount = true;
    update();
    http.Response response = await ProfileRepo.deleteAccount(userId: userId);
    isDeleteAccount = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        HiveHelp.cleanall();
        deleteFieldColor = AppColors.sliderInActiveColor;
        deleteEditingController.clear();
        Get.offAllNamed(RoutesName.loginScreen);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }
}
