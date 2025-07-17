import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/themes/themes.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import 'package:listplace/views/widgets/spacing.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/dynamic_form_controller.dart';
import '../../../../utils/services/helpers.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../home/home_screen.dart';

class DynamicFormScreen extends StatefulWidget {
  const DynamicFormScreen({super.key});

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  @override
  void initState() {
    DynamicFormController.to.getDynamicFormData(
        page: DynamicFormController.to.page,
        listingId: DynamicFormController.to.listingId);
    DynamicFormController.to.scrollController = ScrollController()
      ..addListener(DynamicFormController.to.loadMore);
    super.initState();
  }

  @override
  void dispose() {
    DynamicFormController.to.scrollController.dispose();
    DynamicFormController.to.dynamicFormList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<DynamicFormController>(builder: (dynamicFormCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Dynamic Form Data'] ?? "Dynamic Form Data",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            dynamicFormCtrl.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await dynamicFormCtrl.getDynamicFormData(page: 1, listingId: dynamicFormCtrl.listingId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: dynamicFormCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  dynamicFormCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 10, isReverseColor: true)
                      : dynamicFormCtrl.dynamicFormList.isEmpty
                          ? Helpers.notFound(text: "No dynamic forms found")
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dynamicFormCtrl.dynamicFormList.length,
                              itemBuilder: (context, i) {
                                var data = dynamicFormCtrl.dynamicFormList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: InkWell(
                                    onTap: () async {
                                      dynamicFormCtrl.selectedId = data.id.toString();
                                      var l = dynamicFormCtrl.dynamicFormList2
                                          .where((e) => e.id == dynamicFormCtrl.selectedId)
                                          .toList();
                                      await Future.delayed(
                                          Duration(milliseconds: 100));
                                      Get.to(() => DynamicFormDetailsScreen(
                                          l: l
                                              .where((x) => x.type != "file")
                                              .toList()));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 15.w),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius: Dimensions.kBorderRadius,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Form Name",
                                                style: t.displayMedium?.copyWith(
                                                    color: AppThemes
                                                        .getParagraphColor()),
                                              ),
                                              Text(
                                                  data.formName.isEmpty
                                                      ? "Data Collection Form"
                                                      : data.formName,
                                                  style: t.displayMedium),
                                            ],
                                          ),
                                          VSpace(15.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Date",
                                                style: t.displayMedium?.copyWith(
                                                    color: AppThemes
                                                        .getParagraphColor()),
                                              ),
                                              Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(DateTime.parse(
                                                          data.date
                                                              .toString())),
                                                  style: t.displayMedium),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (dynamicFormCtrl.isLoadMore == true)
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
}

class DynamicFormDetailsScreen extends StatelessWidget {
  final List<DynamicFormDataModel> l;
  const DynamicFormDetailsScreen({super.key, required this.l});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Details"),
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          children: [
            VSpace(30.h),
            Expanded(
                child: ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (c, i) {
                      var data = l[i];
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15.w),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppThemes.getSliderInactiveColor())),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.fieldName,
                                  style: context.t.displayMedium,
                                ),
                                HSpace(15.w),
                                Expanded(
                                  child: Text(
                                    data.fieldVal,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: context.t.displayMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
