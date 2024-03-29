// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/core/app_enums.dart';
import 'package:flutter_video_call/app/data/models/user.dart';
import 'package:flutter_video_call/app/modules/home/views/group_video_call_home.dart';
import 'package:flutter_video_call/app/modules/home/views/single_chat_view.dart';
import 'package:flutter_video_call/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:nanoid/async.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  TextEditingController channelNameController = TextEditingController();
  List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
  ];

  RxList<Widget> screens = [SingleChatView(), GroupVideoCall()].obs;
  RxInt currentIndex = 0.obs;
  late PageController pageController;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentIndex.value);
    super.onInit();
  }

  Future<void> startvideoCustomChannelVideoCall() async {
    debugPrint('Start video');
    if (channelNameController.text.isNotEmpty) {
      isLoading.value = true;
      var response = await getToken(channelNameController.text);
      //
      //debugPrint(response['token']);
      // debugPrint(response['userId']);
      //
      await permissions.request().then(
            (value) => Get.toNamed(
              Routes.VIDEOCALL,
              arguments: {
                'userId': response['userId'],
                'token': response['token'],
                'channelName': channelNameController.text,
                'type': VideoCallViewType.group,
              },
            ),
          );
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: 'Please enter channel name',
        duration: Duration(seconds: 3),
        isDismissible: true,
      ));
    }
  }

  Future<void> startInstantMeeting() async {
    isLoading.value = true;
    var _channelName = await createRandomChannelName();
    var _response = await getToken(_channelName);

    //debugPrint(_response['token']);
    //  debugPrint(_response['userId']);
    // debugPrint(_channelName);
    //

    await permissions.request().then(
          (value) => Get.toNamed(
            Routes.VIDEOCALL,
            arguments: {
              'userId': _response['userId'],
              'token': _response['token'],
              'channelName': _channelName,
              'type': VideoCallViewType.group,
            },
          ),
        );
  }

  void onBottomNavigationTapped(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  Future<Map<String, dynamic>> getToken(String channelName) async {
    int userId = random(100, 999);

    Dio dio = Dio();
    var token = '';

    var response =
        await dio.get('http://54.241.100.253/rtc/$channelName/0/uid/$userId');

    if (response.data != null) {
      token = response.data['rtcToken'];
    }
    isLoading.value = false;
    return {
      'token': token,
      'userId': userId,
    };
  }

  Future<String> createRandomChannelName() async {
    var channelName = await nanoid(4);
    return channelName;
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  RxList<User> chatUsers = <User>[
    User(
      userId: 123,
      userName: 'Max Lane',
      profileUrl: 'https://api.multiavatar.com/Binx%20Bond.png',
      message: 'Hi How are you ?',
    ),
    User(
      userId: 124,
      userName: 'Tine Super',
      profileUrl: 'https://api.multiavatar.com/Tine%20Bond2.png',
      message: 'Dont laugh ! :(',
    ),
    User(
      userId: 125,
      userName: 'Suo Timo',
      profileUrl: 'https://api.multiavatar.com/burys.png',
      message: 'I dont like tom',
    ),
    User(
      userId: 126,
      userName: 'Andrew Lane',
      profileUrl: 'https://api.multiavatar.com/roibut.png',
      message: 'I am not going',
    ),
    User(
      userId: 127,
      userName: 'Tom Cruise',
      profileUrl: 'https://api.multiavatar.com/gauz%20but.png',
      message: 'Coffee bro at my place?',
    ),
    User(
      userId: 128,
      userName: 'Crux Main',
      profileUrl: 'https://api.multiavatar.com/Binx%2time2.png',
      message: 'Can we meet ?',
    ),
  ].obs;

  Future<void> startPersonalVideoCall(User user) async {
    isLoading.value = true;
    var _channelName = user.userName;
    var _response = await getToken(_channelName);

    await permissions.request().then(
          (value) => Get.toNamed(
            Routes.VIDEOCALL,
            arguments: {
              'userId': _response['userId'],
              'token': _response['token'],
              'channelName': _channelName,
              'type': VideoCallViewType.personal,
            },
          ),
        );
  }
}
