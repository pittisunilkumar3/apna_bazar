import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../controllers/claim_business_inbox_controller.dart';
import '../data/repositories/notification_settings_repo.dart';
import '../data/source/errors/check_api_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';
import 'notification_service.dart';

class PushNotificationController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  dynamic data;
  RxBool isSeen = true.obs;
  Future<dynamic> getPushNotificationConfig(
      {String? channelType = "", String? uuid}) async {
    _isLoading = true;
    update();
    http.Response res = await NotificationSettingsRepo.getPusherConfig();

    if (res.statusCode == 200) {
      _isLoading = false;
      data = jsonDecode(res.body);
      update();
      if (data['status'] == "success") {
        HiveHelp.write(Keys.channelName, data['data']['channel']);
        PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
        try {
          await pusher.init(
            apiKey: data['data']['apiKey'],
            cluster: data['data']['cluster'],
            onConnectionStateChange: onConnectionStateChange,
            onSubscriptionSucceeded: onSubscriptionSucceeded,
            onEvent: onEvent,
            onSubscriptionError: onSubscriptionError,
            onMemberAdded: onMemberAdded,
            onMemberRemoved: onMemberRemoved,
          );
          await pusher.subscribe(
              channelName: channelType == "claim_business"
                  ? data['data']['chattingChannel']
                          .toString()
                          .split(".")
                          .first +
                      ".$uuid"
                  : channelType == "product_query"
                      ? data['data']['productQueryChannel']
                              .toString()
                              .split(".chat")
                              .first +
                          ".chat.$uuid"
                      : data['data']['channel']);
          await pusher.connect();
        } catch (e) {
          assert(throw (HttpException(
              '"ERROR====================================: $e"')));
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['data']);
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  void onEvent(PusherEvent event) async {
    if (kDebugMode) {
      print("onEvent: ${event.data}");
    }
    // Parse the JSON response
    Map<String, dynamic> eventData = json.decode(event.data);
    Map<String, dynamic> message = eventData['message'];
    // if the response from push notification
    if (message['userable_id'] == null) {
      String text = message['description']['text']
          .toString()
          .replaceAll("\n", "")
          .replaceAll("\r", " ");
      String formattedDate =
          DateFormat.yMMMMd().add_jm().format(DateTime.now());

      // Show the response in the flutter_local_notification
      LocalNotificationService().showNotification(
        id: Random().nextInt(99),
        title: text,
        body: formattedDate,
      );

      var storedData = await HiveHelp.read(data['data']['channel']);
      List<Map<dynamic, dynamic>> notificationList = storedData != null
          ? List<Map<dynamic, dynamic>>.from(storedData)
          : [];
      notificationList.insert(0, {
        'text': text.trim(),
        'date': formattedDate,
      });

      HiveHelp.write(data['data']['channel'], notificationList);
      HiveHelp.write(Keys.isNotificationSeen, false);
      isSeen.value = HiveHelp.read(Keys.isNotificationSeen);
    }
    // if the response from chat
    else if (message['userable_id'] != null) {
      ClaimBusinessInboxController.to.filteredConvList.insert(
          0,
          ConvMessage(
            id: message['id'] ?? 0,
            img: message['userable']['imgPath'] ?? "",
            userableId: message['userable_id'] ?? 0,
            userableType: message['userable_type'] ?? "",
            title: "",
            description: message['description'] ?? "",
            createdAt: message['created_at'],
          ));
      ClaimBusinessInboxController.to.update();
    }

    update();
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("onSubscriptionSucceeded: $channelName data: ${data}");
  }

  void onSubscriptionError(String message, dynamic e) {
    debugPrint("onSubscriptionError: $message Exception: $e");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    debugPrint("onMemberAdded: $channelName member: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    debugPrint("onMemberRemoved: $channelName member: $member");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
  }

  // clear the saved notification
  clearList() {
    var channelName = HiveHelp.read(Keys.channelName);
    HiveHelp.remove(channelName);
    update();
  }

  // is user notfication seen or unseen
  isNotiSeen() {
    HiveHelp.write(Keys.isNotificationSeen, true);
    isSeen.value = HiveHelp.read(Keys.isNotificationSeen);
    Get.toNamed(RoutesName.notificationScreen);
    update();
  }
}
