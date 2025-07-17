import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listplace/controllers/frontend_listing_controller.dart';
import 'package:listplace/controllers/profile_controller.dart';
import 'package:listplace/views/widgets/custom_appbar.dart';
import '../../controllers/manage_listing_controller.dart';
import '../../utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

// Load a custom marker image from assets
Future<map.BitmapDescriptor> getCustomGoogleMapMarker() async {
  final ByteData data = await rootBundle.load('$rootImageDir/marker.png');
  final Uint8List markerImage = data.buffer.asUint8List();
  return map.BitmapDescriptor.bytes(markerImage, height: 40, width: 40);
}

class GoogleMapScreen extends StatefulWidget {
  final LatLng latLng;
  final bool? isFullView;
  final bool? isFromListingDetailsPage;
  final bool? isUserAuthenticated;
  const GoogleMapScreen(
      {super.key,
      required this.latLng,
      this.isFullView = false,
      this.isFromListingDetailsPage = false,
      this.isUserAuthenticated = true});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ProfileController.to.isLeafLetMap == false) {
        ManageListingController.to.latEditingCtrlr.text =
            widget.latLng.latitude.toString();
        ManageListingController.to.lngEditingCtrlr.text =
            widget.latLng.longitude.toString();

        ManageListingController.to.latEditingCtrlr
            .addListener(_updateCameraAndMarker);
        ManageListingController.to.lngEditingCtrlr
            .addListener(_updateCameraAndMarker);

        _updateMarker(widget.latLng);
      }
    });
  }

  void _updateCameraAndMarker() {
    if (mapController == null) return;

    double? latitude =
        double.tryParse(ManageListingController.to.latEditingCtrlr.text);
    double? longitude =
        double.tryParse(ManageListingController.to.lngEditingCtrlr.text);

    if (latitude != null && longitude != null) {
      LatLng newPosition = LatLng(latitude, longitude);

      mapController!.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
      _updateMarker(newPosition);
    }
  }

  Future<void> _updateMarker(LatLng position) async {
    if (mounted) {
      final customMarker = await getCustomGoogleMapMarker();
      setState(() {
        markers = {
          Marker(
            markerId: const MarkerId("current_position"),
            position: position,
            icon: customMarker,
            infoWindow: const InfoWindow(title: "Picked Location"),
          ),
        };
      });

      ManageListingController.to.latEditingCtrlr.text =
          position.latitude.toString();
      ManageListingController.to.lngEditingCtrlr.text =
          position.longitude.toString();
      ManageListingController.to.update();
    }
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageListingController>(builder: (manageListingCtrl) {
      return Scaffold(
        appBar: widget.isFullView == false
            ? PreferredSize(preferredSize: Size(0, 0), child: SizedBox())
            : const CustomAppBar(title: "Google Map"),
        body: Stack(
          children: [
            GoogleMap(
              mapType: Get.isDarkMode ? MapType.hybrid : MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: widget.latLng,
                zoom: widget.isUserAuthenticated == false ? 0 : 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              myLocationButtonEnabled: false,
              markers: widget.isUserAuthenticated == false
                  ? FrontendListingController.to.googleMapMarker!
                  : markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              zoomControlsEnabled: true,
              onTap: (LatLng tappedPosition) async {
                if (widget.isFromListingDetailsPage == false &&
                    widget.isUserAuthenticated == true) {
                  _updateMarker(tappedPosition);
                  await manageListingCtrl.getGoogleMapAddressFromLatLng(
                      tappedPosition.latitude, tappedPosition.longitude);
                }
              },
              onCameraMove: (CameraPosition position) {
                cameraPosition = position;
              },
            ),
          ],
        ),
      );
    });
  }
}
