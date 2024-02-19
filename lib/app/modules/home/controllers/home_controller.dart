// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/modules/home/views/group_video_call_home.dart';
import 'package:flutter_video_call/app/modules/home/views/single_chat_view.dart';
import 'package:flutter_video_call/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  TextEditingController channelNameController = TextEditingController();
  List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
  ];

  RxList<Widget> screens = [SingleChatView(), GroupVideoCall()].obs;
  RxInt currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentIndex.value);
    super.onInit();
  }

  Future<void> requestPermissions() async {
    if (channelNameController.text.isNotEmpty) {
      var response = await getToken(channelNameController.text);
      //
      print(response['token']);
      print(response['userId']);
      //
      await permissions.request().then(
            (value) => Get.toNamed(
              Routes.VIDEOCALL,
              arguments: {
                'userId': response['userId'],
                'token': response['token'],
                'channelName': channelNameController.text
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
      print(response.data['rtcToken']);
      token = response.data['rtcToken'];
    }
    return {
      'token': token,
      'userId': userId,
    };
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}
