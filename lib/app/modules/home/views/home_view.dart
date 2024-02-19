import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.channelNameController,
            ),
            ElevatedButton(
              onPressed: () {
                controller.requestPermissions();
              },
              child: const Text('Join'),
            )
          ],
        ),
      ),
    );
  }
}
