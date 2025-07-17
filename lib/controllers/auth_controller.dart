import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/repositories/auth_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';
import '../views/screens/auth/login_screen.dart';
import 'transaction_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  bool isLoading = false;

  // -----------------------sign in--------------------------
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController signInPassEditingController = TextEditingController();

  String userNameVal = "";
  String singInPassVal = "";
  bool isRemember = false;

  clearSignInController() {
    userNameEditingController.clear();
    signInPassEditingController.clear();
    userNameVal = "";
    singInPassVal = "";
  }

  Future login() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.login(data: {
      "username": userNameVal,
      "password": singInPassVal,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        ApiStatus.checkStatus(data['status'], data['data']['message']);
        if (isRemember == true) {
          HiveHelp.write(Keys.userName, userNameVal);
          HiveHelp.write(Keys.userPass, singInPassVal);
        }
        HiveHelp.write(Keys.token, data['data']['token']);
        TransactionController.to.getTransactionList(
            page: 1, transaction_id: "", date: "", remark: "");
        Get.offAllNamed(RoutesName.mainDrawerScreen);
        clearSignInController();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  // -----------------------sign up--------------------------
  TextEditingController signupFirstNameEditingController =
      TextEditingController();
  TextEditingController signupLastNameEditingController =
      TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController signUpUserNameEditingController =
      TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController signUpPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();

  String signupFirstNameVal = "";
  String signupLastNameVal = "";
  String signUpUserNameVal = "";
  String emailVal = "";
  String phoneNumberVal = "";
  String signUpPassVal = "";
  String signUpConfirmPassVal = "";
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';

  clearSignUpController() {
    emailEditingController.clear();
    signUpUserNameEditingController.clear();
    signupFirstNameEditingController.clear();
    signupLastNameEditingController.clear();
    phoneNumberEditingController.clear();
    signUpPassEditingController.clear();
    confirmPassEditingController.clear();
    signupFirstNameVal = "";
    signupLastNameVal = "";
    signUpUserNameVal = "";
    emailVal = "";
    phoneNumberVal = "";
    signUpPassVal = "";
    signUpConfirmPassVal = "";
  }

  Future register() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.register(data: {
      "firstname": signupFirstNameVal,
      "lastname": signupLastNameVal,
      "username": signUpUserNameVal,
      'email': emailEditingController.text,
      'country_code': countryCode,
      "phone_code": phoneCode,
      "country": countryName,
      "phone": phoneNumberVal,
      "password": signUpPassVal,
      "password_confirmation": signUpConfirmPassVal
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        ApiStatus.checkStatus(data['status'], data['data']['message']);
        HiveHelp.write(Keys.token, data['data']['token']);
        Get.offAllNamed(RoutesName.mainDrawerScreen);
        clearSignUpController();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //------------------------forgot password----------------------
  TextEditingController forgotPassEmailEditingController =
      TextEditingController();
  TextEditingController forgotPassNewPassEditingController =
      TextEditingController();
  TextEditingController forgotPassConfirmPassEditingController =
      TextEditingController();
  TextEditingController otpEditingController1 = TextEditingController();
  TextEditingController otpEditingController2 = TextEditingController();
  TextEditingController otpEditingController3 = TextEditingController();
  TextEditingController otpEditingController4 = TextEditingController();
  TextEditingController otpEditingController5 = TextEditingController();

  String forgotPassEmailVal = "";
  String forgotPassNewPassVal = "";
  String forgotPassConfirmPassVal = "";
  String otpVal1 = "";
  String otpVal2 = "";
  String otpVal3 = "";
  String otpVal4 = "";
  String otpVal5 = "";

  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  forgotPassNewPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  forgotPassConfirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  clearForgotPassVal() {
    forgotPassEmailEditingController.clear();
    forgotPassEmailVal = "";
  }

  clearForgotPassNewPassVal() {
    forgotPassNewPassEditingController.clear();
    forgotPassConfirmPassEditingController.clear();
    forgotPassNewPassVal = "";
    forgotPassConfirmPassVal = "";
  }

  clearForgotPassOtpVal() {
    otpEditingController1.clear();
    otpEditingController2.clear();
    otpEditingController3.clear();
    otpEditingController4.clear();
    otpEditingController5.clear();
    otpVal1 = "";
    otpVal2 = "";
    otpVal3 = "";
    otpVal4 = "";
    otpVal5 = "";
  }

  bool isPassReset = false;
  Future forgotPass(
      {required BuildContext context,
      required TextTheme t,
      required AuthController controller}) async {
    isPassReset = true;
    update();

    http.Response response = await AuthRepo.forgotPass(data: {
      "email": forgotPassEmailEditingController.text,
    });

    isPassReset = false;
    update();

    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        ApiStatus.checkStatus(data['status'], data['data']['message']);
        Navigator.pop(context);
        buildOtpDialog(context, t, controller);
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //----------------------verify email-----------------
  ///COUNT DOWN TIMER
  int counter = 60;
  late Timer timer;
  bool isStartTimer = false;
  Duration duration = const Duration(seconds: 1);

  void startTimer() {
    timer = Timer.periodic(duration, (timer) {
      if (counter > 0) {
        counter -= 1;
        isStartTimer = true;
        update();
      } else {
        timer.cancel();
        counter = 60;
        isStartTimer = false;
        update();
      }
    });
  }

  String token = "";
  Future geCode(
      {required BuildContext context,
      required TextTheme t,
      required AuthController controller}) async {
    isPassReset = true;
    update();
    http.Response response = await AuthRepo.getCode(data: {
      "email": forgotPassEmailEditingController.text,
      "code": '${otpVal1 + otpVal2 + otpVal3 + otpVal4 + otpVal5}',
    });
    isPassReset = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success' &&
          data['data'] != null &&
          data['data']['token'] != null) {
        token = data['data']['token'];
        Navigator.pop(context);
        buildNewPassDialog(context, t, controller);
        clearForgotPassOtpVal();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  Future updatePass() async {
    isPassReset = true;
    update();
    http.Response response = await AuthRepo.updatePass(data: {
      "password": forgotPassNewPassEditingController.text,
      "password_confirmation": forgotPassConfirmPassEditingController.text,
      "token": this.token,
    });
    isPassReset = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['data']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.loginScreen);
        clearForgotPassNewPassVal();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }
}
