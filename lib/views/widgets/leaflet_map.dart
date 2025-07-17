import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:listplace/controllers/bindings/controller_index.dart';
import 'package:listplace/utils/services/localstorage/hive.dart';
import 'package:listplace/views/widgets/text_theme_extension.dart';
import '../../config/app_colors.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';
import '../../utils/services/localstorage/keys.dart';

// This map is used in add listing basic info and listing details page
class InteractiveMapScreen extends StatelessWidget {
  final bool? isFromListingDetailsPage;
  final bool? isFromZoomView;
  final latlng.LatLng latLng;
  final List<Marker>? markers;
  final bool? isFromEditListing;
  InteractiveMapScreen({
    this.isFromZoomView = false,
    this.isFromEditListing = false,
    this.markers,
    required this.latLng,
    this.isFromListingDetailsPage = false,
  });

  @override
  Widget build(BuildContext context) {
    // This function is called once when the mapController is initialized.
    // However, on subsequent calls, the camera position does not change.
    // To fix this issue, this function is called again.
    if ((isFromListingDetailsPage == true || isFromEditListing == true) &&
        ManageListingController.to.leafletMapViewCount > 1) {
      ManageListingController.to.mapController.move(latLng, 13.0);
    }

    return Scaffold(
      appBar: HiveHelp.read(Keys.token) != null
          ? PreferredSize(preferredSize: Size(0, 0), child: SizedBox())
          : AppBar(
              centerTitle: true,
              title: Text(
                "Leaflet Map",
                style: context.t.titleSmall?.copyWith(
                  fontSize: 22.sp,
                ),
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColorDeep
                            : AppColors.sliderInActiveColor,
                        width: Get.isDarkMode ? .8 : .9,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "$rootImageDir/back.png",
                      height: 16.h,
                      width: 16.h,
                      color: AppThemes.getIconBlackColor(),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
      body: GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
        return FlutterMap(
          mapController: manageListingCtrl.mapController,
          options: MapOptions(
            initialCenter: isFromListingDetailsPage == true ||
                    isFromEditListing == true ||
                    HiveHelp.read(Keys.token) == null
                ? latLng
                : manageListingCtrl.center,
            initialZoom: HiveHelp.read(Keys.token) == null ? 2 : 13.0,
            onTap: (tapPosition, latLng) async {
              await manageListingCtrl.getLeafletAddressFromLatLng(
                  latLng.latitude, latLng.longitude);
              if (isFromEditListing == true) {
                manageListingCtrl.latEditingCtrlr.text = latLng.latitude.toString();
                manageListingCtrl.lngEditingCtrlr.text = latLng.longitude.toString();
                manageListingCtrl.selectedLat = latLng.latitude.toString();
                manageListingCtrl.selectedLng = latLng.longitude.toString();
                manageListingCtrl.mapController.move(latLng, 13.0);
                manageListingCtrl.update();
              } else {
                if (isFromListingDetailsPage == false) {
                  manageListingCtrl.addMarker(latLng);
                }
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
                markers: isFromListingDetailsPage == true ||
                        isFromEditListing == true
                    ? [
                        Marker(
                          point: isFromEditListing == true
                              ? latlng.LatLng(double.parse(manageListingCtrl.selectedLat),
                                  double.parse(manageListingCtrl.selectedLng))
                              : latLng,
                          child: Image.asset(
                    "$rootImageDir/marker.png",
                    height: 40,
                    width: 40,
                  ),
                        )
                      ]
                    : HiveHelp.read(Keys.token) == null
                        ? FrontendListingController.to.leafletmarker
                        : manageListingCtrl.markers),
          ],
        );
      }),
    );
  }
}
