import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:listplace/data/models/frontend_listing_details_model.dart'
    as fListingModel;

import '../../config/app_colors.dart';
import '../../config/styles.dart';

class ViewPhotos extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<fListingModel.ListingImage> imageList;
  ViewPhotos(
      {required this.imageIndex,
      required this.imageList,
      this.heroTitle = "img"});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "${currentIndex + 1} out of ${widget.imageList.length}",
          style: Styles.smallTitle.copyWith(color: AppColors.whiteColor),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(5.h),
              decoration: BoxDecoration(
                color: AppColors.darkCardColorDeep,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.clear,
                color: AppColors.whiteColor,
                size: 19.h,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                    widget.imageList[index].listingImage.toString()),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
              );
            },
            onPageChanged: onPageChanged,
            itemCount: widget.imageList.length,
            loadingBuilder: (context, progress) => Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                child: (progress == null || progress.expectedTotalBytes == null)
                    ? CircularProgressIndicator()
                    : CircularProgressIndicator(
                        value: progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!,
                      ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
