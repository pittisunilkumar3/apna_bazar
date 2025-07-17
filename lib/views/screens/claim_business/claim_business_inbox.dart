import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:face_pile/face_pile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:listplace/config/dimensions.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/claim_business_inbox_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class ClaimBusinessInboxScreen extends StatefulWidget {
  final String? uuid;
  final String? claim_id;
  final String? listing_id;
  const ClaimBusinessInboxScreen(
      {super.key, this.uuid = "", this.claim_id = "", this.listing_id = ""});

  @override
  State<ClaimBusinessInboxScreen> createState() =>
      _ClaimBusinessInboxScreenState();
}

class _ClaimBusinessInboxScreenState extends State<ClaimBusinessInboxScreen> {
  var convCtrl = Get.find<ClaimBusinessInboxController>();
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  onBackspacePressed() {
    convCtrl.replyTicketEditingCtrl
      ..text = convCtrl.replyTicketEditingCtrl.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: convCtrl.replyTicketEditingCtrl.text.length));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      convCtrl.getClaimBusinessConversation(uuid: widget.uuid!);
    });
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

  @override
  void dispose() {
    // Dispose of the FocusNode when it is no longer needed
    focusNode.dispose();
    super.dispose();
  }

  bool timeVisible = false;

  int selectedIndex = -1;

  changeDateFormat(dynamic time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('d MMM yy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ClaimBusinessInboxController>(builder: (claimBusinessInboxCtrl) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.put(PushNotificationController()).getPushNotificationConfig();
          Get.back();
        },
        child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
          appBar: buildAppbar(claimBusinessInboxCtrl),
          body: Column(
            children: [
              claimBusinessInboxCtrl.isGettingConv
                  ? Expanded(child: Helpers.appLoader())
                  : claimBusinessInboxCtrl.filteredConvList.isEmpty
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
                          itemCount: claimBusinessInboxCtrl.filteredConvList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = claimBusinessInboxCtrl.filteredConvList[index];
                            return ListTile(
                              title: Column(
                                crossAxisAlignment:
                                    data.userableId.toString() ==
                                            HiveHelp.read(Keys.userId)
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
                                    child: Column(
                                      crossAxisAlignment:
                                          data.userableId.toString() ==
                                                  HiveHelp.read(Keys.userId)
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              data.userableId.toString() !=
                                                      HiveHelp.read(Keys.userId)
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.end,
                                          children: [
                                            data.userableId.toString() !=
                                                    HiveHelp.read(Keys.userId)
                                                ? data.userableId.toString() ==
                                                        HiveHelp.read(
                                                            Keys.userId)
                                                    ? const SizedBox()
                                                    : Container(
                                                        height: 34.h,
                                                        width: 34.h,
                                                        margin: EdgeInsets.only(
                                                            right: 12.w),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .mainColor,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image: CachedNetworkImageProvider(
                                                                        data.img ??
                                                                            ""),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )),
                                                        ),
                                                      )
                                                : const SizedBox.shrink(),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColors.mainColor,
                                                        width: .1),
                                                    color: data.userableId
                                                                .toString() ==
                                                            HiveHelp.read(
                                                                Keys.userId)
                                                        ? AppColors.mainColor
                                                        : Get.isDarkMode
                                                            ? const Color(
                                                                0xff161A2D)
                                                            : AppColors
                                                                .fillColor, // User and admin message bubble color
                                                    borderRadius: data
                                                                .userableId
                                                                .toString() !=
                                                            HiveHelp.read(
                                                                Keys.userId)
                                                        ? BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    40.r),
                                                            topRight:
                                                                Radius.circular(
                                                                    40.r),
                                                            topLeft:
                                                                Radius.circular(
                                                                    40.r),
                                                          )
                                                        : BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    40.r),
                                                            topRight:
                                                                Radius.circular(
                                                                    40.r),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    40.r),
                                                          ),
                                                  ),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.sizeOf(
                                                                      context)
                                                                  .width *
                                                              .5,
                                                    ),
                                                    child: Text(
                                                      data.description,
                                                      style: context
                                                          .t.displayMedium
                                                          ?.copyWith(
                                                        color: data.userableId
                                                                    .toString() !=
                                                                HiveHelp.read(
                                                                    Keys.userId)
                                                            ? Get.isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                            : AppColors
                                                                .blackColor,
                                                      ), // User and admin message text color
                                                    ),
                                                  ),
                                                ),
                                                if (data.userableId
                                                        .toString() ==
                                                    HiveHelp.read(Keys.userId))
                                                  Container(
                                                    height: 34.h,
                                                    width: 34.h,
                                                    margin: EdgeInsets.only(
                                                        left: 12.w),
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                      data.img ??
                                                                          ""),
                                                              fit:
                                                                  BoxFit.fill)),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  VSpace(4.h),
                                  Visibility(
                                      visible: selectedIndex == index &&
                                          timeVisible == true,
                                      child: Text(
                                        selectedIndex == index
                                            ? data.createdAt == null
                                                ? ""
                                                : '${changeDateFormat(data.createdAt.toString())}'
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
              Padding(
                padding: EdgeInsets.only(
                    bottom: 15.h, left: claimBusinessInboxCtrl.isChatEnable == false ? 0 : 20.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 60.h,
                    maxHeight: 350.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (claimBusinessInboxCtrl.isChatEnable == false)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.redColor.withValues(alpha: .1),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Text(
                            "The chat option has been disabled by the Admin",
                            style: context.t.bodySmall
                                ?.copyWith(color: AppColors.redColor),
                          ),
                        ),
                      if (claimBusinessInboxCtrl.isChatEnable == true)
                        Row(
                          children: [
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
                                    border: Border.all(
                                        color: AppColors.mainColor, width: .2),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: AppTextField(
                                        focusNode: focusNode,
                                        border: InputBorder.none,
                                        controller: claimBusinessInboxCtrl.replyTicketEditingCtrl,
                                        contentPadding:
                                            EdgeInsets.only(left: 20.w),
                                        maxLines: 8,
                                        hinText: storedLanguage[
                                                'Type any text here'] ??
                                            "Type any text here",
                                        onChanged: (String v) {
                                          if (v.isEmpty) {
                                            claimBusinessInboxCtrl.replyEditingCtrlEmpty = true;
                                            claimBusinessInboxCtrl.update();
                                          } else if (v.isNotEmpty) {
                                            claimBusinessInboxCtrl.replyEditingCtrlEmpty = false;
                                            claimBusinessInboxCtrl.update();
                                          }
                                        },
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
                              onTap: claimBusinessInboxCtrl.isReplyingConv
                                  ? null
                                  : () async {
                                      if (claimBusinessInboxCtrl.replyTicketEditingCtrl.text
                                          .isEmpty) {
                                        Helpers.showSnackBar(
                                            msg: 'Message field is required');
                                      } else if (claimBusinessInboxCtrl.replyTicketEditingCtrl.text
                                          .isNotEmpty) {
                                        await claimBusinessInboxCtrl.replyConv(
                                            context: context,
                                            fields: {
                                              "listing_id": widget.listing_id,
                                              "claim_business_id":
                                                  widget.claim_id,
                                              "message": claimBusinessInboxCtrl
                                                  .replyTicketEditingCtrl.text
                                                  .trim(),
                                            });
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
                                  border: Border.all(
                                      color: AppColors.mainColor, width: .2),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Image.asset(
                                      claimBusinessInboxCtrl.replyEditingCtrlEmpty
                                          ? "$rootImageDir/send_inactive.png"
                                          : "$rootImageDir/send_active.png",
                                      color: claimBusinessInboxCtrl.replyEditingCtrlEmpty
                                          ? AppColors.black20
                                          : AppColors.mainColor),
                                ),
                              ),
                            ),
                            HSpace(20.w),
                          ],
                        ),
                      if (isShowEmoji)
                        SizedBox(
                          height: 250.h,
                          child: emoji.EmojiPicker(
                            textEditingController: claimBusinessInboxCtrl.replyTicketEditingCtrl,
                            onBackspacePressed: onBackspacePressed,
                            config: emoji.Config(
                              columns: 11,
                              emojiSizeMax: 24.h,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: emoji.Category.RECENT,
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
                              recentTabBehavior: emoji.RecentTabBehavior.RECENT,
                              recentsLimit: 28,
                              replaceEmojiOnLimitExceed: false,
                              noRecents: Text(
                                storedLanguage['No Recents'] ?? 'No Recents',
                                style: context.t.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const emoji.CategoryIcons(),
                              buttonMode: emoji.ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppbar(ClaimBusinessInboxController claimBusinessInboxCtrl) {
    return CustomAppBar(
      fontSize: 20.sp,
      bgColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
      onBackPressed: () {
        Get.put(PushNotificationController()).getPushNotificationConfig();
        Get.back();
      },
      titleWidget: Row(
        children: [
          FacePile(
            radius: 20.r,
            space: 22.h,
            images: [
              ...List.generate(
                  claimBusinessInboxCtrl.imgList.length,
                  (i) => CachedNetworkImageProvider(claimBusinessInboxCtrl.imgList[i],
                      maxHeight: 34, maxWidth: 34)),
            ],
          ),
        ],
      ),
    );
  }

  double calculateVerticalPadding(int textLength) {
    if (textLength > 35) {
      return 20.h;
    } else {
      return 15.h;
    }
  }
}
