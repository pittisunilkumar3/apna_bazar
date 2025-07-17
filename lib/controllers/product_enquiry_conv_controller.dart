import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:listplace/controllers/product_enquiry_controller.dart';
import 'package:listplace/data/repositories/product_enquiry_repo.dart';
import '../data/models/product_enquiry_conv_model.dart' as inboxModel;
import '../data/source/errors/check_api_status.dart';
import '../utils/services/helpers.dart';

class ProductEnquiryConvController extends GetxController {
  static ProductEnquiryConvController get to =>
      Get.find<ProductEnquiryConvController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isGettingConv = false;
  String selectedEnquiryId = "0";
  List<inboxModel.Data> conversationList = [];
  List<ConvMessage> filteredConvList = [];
  List<String> imgList = [];
  Future getProductEnquiryConvList(
      {required String id, bool? isFromReplyConv = false}) async {
    if (isFromReplyConv == false) {
      isGettingConv = true;
      update();
    }
    http.Response response =
        await ProductEnquiryRepo.getProductEnquiryConvList(id: id);
    if (isFromReplyConv == false) {
      isGettingConv = false;
    }
    conversationList = [];
    filteredConvList = [];
    imgList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        if (data['data'] != null)
          conversationList
              .add(inboxModel.ProductEnquiryConvModel.fromJson(data).data!);
        if (conversationList.isNotEmpty) {
          for (int i = 0; i < conversationList.length; i += 1) {
            if (conversationList[i].replies != null)
              for (int j = 0; j < conversationList[i].replies!.length; j += 1) {
                filteredConvList.add(ConvMessage(
                  id: conversationList[i].replies![j].id ?? 0,
                  client_id: conversationList[i].replies![j].clientId ?? 0,
                  user_id: conversationList[i].replies![j].userId ?? 0,
                  img: conversationList[i].client == null
                      ? ""
                      : conversationList[i].client!.imgPath,
                  firstName: conversationList[i].client == null
                      ? ""
                      : conversationList[i].client!.firstname,
                  lastName: conversationList[i].client == null
                      ? ""
                      : conversationList[i].client!.lastname,
                  sent_at: conversationList[i].replies![j].sentAt ?? "",
                  reply: conversationList[i].replies![j].reply ?? "",
                  createdAt: conversationList[i].replies![j].createdAt,
                  file: conversationList[i].replies![j].file,
                ));
              }
          }
        }
        filteredConvList = List.from(filteredConvList.reversed);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      conversationList = [];
    }
  }

  FilePickerResult? result;
  String filePath = "";

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        filePath = result.files.single.path!;
        update();
      }
    } catch (e) {
      Helpers.showSnackBar(msg: e.toString());
      if (kDebugMode) {
        print("Error while picking files: $e");
      }
    }
  }

  TextEditingController replyEditingCtrl = TextEditingController();
  bool replyEditingCtrlEmpty = true;
  bool isReplyingConv = false;
  Future productEnquiryConvConversationReply(
      {required BuildContext context,
      Map<String, String>? fields,
      http.MultipartFile? files}) async {
    isReplyingConv = true;
    update();
    http.Response response =
        await ProductEnquiryRepo.productEnquiryConvConversationReply(
            fields: fields, files: files);
    isReplyingConv = false;

    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data);
      if (data['status'] == 'success') {
        replyEditingCtrl.clear();
        filePath = "";
        getProductEnquiryConvList(id: this.selectedEnquiryId,isFromReplyConv:true);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }

  bool isDeleting = false;
  Future deleteProductEnqu({required String id}) async {
    isDeleting = true;
    update();
    http.Response response = await ProductEnquiryRepo.deleteProductEnqu(id: id);
    isDeleting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data);
      if (data['status'] == 'success') {
        ProductEnquiryController.to.resetDataAfterSearching();
        ProductEnquiryController.to.getCustomerEnquiryList(
            page: 1,
            name: "",
            from_date: "",
            to_date: "",
            enquiryType: ProductEnquiryController.to.enquiryType);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['data']}');
    }
  }
}

class ConvMessage {
  dynamic id;
  dynamic img;
  dynamic firstName;
  dynamic lastName;
  dynamic client_id;
  dynamic user_id;
  dynamic sent_at;
  dynamic reply;
  dynamic createdAt;
  dynamic file;
  ConvMessage(
      {this.id,
      this.img,
      this.user_id,
      this.firstName,
      this.lastName,
      this.client_id,
      this.sent_at,
      this.reply,
      this.createdAt,
      this.file});
}
