import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:listplace/controllers/pricing_controller.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class PaymentScreen extends StatefulWidget {
  final String? packageId;
  const PaymentScreen({super.key, this.packageId = ""});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  FocusNode node = FocusNode();
  @override
  void initState() {
    node.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PricingController>(builder: (pricingCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Pricing Payment'] ?? "Pricing Payment",
        ),
        body: pricingCtrl.isLoading
            ? Helpers.appLoader()
            : pricingCtrl.paymentGatewayList.isEmpty
                ? Helpers.notFound(text: "No pricing payment found")
                : Padding(
                    padding: Dimensions.kDefaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(32.h),
                        CustomTextField(
                          hintext: storedLanguage['Search Gateway'] ??
                              "Search Gateway",
                          controller: pricingCtrl.gatewayEditingController,
                          onChanged: pricingCtrl.queryPaymentGateway,
                          isSuffixIcon: true,
                          isSuffixBgColor: true,
                          suffixIcon: "search",
                        ),
                        VSpace(32.h),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: Get.isDarkMode
                                      ? AppColors.darkCardColorDeep
                                      : AppColors.black20,
                                  width: Get.isDarkMode ? .6 : .2)),
                          child: ListView.builder(
                              itemCount: pricingCtrl.isGatewaySearching
                                  ? pricingCtrl.searchedGatewayItem.length
                                  : pricingCtrl.paymentGatewayList.length,
                              itemBuilder: (context, i) {
                                var data = pricingCtrl.isGatewaySearching
                                    ? pricingCtrl.searchedGatewayItem[i]
                                    : pricingCtrl.paymentGatewayList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius / 2,
                                    onTap: () async {
                                      Helpers.hideKeyboard();
                                      pricingCtrl.selectedGatewayIndex = i;
                                      pricingCtrl.getGatewayData(i);
                                      pricingCtrl.getSelectedGatewayData(i);
                                      pricingCtrl.update();
                                      buildDialog(context, pricingCtrl, storedLanguage);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Get.isDarkMode
                                                    ? AppColors
                                                        .darkCardColorDeep
                                                    : AppColors.black20,
                                                width:
                                                    Get.isDarkMode ? .6 : .2)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 42.h,
                                            width: 64.w,
                                            decoration: BoxDecoration(
                                                color: Get.isDarkMode
                                                    ? AppColors.darkBgColor
                                                    : AppColors.fillColor,
                                                borderRadius:
                                                    Dimensions.kBorderRadius /
                                                        2,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          data.image),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          HSpace(16.w),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(data.name.toString(),
                                                  style: t.bodyMedium),
                                              VSpace(1.h),
                                              Text(data.description.toString(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getParagraphColor())),
                                            ],
                                          )),
                                          Container(
                                            width: 20.h,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: pricingCtrl.selectedGatewayIndex == i
                                                  ? AppColors.mainColor
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: pricingCtrl.selectedGatewayIndex !=
                                                          i
                                                      ? Get.isDarkMode
                                                          ? AppColors
                                                              .darkCardColorDeep
                                                          : AppColors.black20
                                                      : Colors.transparent),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.done_rounded,
                                                size: 14.h,
                                                color:
                                                    pricingCtrl.selectedGatewayIndex == i
                                                        ? AppColors.whiteColor
                                                        : Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )),
                      ],
                    ),
                  ),
      );
    });
  }

  Future<dynamic> buildDialog(
      BuildContext context, PricingController pricintCtrl, storedLanguage) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<PricingController>(builder: (pricingCtrl) {
          return Container(
              padding: Dimensions.kDefaultPadding,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppThemes.getDarkCardColor(),
                borderRadius: Dimensions.kBorderRadius * 2,
              ),
              child: ListView(
                children: [
                  VSpace(32.h),
                  if (pricingCtrl.gatewayName != "")
                    Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                pricingCtrl.selectedCurrency == null
                                    ? const SizedBox()
                                    : Text(
                                        "${storedLanguage['Transaction Limit:'] ?? "Transaction Limit:"} ${pricingCtrl.minAmount}-${pricingCtrl.maxAmount} ${pricingCtrl.selectedCurrency}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.bodySmall?.copyWith(
                                            color: AppColors.redColor),
                                      ),
                                Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Ink(
                                      height: 26.h,
                                      width: 26.h,
                                      padding: EdgeInsets.all(3.h),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.isDarkMode
                                              ? AppColors.darkBgColor
                                              : AppColors.sliderInActiveColor),
                                      child: Icon(
                                        Icons.close,
                                        size: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VSpace(20.h),
                          pricingCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          Text(
                            storedLanguage['Select Gateway Currency'] ??
                                "Select Gateway Currency",
                            style: context.t.displayMedium,
                          ),
                          VSpace(12.h),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppThemes.getSliderInactiveColor()),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: AppCustomDropDown(
                              height: 50.h,
                              width: double.infinity,
                              items: pricingCtrl.supportedCurrencyList
                                  .map((e) => e)
                                  .toList(),
                              selectedValue: pricingCtrl.selectedCurrency,
                              onChanged: (value) async {
                                pricingCtrl.selectedCurrency = value;
                                if (pricingCtrl.is_crypto == false) {
                                  pricingCtrl.getSelectedCurrencyData(value);
                                }
                                pricingCtrl.update();
                              },
                              hint: storedLanguage['Select currency'] ??
                                  "Select currency",
                              selectedStyle: context.t.displayMedium,
                              bgColor: Get.isDarkMode
                                  ? AppColors.darkBgColor
                                  : AppColors.fillColor,
                            ),
                          ),
                          VSpace(20.h),
                          pricingCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : Text(storedLanguage['Amount'] ?? 'Amount',
                                  style: context.t.displayMedium),
                          pricingCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          pricingCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : IgnorePointer(
                                  ignoring: true,
                                  child: CustomTextField(
                                    focusNode: node,
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                    hintext: storedLanguage['Enter Amount'] ??
                                        'Enter Amount',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          pricingCtrl.maxAmount.length),
                                    ],
                                    controller: pricingCtrl.amountCtrl,
                                    onChanged: (v) {},
                                  ),
                                ),
                          VSpace(16.h),
                          if (pricingCtrl.amountValue.isNotEmpty &&
                              pricingCtrl.selectedCurrency != null)
                            Container(
                              height: 180.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.kBorderRadius,
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.black60
                                        : AppColors.black30,
                                    width: Dimensions.appThinBorder),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Amount In ${pricingCtrl.is_crypto ? "USD" : pricingCtrl.selectedCurrency}",
                                              style: context
                                                  .t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${pricingCtrl.is_crypto ? pricingCtrl.amountInSelectedCurrInCrypto : pricingCtrl.amountInSelectedCurr} ${pricingCtrl.is_crypto ? "USD" : pricingCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage['Charge'] ??
                                                  "Charge",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${Helpers.numberFormatWithAsFixed2("", pricingCtrl.charge)} ${pricingCtrl.is_crypto ? "USD" : pricingCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.redColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage[
                                                      'Payable Amount'] ??
                                                  "Payable Amount",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${pricingCtrl.is_crypto == true ? pricingCtrl.payableAmountInCrypto : pricingCtrl.payableAmount} ${pricingCtrl.is_crypto ? "USD" : pricingCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.greenColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage[
                                                      'In Base Currency'] ??
                                                  "In Base Currency",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${pricingCtrl.amountInBaseCurr}  ${HiveHelp.read(Keys.baseCurrency)}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                  color: AppColors.greenColor,
                                                )),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          VSpace(32.h),
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading: pricingCtrl.isLoadingPaymentSheet ? true : false,
                              onTap: pricingCtrl.isLoadingPaymentSheet
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (pricingCtrl.amountCtrl.text.isEmpty) {
                                        Helpers.showSnackBar(
                                            msg: "Amount field is required");
                                      } else {
                                        await pricingCtrl.addPaymentRequest(
                                          context: context,
                                          fields: {
                                            "plan_id": pricingCtrl.planId,
                                            "purchase_id": pricingCtrl.purchaseId,
                                            "type": pricingCtrl.type,
                                            "cvt_amount": pricingCtrl.amountCtrl.text,
                                            "gateway_id":
                                                pricingCtrl.gatewayId.toString(),
                                            "supported_currency":
                                                pricingCtrl.selectedCurrency,
                                            if (pricingCtrl.selectedCryptoCurrency !=
                                                null)
                                              "supported_crypto_currency":
                                                  pricingCtrl.selectedCryptoCurrency,
                                          },
                                        );
                                      }
                                    },
                              text: storedLanguage['Confirm & Next'] ??
                                  "Confirm & Next",
                            ),
                          ),
                          VSpace(node.hasFocus ? 150.h : 50.h),
                        ],
                      ),
                    ),
                  VSpace(32.h),
                ],
              ));
        });
      },
    );
  }
}
