import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/dimensions.dart';
import '../../../../controllers/manage_listing_controller.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/services/localstorage/hive.dart';
import '../../../../utils/services/localstorage/keys.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/spacing.dart';

class VideosTab extends StatelessWidget {
   final bool? isFromEditListing;
  const VideosTab({super.key,this.isFromEditListing=false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(storedLanguage['Video'] ??"Video", style: t.bodyLarge),
                    Text(" (Youtube Video ID)",
                        style: t.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppThemes.getGreyColor(),
                        )),
                  ],
                ),
                VSpace(16.h),
                CustomTextField(
                  isBorderColor: false,
                  
                  fillColor: AppThemes.getFillColor(),
                  controller: manageListingCtrl.youtubeUrlCtrl,
                  onChanged: (value) => manageListingCtrl.updateYoutubeController(value),
                  hintext: "ID",
                ),
                VSpace(16.h),
                VSpace(16.h),
                Container(
                  padding: EdgeInsets.all(
                      manageListingCtrl.youtubeUrlCtrl.text.isEmpty ? 70.h : 12.h),
                  width: double.maxFinite,
                  height: 210.h,
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: manageListingCtrl.youtubeUrlCtrl.text.isEmpty
                      ? Image.asset(
                          "$rootImageDir/video.png",
                          color: AppColors.mainColor,
                        )
                      : ClipRRect(
                          borderRadius: Dimensions.kBorderRadius,
                          child: YoutubePlayer(
                            controller: manageListingCtrl.youtubePlayerController,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: AppColors.mainColor,
                            progressColors: ProgressBarColors(
                              playedColor: AppColors.mainColor,
                              handleColor: AppColors.mainColor,
                            ),
                            onReady: () {
                              manageListingCtrl.youtubePlayerController.addListener(() {
                                if (manageListingCtrl.youtubePlayerController.value.isReady) {
                                  print("Player is ready");
                                }
                                print(
                                    "Current player state: ${manageListingCtrl.youtubePlayerController.value.playerState}");
                              });
                            },
                          ),
                        ),
                ),
                VSpace(40.h),
                AppButton(
                  onTap: manageListingCtrl.isLoading
                      ? null
                      : () async {
                      await manageListingCtrl.onSubmit(context,isFromUpdateListing: isFromEditListing);
                        },
                  text: storedLanguage['Submit'] ??"Submit",
                  isLoading: manageListingCtrl.isLoading,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
