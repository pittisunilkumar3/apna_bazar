import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/transaction_controller.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/app_constants.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/search_dialog.dart';
import '../home/home_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TransactionController>(builder: (transactionCtrl) {
      return Scaffold(
        appBar: buildAppBar(storedLanguage, context, transactionCtrl),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            transactionCtrl.textEditingController.clear();
            transactionCtrl.remarkEditingCtrlr.clear();
            transactionCtrl.transactionIdEditingCtrlr.clear();
            transactionCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await transactionCtrl.getTransactionList(
                page: 1, transaction_id: '', date: '', remark: '');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: transactionCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  transactionCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 10, isReverseColor: true)
                      : transactionCtrl.transactionList.isEmpty
                          ? Helpers.notFound(text: "No transactions found")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactionCtrl.transactionList.length,
                              itemBuilder: (context, i) {
                                var data = transactionCtrl.transactionList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      appDialog(
                                          context: context,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color: AppThemes
                                                        .getFillColor(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14.h,
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/success.gif",
                                                height: 48.h,
                                                width: 48.h,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                "${data.gatewayName.toString().trim()}",
                                                style: t.bodyLarge
                                                    ?.copyWith(fontSize: 22.sp),
                                              ),
                                              VSpace(22.h),
                                              Text(
                                                storedLanguage[
                                                        'Transaction ID'] ??
                                                    "Transaction ID",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withValues(
                                                                alpha: .5)),
                                              ),
                                              SelectableText(
                                                "${data.trxId}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Amount'] ??
                                                    "Amount",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withValues(
                                                                alpha: .5)),
                                              ),
                                              Text(
                                                "${Helpers.numberFormatWithAsFixed2("", data.amount.toString())} ${HiveHelp.read(Keys.baseCurrency)}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Charge'] ??
                                                    "Charge",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withValues(
                                                                alpha: .5)),
                                              ),
                                              Text(
                                                "${data.charge} ${HiveHelp.read(Keys.baseCurrency)}",
                                                style: t.bodySmall?.copyWith(
                                                    color: AppColors.redColor),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Remark'] ??
                                                    "Remark",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withValues(
                                                                alpha: .5)),
                                              ),
                                              Text(
                                                "${data.purchaseTitle}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage[
                                                        'Date and Time'] ??
                                                    "Date and Time",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withValues(
                                                                alpha: .5)),
                                              ),
                                              Text(
                                                "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                            ],
                                          ));
                                    },
                                    child: Ink(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 18.h),
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Get.isDarkMode
                                                    ? AppColors
                                                        .darkCardColorDeep
                                                    : AppColors.black10)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 32.h,
                                            width: 32.h,
                                            padding: EdgeInsets.all(5.h),
                                            decoration: BoxDecoration(
                                                color: Get.isDarkMode
                                                    ? AppColors
                                                        .darkCardColorDeep
                                                    : AppColors.fillColor,
                                                borderRadius:
                                                    Dimensions.kBorderRadius),
                                            child: Image.asset(
                                              "$rootImageDir/slip.png",
                                              color:
                                                  AppThemes.getParagraphColor(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${DateFormat('d MMMM, yyyy').format(DateTime.parse(data.createdAt.toString()))}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: t.bodySmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .black50)),
                                                VSpace(4.h),
                                                Text(
                                                    "${data.purchaseTitle} Plan",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: t.bodyLarge),
                                              ],
                                            ),
                                          ),
                                          HSpace(10.w),
                                          Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${HiveHelp.read(Keys.currencySymbol)}${Helpers.numberFormatWithAsFixed2("", data.amount.toString())}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: t.titleSmall
                                                          ?.copyWith(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (transactionCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppBar(
      storedLanguage, BuildContext context, TransactionController transactionCtrl) {
    return CustomAppBar(
      title: storedLanguage['Transaction'] ?? "Transaction",
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: true,
                context: context,
                transaction: transactionCtrl.transactionIdEditingCtrlr,
                startDate: transactionCtrl.dateEditingCtrlr,
                remark: transactionCtrl.remarkEditingCtrlr,
                onStartDatePressed: () async {
                  /// SHOW DATE PICKER
                  await showDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              surface: Get.isDarkMode
                                  ? AppColors.blackColor
                                  : AppColors.black70,
                              onPrimary: AppColors.whiteColor,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    AppColors.mainColor, // button text color
                              ),
                            ),
                          ),
                          child: child!);
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(DateTime.now().year.toInt() + 1),
                  ).then((value) {
                    if (value != null) {
                      print(value.toUtc());
                      transactionCtrl.dateEditingCtrlr.text =
                          DateFormat('yyyy-MM-dd').format(value);
                    }
                  });
                },
                onSearchPressed: () async {
                  transactionCtrl.resetDataAfterSearching();
                  Get.back();
                  await transactionCtrl
                      .getTransactionList(
                    page: 1,
                    transaction_id: transactionCtrl.transactionIdEditingCtrlr.text,
                    date: transactionCtrl.dateEditingCtrlr.text,
                    remark: transactionCtrl.remarkEditingCtrlr.text,
                  )
                      .then((value) {
                    transactionCtrl.dateEditingCtrlr.clear();
                  });
                });
          },
          child: Container(
            width: 34.h,
            height: 34.h,
            padding: EdgeInsets.all(9.h),
            decoration: BoxDecoration(
              color: AppThemes.getFillColor(),
              borderRadius: Dimensions.kBorderRadius,
            ),
            child: Image.asset(
              "$rootImageDir/filter_2.png",
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ),
        HSpace(20.w),
      ],
    );
  }
}
