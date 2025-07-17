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
      title: "Find the best Listing For you",
      description:
          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_2.png",
      title: "Select Your Price Schedule",
      description:
          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_3.png",
      title: "Find the best\nPlace For you",
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
];
