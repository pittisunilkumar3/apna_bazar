import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/controllers/product_enquiry_conv_controller.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import 'package:http/http.dart' as http;

class ProductEnquiryInboxScreen extends StatefulWidget {
  final String? clientId;
  final String? productQueryId;
  const ProductEnquiryInboxScreen(
      {super.key, this.clientId = "", this.productQueryId = ""});

  @override
  State<ProductEnquiryInboxScreen> createState() =>
      _ProductEnquiryInboxScreenState();
}

class _ProductEnquiryInboxScreenState extends State<ProductEnquiryInboxScreen> {
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  onBackspacePressed() {
    ProductEnquiryConvController.to.replyEditingCtrl
      ..text = ProductEnquiryConvController.to.replyEditingCtrl.text.characters
          .toString()
      ..selection = TextSelection.fromPosition(TextPosition(
          offset:
              ProductEnquiryConvController.to.replyEditingCtrl.text.length));
  }

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          if (isShowEmoji == true) {
            isShowEmoji = false;
          }
        }
      });
    });
    super.initState();
  }

  bool timeVisible = false;

  int selectedIndex = -1;
  changeDateFormat(dynamic time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('d MMM yy, hh:mm a').format(dateTime);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProductEnquiryConvController>(builder: (enquiryCnvCtrl) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
        appBar: CustomAppBar(
          bgColor:
              Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
          title: storedLanguage['Product Enquiry'] ?? "Product Enquiry",
        ),
        body: Column(
          children: [
            enquiryCnvCtrl.isGettingConv
                ? Expanded(child: Helpers.appLoader())
                : enquiryCnvCtrl.filteredConvList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "No data found",
                            style: context.t.bodyLarge,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: enquiryCnvCtrl.filteredConvList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = enquiryCnvCtrl.filteredConvList[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: HiveHelp.read(Keys.userId) ==
                                      data.user_id.toString()
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeVisible = !timeVisible;
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          data.user_id.toString() !=
                                                  HiveHelp.read(Keys.userId)
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                      children: [
                                        if (HiveHelp.read(Keys.userId) !=
                                            data.user_id.toString())
                                          Container(
                                            height: 34.h,
                                            width: 34.h,
                                            margin:
                                                EdgeInsets.only(right: 12.w),
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            data.img ?? ""),
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),
                                          ),
                                        if (data.file == null)
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 300.w,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical:
                                                    calculateHorizontalPadding(
                                                        data.reply.length)),
                                            decoration: BoxDecoration(
                                              color: HiveHelp.read(
                                                          Keys.userId) ==
                                                      data.user_id.toString()
                                                  ? AppColors.mainColor
                                                  : Get.isDarkMode
                                                      ? const Color(0xff161A2D)
                                                      : AppColors.mainColor
                                                          .withValues(
                                                              alpha:
                                                                  .2), // User and admin message bubble color
                                              borderRadius: HiveHelp.read(
                                                          Keys.userId) !=
                                                      data.user_id.toString()
                                                  ? BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(40.r),
                                                      topRight:
                                                          Radius.circular(40.r),
                                                      topLeft:
                                                          Radius.circular(40.r),
                                                    )
                                                  : BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(40.r),
                                                      topRight:
                                                          Radius.circular(40.r),
                                                      bottomLeft:
                                                          Radius.circular(40.r),
                                                    ),
                                            ),
                                            child: Text(
                                              data.reply.toString(),
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                color: HiveHelp.read(
                                                            Keys.userId) !=
                                                        data.user_id.toString()
                                                    ? Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                    : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        if (data.file != null)
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => Scaffold(
                                                    appBar: const CustomAppBar(
                                                        title: "PhotoView"),
                                                    body: PhotoView(
                                                        imageProvider:
                                                            CachedNetworkImageProvider(
                                                                data.file)),
                                                  ));
                                            },
                                            child: Container(
                                              height: 150.h,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                border: Border.all(
                                                  width: .5,
                                                  color: AppColors.mainColor,
                                                ),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          data.file),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    )),
                                VSpace(4.h),
                                Visibility(
                                    visible: selectedIndex == index &&
                                        timeVisible == true,
                                    child: Text(
                                      selectedIndex == index
                                          ? data.sent_at.toString()
                                          : '',
                                      style: context.t.bodySmall?.copyWith(
                                          color: Get.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor),
                                    )),
                              ],
                            ),
                          );
                        },
                      )),
            enquiryCnvCtrl.filePath.isEmpty
                ? const SizedBox()
                : Container(
                    height: 40.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1 File selected",
                          style: context.t.bodySmall
                              ?.copyWith(color: AppColors.whiteColor),
                        ),
                        HSpace(6.w),
                        InkResponse(
                            onTap: () {
                              enquiryCnvCtrl.filePath = "";
                              enquiryCnvCtrl.update();
                            },
                            child: Container(
                              padding: EdgeInsets.all(3.h),
                              decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.close,
                                size: 12.h,
                              ),
                            ))
                      ],
                    ),
                  ),
            VSpace(enquiryCnvCtrl.filePath.isNotEmpty ? 5.h : 0),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.h,
                  maxHeight: 350.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isShowEmoji = false;
                              });
                              enquiryCnvCtrl.pickFiles();
                            },
                            icon: Image.asset(
                              "$rootImageDir/file_pick.png",
                              height: 19.h,
                            )),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 46.h,
                              maxHeight: 100.h,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppTextField(
                                    focusNode: focusNode,
                                    border: InputBorder.none,
                                    controller: ProductEnquiryConvController
                                        .to.replyEditingCtrl,
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                    maxLines: 8,
                                    hinText:
                                        storedLanguage['Type any text here'] ??
                                            "Type any text here",
                                  )),
                                  HSpace(3.w),
                                  InkResponse(
                                    onTap: () {
                                      setState(() {
                                        isShowEmoji = !isShowEmoji;
                                        Helpers.hideKeyboard();
                                      });
                                    },
                                    radius: 8.r,
                                    child: Image.asset(
                                      "$rootImageDir/emoji.png",
                                      height: 20.h,
                                    ),
                                  ),
                                  HSpace(15.w),
                                ],
                              ),
                            ),
                          ),
                        ),
                        HSpace(10.w),
                        InkResponse(
                          onTap: enquiryCnvCtrl.isReplyingConv
                              ? null
                              : () async {
                                  if (ProductEnquiryConvController
                                      .to.replyEditingCtrl.text.isNotEmpty) {
                                    if (enquiryCnvCtrl.filePath.isNotEmpty) {
                                      await enquiryCnvCtrl
                                          .productEnquiryConvConversationReply(
                                        context: context,
                                        fields: {
                                          "product_query_id":
                                              widget.productQueryId ?? "",
                                          "client_id": widget.clientId ?? "",
                                          "message":
                                              ProductEnquiryConvController
                                                  .to.replyEditingCtrl.text,
                                        },
                                        files:
                                            await http.MultipartFile.fromPath(
                                                "file", enquiryCnvCtrl.filePath),
                                      );
                                    } else {
                                      await enquiryCnvCtrl
                                          .productEnquiryConvConversationReply(
                                        context: context,
                                        fields: {
                                          "product_query_id":
                                              widget.productQueryId ?? "",
                                          "client_id": widget.clientId ?? "",
                                          "message":
                                              ProductEnquiryConvController
                                                  .to.replyEditingCtrl.text,
                                        },
                                      );
                                    }
                                  } else {
                                    Helpers.showSnackBar(
                                        msg: "Message field is required");
                                  }
                                },
                          child: Container(
                            height: 46.h,
                            width: 46.h,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Image.asset(
                                "$rootImageDir/send_active.png",
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                        HSpace(20.w),
                      ],
                    ),
                    if (isShowEmoji)
                      SizedBox(
                          height: 250.h,
                          child: EmojiPicker(
                            textEditingController: ProductEnquiryConvController
                                .to.replyEditingCtrl,
                            onBackspacePressed: onBackspacePressed,
                            config: Config(
                              columns: 11,
                              emojiSizeMax: 24.h,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: Get.isDarkMode
                                  ? AppColors.darkBgColor
                                  : AppColors.whiteColor,
                              indicatorColor: AppColors.mainColor,
                              iconColor: Colors.grey,
                              iconColorSelected: AppColors.mainColor,
                              backspaceColor: AppColors.mainColor,
                              skinToneDialogBgColor: Colors.white,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              recentTabBehavior: RecentTabBehavior.RECENT,
                              recentsLimit: 28,
                              replaceEmojiOnLimitExceed: false,
                              noRecents: Text(
                                'No Recents',
                                style: context.t.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  double calculateHorizontalPadding(int textLength) {
    if (textLength > 35) {
      return 5.h;
    } else {
      return 15.h;
    }
  }
}
