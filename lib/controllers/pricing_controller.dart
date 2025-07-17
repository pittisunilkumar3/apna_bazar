import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config/app_colors.dart';
import '../data/models/gateways_model.dart';
import '../data/models/package_model.dart' as p;
import '../data/repositories/pricing_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../routes/routes_name.dart';
import '../utils/app_constants.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';
import '../views/screens/pricing/card_payment/card_payment_screen.dart';
import '../views/screens/pricing/manual_payment_screen.dart';
import '../views/screens/pricing/payment_success_screen.dart';
import '../views/screens/pricing/paynow_webview_screen.dart';
import '../views/widgets/app_payment_fail.dart';

class PricingController extends GetxController {
  static PricingController get to => Get.find<PricingController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int selectedIndex = -1;
  bool isExpandable = false;

  List<p.Datum> pricingList = [];
  Future getPackageList() async {
    _isLoading = true;
    update();
    http.Response response = await PricingRepo.getPackageList();
    _isLoading = false;
    pricingList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        pricingList = [...pricingList, ...?p.PackageModel.fromJson(data).data];
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      pricingList = [];
    }
  }

  String planId = "";
  String purchaseId = "";
  String type = "";
  Future pricingPlanPayment(
      {required String packageId, required BuildContext context}) async {
    isLoadingPaymentSheet = true;
    update();
    http.Response response =
        await PricingRepo.pricingPlanPayment(id: packageId);
    isLoadingPaymentSheet = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        if (data['data'] != null) {
          planId =
              data['data']['plan_id'] == null ? "" : data['data']['plan_id'];
          purchaseId = data['data']['purchase_id'] == null
              ? ""
              : data['data']['purchase_id'];
          type = data['data']['type'] == null ? "" : data['data']['type'];
        } else {
          Helpers.showSnackBar(msg: "Something went wrong! Try again later.");
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    }
  }

  TextEditingController amountCtrl = TextEditingController();

  Future getPaymentGateways() async {
    _isLoading = true;
    update();
    http.Response response = await PricingRepo.getGateways();
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        await getPaymentGateway(data);
        listenRazorPay();

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['data']);
      update();
    }
  }

  bool isSearchTapped = false;

  int selectedGatewayIndex = -1;
  bool isLoadingDetails = false;
  TextEditingController gatewayEditingController = TextEditingController();

  //----GET PAYMENT GATEWAY DATA
  int selectedGatewayType = 0;
  Future getGatewayData(index) async {
    //---GATEWAY DATA
    Gateways data = isGatewaySearching
        ? searchedGatewayItem[index]
        : paymentGatewayList[index];
    gatewayName = data.name;
    // get the selected list and filter it
    var selectedGatewayElement =
        await paymentGatewayList.where((e) => e.name == data.name).toList();
    for (var i in selectedGatewayElement) {
      // check which type of gateway is selected
      // 1 = manual payement; 2 = other payment; 3 = card payment
      if (i.id! > 999) {
        selectedGatewayType = 1;
      } else if (i.code.toString().trim().toLowerCase() == "securionpay" ||
          i.code.toString().trim().toLowerCase() == "authorize.net" ||
          i.code.toString().trim().toLowerCase() == "authorizenet") {
        selectedGatewayType = 3;
      } else {
        selectedGatewayType = 2;
      }
    }
  }

  bool isShopDetailsLoading = false;
  List<Gateways> paymentGatewayList = [];
  List<ManualPaymentDynamicFormModel> manualPaymentElementList = [];

  bool is_crypto = false;
  Future getPaymentGateway(data) async {
    // if the payment gateways are from add fund and gateway field is null
    if (data['data'] is List) {
      paymentGatewayList = [];

      paymentGatewayList.addAll(GatewayModel.fromJson(data).gateways!);

      getNeededGatewayKeys(data['data']);
      // filter manual payment list
      manualPaymentElementList = [];
      List allList = data['data'];
      var manualList = allList.where((e) => e['id'] > 999).toList();
      // filter the dynamic field data of manual payments
      Map<String, dynamic> fieldList = {};
      for (var i in manualList) {
        fieldList.addAll(i['parameters']);
        fieldList.forEach((key, value) {
          manualPaymentElementList.add(ManualPaymentDynamicFormModel(
            gatewayName: i['name'],
            note: i['note'] ?? "",
            fieldName: value['field_name'],
            fieldLevel: value['field_label'],
            type: value['type'],
            validation: value['validation'],
          ));
        });
      }
      update();
    }
  }

  List<Gateways> searchedGatewayItem = [];
  bool isGatewaySearching = false;
  TextEditingController gatewaySearchCtrl = TextEditingController();
  queryPaymentGateway(String v) {
    searchedGatewayItem = paymentGatewayList
        .where((e) => e.name.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    selectedGatewayIndex = -1;
    if (v.isEmpty) {
      isGatewaySearching = false;
      searchedGatewayItem.clear();
      update();
    } else if (v.isNotEmpty) {
      isGatewaySearching = true;
      update();
    }
    update();
  }

  int gatewayId = 0;
  String gatewayName = "";
  String gatewayCode = "";
  dynamic selectedCurrency = "USD";
  dynamic selectedCryptoCurrency = null;
  String baseCurrency = "";
  List<ReceivableCurrencies> receivableCurrencies = [];
  List<dynamic> supportedCurrencyList = [];

  Future getSelectedGatewayData(index,
      {bool? isFromMoneyTransferPage = true}) async {
    var data = isGatewaySearching == true
        ? searchedGatewayItem[index]
        : paymentGatewayList[index];
    gatewayId = data.id;
    gatewayName = data.name;
    gatewayCode = data.code.toString().trim().toLowerCase();
    if (data.currency_type.toString() == "0") {
      is_crypto = true;
    }
    if (data.currency_type.toString() == "1") {
      is_crypto = false;
    }

    // get the selected payment gateway's currency for getting the min, max, charge
    receivableCurrencies = [];
    if (data.receivableCurrencies != null) {
      receivableCurrencies = data.receivableCurrencies!;
    }
    // get the supported currencies for displaying in the payout page
    supportedCurrencyList = [];
    if (data.supportedCurrency != null) {
      supportedCurrencyList = data.supportedCurrency!;
      if (supportedCurrencyList.isNotEmpty) {
        // check the stripe gateway and fixed currency for SDK's payment
        if (gatewayCode.trim().toLowerCase() == "stripe") {
          selectedCurrency = "USD";
          supportedCurrencyList = ["USD"];
          await getSelectedCurrencyData(selectedCurrency);

          update();
        }
        // if the payment gateway is other and not stripe
        else {
          selectedCurrency = supportedCurrencyList[0].toString();
          await getSelectedCurrencyData(selectedCurrency);
        }
      } else {
        Helpers.showSnackBar(msg: "No supported currency found!");
      }
    }

    update();
  }

  // this value is for send amount of SDK's gateway
  String sendAmount = "0";

  String amountValue = "";

  // get the selected currency data
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String charge = "0.00";
  String conversion_rate = "0.00";
  String percentage = "0";
  Future getSelectedCurrencyData(value) async {
    var selectedCurr = await receivableCurrencies.firstWhere((e) {
      if (e.name != null)
        return e.name == value;
      else {
        return e.currency == value;
      }
    });
    minAmount = selectedCurr.minLimit.toString();
    maxAmount = selectedCurr.maxLimit.toString();
    charge = selectedCurr.fixedCharge.toString();
    conversion_rate = selectedCurr.conversionRate.toString();
    percentage = selectedCurr.percentageCharge.toString();
    await calculatePayableAmount();
    update();
  }

  // calculate total payable amount
  String amountInSelectedCurr = "0.00";
  String amountInSelectedCurrInCrypto = "0.00";
  String payableAmount = "0.00";
  String payableAmountInCrypto = "0.00";
  String amountInBaseCurr = "0.00";
  calculatePayableAmount() {
    try {
      if (amountValue.isNotEmpty && selectedCurrency != null) {
        amountInSelectedCurr = ((double.parse(amountValue.toString())) *
                double.parse(conversion_rate))
            .toStringAsFixed(2);

        sendAmount = amountInSelectedCurr;
        payableAmount =
            ((double.parse(amountInSelectedCurr) + double.parse(charge)))
                .toStringAsFixed(2);
        amountInBaseCurr = (((double.parse(charge.toString())) /
                    double.parse(conversion_rate)) +
                double.parse(amountValue))
            .toStringAsFixed(2);

        // if the gateway type is crypto
        amountInSelectedCurrInCrypto = ((double.parse(amountValue.toString())) *
                double.parse(conversion_rate))
            .toStringAsFixed(5);
        payableAmountInCrypto = ((double.parse(amountInSelectedCurrInCrypto) +
                double.parse(charge)))
            .toStringAsFixed(5);
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
    }
  }

  final formKey = GlobalKey<FormState>();

  //---------------------PAYMENT GATEWAY--------------------//

  // on buy now clicked
  List<ManualPaymentDynamicFormModel> selectedManualPaymentList = [];
  bool isLoadingPaymentSheet = false;
  onBuyNowTapped({required BuildContext context}) async {
    //----if the selected payment type is empty
    if (selectedGatewayType == 0) {
      Helpers.showSnackBar(msg: "Please select a Payment Gateway first.");
    }
    //----manual payment
    else if (selectedGatewayType == 1) {
      selectedManualPaymentList = await manualPaymentElementList
          .where((e) => e.gatewayName == gatewayName)
          .toList();
      Get.to(() => ManualPaymentScreen(title: gatewayName));
      isLoadingPaymentSheet = true;
      update();
      isLoadingPaymentSheet = false;
      update();
    }
    //-----other payment and sdk payment
    else if (selectedGatewayType == 2) {
      if (gatewayCode == "stripe") {
        isLoadingPaymentSheet = true;
        update();
        await stripeDepositRequest();
        isLoadingPaymentSheet = false;
        update();
      } else if (gatewayCode == "razorpay") {
        isLoadingPaymentSheet = true;
        update();
        await razorPayPaymentRequest();
        isLoadingPaymentSheet = false;
        update();
      } else {
        isLoadingPaymentSheet = true;
        update();
        await webviewPayment(trxId: this.trxId);
        isLoadingPaymentSheet = false;
        update();
      }
    }
    //----card payment
    else if (selectedGatewayType == 3) {
      Get.to(() => CardPaymentScreen(gatewayCode: gatewayCode));
    }
    update();
  }

  //------MANUAL PAYMENT
  Color fileColorOfDField = AppColors.mainColor;
  Future manualPayment(
      {required String trxId,
      required Map<String, String> fields,
      required Iterable<http.MultipartFile>? fileList}) async {
    _isLoading = true;
    update();
    http.Response response = await PricingRepo.manualPayment(
        trxid: trxId, fields: fields, fileList: fileList);
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        Get.offAll(() => PaymentSuccessScreen());
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //------PAYMENT REQUEST DONE (this api will be called when add fund)
  String trxId = "";
  Future addPaymentRequest(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isLoadingPaymentSheet = true;
    update();
    http.Response response = await PricingRepo.addFundRequest(fields: fields);
    isLoadingPaymentSheet = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        trxId = data['data']['trx_id'].toString();
        await onBuyNowTapped(context: context);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //  WEBVIEW PAYMENT
  Future webviewPayment({required String trxId}) async {
    _isLoading = true;
    update();
    http.Response response = await PricingRepo.webviewPayment(trxId: trxId);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        if (data['data']['url'] != null) {
          Get.to(() => CheckoutWebView(url: data['data']['url']));
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['data']);
      update();
    }
  }

  //------CARD PAYMENT
  Future cardPayment({required Map<String, String> fields}) async {
    _isLoading = true;
    update();
    http.Response response = await PricingRepo.cardPayment(fields: fields);
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        Get.offAll(() => PaymentSuccessScreen());
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  //------ON PAYMENT DONE
  Future onPaymentDone({required Map<String, String> fields}) async {
    isLoadingPaymentSheet = true;
    update();
    http.Response response = await PricingRepo.onPaymentDone(trxId: this.trxId);
    isLoadingPaymentSheet = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == "success") {
        Get.offAll(() => PaymentSuccessScreen());
        print(data);
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
        Get.offAllNamed(RoutesName.mainDrawerScreen);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  ///-------------------------All key of Payment Gateway--------------------
  getNeededGatewayKeys(List<dynamic> allList) {
    for (var i in allList) {
      // IF THE PARAMETERS FIELD IS EXIST
      if (i['parameters'] != null) {
        if (i['code'].toString().trim().toLowerCase() == 'stripe') {
          secretKeyStripe = i['parameters']['secret_key'];
          publishableKeyStripe = i['parameters']['publishable_key'];
        } else if (i['code'].toString().trim().toLowerCase() == 'razorpay') {
          razorPayKey = i['parameters']['key_id'];
        }
      }
    }
  }

  // STRIPE
  String secretKeyStripe = "";
  String publishableKeyStripe = "";
  // RAZORPAY
  String razorPayKey = "";

  ///-------------------------Stripe Payment Integration
  dynamic stripePaymentData;
  var stripe = Stripe.instance;

  Future<void> stripeDepositRequest() async {
    try {
      stripePaymentData =
          await stripePaymentCreate(calculateAmount(sendAmount), "USD");
      await stripe.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: stripePaymentData['client_secret'],
          style: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          merchantDisplayName: '${AppConstants.appName}',
        ),
      );

      displayPaymentSheet();
    } catch (e, s) {
      if (kDebugMode) {
        print('Payment exception: $e$s');
      }
    }
  }

  Future displayPaymentSheet() async {
    try {
      await stripe.presentPaymentSheet().then((newValue) async {
        onPaymentDone(fields: {"trx_id": this.trxId});
        stripePaymentData = null;
      }).onError((error, stackTrace) async {
        if (kDebugMode) {
          print('OnErrorException/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
        _isLoading = false;
        Get.dialog(
          AlertDialog(
            content: Container(
              height: 60.h,
              child: Center(
                  child: Text(
                "Payment Cancelled!",
                style: TextStyle(color: AppColors.redColor),
              )),
            ),
          ),
        );
        update();
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('StripeException/DISPLAYPAYMENTSHEET==> $e');
      }
      Get.dialog(
        AlertDialog(
          content: Container(
            height: 60.h,
            child: Center(
                child: Text(
              "Payment Cancelled!",
              style: TextStyle(color: AppColors.redColor),
            )),
          ),
        ),
      );
      await Future.delayed(Duration(seconds: 3));
      Get.back();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  stripePaymentCreate(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ' + "${secretKeyStripe}",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
      return {};
    }
  }

  // calculate Amount
  calculateAmount(String amount) {
    final doubVal = double.parse(amount);
    final calculatedAmount = (doubVal.toInt() * 100);
    return calculatedAmount.toString();
  }

  ///----------------------Razor Payment Integration
  Razorpay? razorpay;

  listenRazorPay() {
    razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    onPaymentDone(fields: {
      "trx_id": this.trxId,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    print(response.error);
    // Handle payment failure
    Get.dialog(AppPaymentFail(errorText: response.message!));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
  }

  Future razorPayPaymentRequest() async {
    final options = {
      // Replace with your actual Razorpay key
      'key': razorPayKey,
      'amount': calculateAmount(sendAmount),
      'name': '${AppConstants.appName}',
      'description': 'Test Payment',
      'prefill': {
        'contact': '${HiveHelp.read(Keys.userPhone)}',
        'email': '${HiveHelp.read(Keys.userEmail)}'
      },
      'external': {
        'wallets': ['paytm']
      },
      'currency': '$selectedCurrency'
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPackageList();
  }

  @override
  void dispose() {
    super.dispose();
    pricingList.clear();
  }
}

// create a model class for dynamic form list of manual payment gateway
class ManualPaymentDynamicFormModel {
  String note;
  String gatewayName;
  String fieldName;
  String fieldLevel;
  String type;
  String validation;

  ManualPaymentDynamicFormModel({
    required this.note,
    required this.gatewayName,
    required this.fieldName,
    required this.fieldLevel,
    required this.type,
    required this.validation,
  });
}
