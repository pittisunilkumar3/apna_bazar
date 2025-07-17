import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/claim_business_message_model.dart' as inboxModel;
import '../data/repositories/claim_business_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../utils/services/helpers.dart';

class ClaimBusinessInboxController extends GetxController {
  static ClaimBusinessInboxController get to =>
      Get.find<ClaimBusinessInboxController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isGettingConv = false;
  List<inboxModel.Data> conversationList = [];
  List<ConvMessage> filteredConvList = [];
  List<String> imgList = [];
  bool isChatEnable = true;
  Future getClaimBusinessConversation(
      {required String uuid, bool? isFromReplyConv = false}) async {
    if (isFromReplyConv == false) {
      isGettingConv = true;
      update();
    }
    http.Response response =
        await ClaimBusinessRepo.getClaimBusinessConversation(uuid: uuid);
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
        if (data['data'] != null) {
          isChatEnable = data['data']['is_chat_enable'] == 0 ? false : true;
          conversationList
              .add(inboxModel.ClaimBusinessMessageModel.fromJson(data).data!);
        }

        try {
          if (conversationList.isNotEmpty) {
            for (int x = 0; x < conversationList.length; x += 1) {
              if (conversationList[x].conversationPerson != null &&
                  conversationList[x].conversationPerson!.isNotEmpty &&
                  conversationList[x].messages != null &&
                  conversationList[x].messages!.isNotEmpty) {
                for (int y = 0;
                    y < conversationList[x].conversationPerson!.length;
                    y += 1) {
                  imgList
                      .add(conversationList[x].conversationPerson![y].imgPath);
                  for (int z = 0;
                      z < conversationList[x].messages!.length;
                      z += 1) {
                    if (conversationList[x].conversationPerson![y].id ==
                        conversationList[x].messages![z].userableId) {
                      filteredConvList.add(
                        ConvMessage(
                          id: conversationList[x].messages![z].id ?? 0,
                          img: conversationList[x]
                                  .conversationPerson![y]
                                  .imgPath ??
                              "",
                          userableId:
                              conversationList[x].messages![z].userableId ?? 0,
                          userableType:
                              conversationList[x].messages![z].userableType ??
                                  "",
                          title: conversationList[x].messages![z].title ?? "",
                          description:
                              conversationList[x].messages![z].description ??
                                  "",
                          createdAt: conversationList[x].messages![z].createdAt,
                        ),
                      );
                    }
                  }
                }
              }
            }
          }
          filteredConvList = List.from(filteredConvList.reversed);
        } catch (e) {
          if (isFromReplyConv == false) {
            isGettingConv = false;
          }
          conversationList = [];
          Helpers.showSnackBar(msg: e.toString());
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      conversationList = [];
    }
  }

  TextEditingController replyTicketEditingCtrl = TextEditingController();
  bool replyEditingCtrlEmpty = true;
  bool isReplyingConv = false;
  Future replyConv(
      {required BuildContext context, Map<String, dynamic>? fields}) async {
    isReplyingConv = true;
    update();
    http.Response response =
        await ClaimBusinessRepo.claimBusinessConversationReply(fields: fields);
    isReplyingConv = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        replyTicketEditingCtrl.clear();
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
  dynamic userableType;
  dynamic userableId;
  dynamic title;
  dynamic description;
  dynamic createdAt;
  ConvMessage(
      {this.id,
      this.img,
      this.userableId,
      this.userableType,
      this.title,
      this.description,
      this.createdAt});
}
