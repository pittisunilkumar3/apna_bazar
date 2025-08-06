import 'package:listplace/utils/app_constants.dart';

class OnBordingData {
  String imagePath;
  String title;
  String description;

  OnBordingData(
      {required this.imagePath,
      required this.title,
      required this.description});
}

List<OnBordingData> onBordingDataList = [
  OnBordingData(
    imagePath: "$rootImageDir/onbording_1.png",
    title: "Find the Best Listing For You",
    description: "Explore a wide variety of categories and discover businesses, services, and places tailored to your needs.",
  ),
  OnBordingData(
    imagePath: "$rootImageDir/onbording_2.png",
    title: "Select Your Price Schedule",
    description: "Compare prices and options at a glance to choose the listings that best fit your budget and preferences.",
  ),
  OnBordingData(
    imagePath: "$rootImageDir/onbording_3.png",
    title: "Find the Best\nPlace For You",
    description: "Easily locate top-rated places in your area and enjoy hassle-free access to all the information you need.",
  ),
];
