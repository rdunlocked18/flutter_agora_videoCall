import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (value) {
            controller.onBottomNavigationTapped(value);
          },
          currentIndex: controller.currentIndex.value,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Iconsax.message), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.call_add), label: 'Calls')
          ],
        ),
      ),
      body: PageView(
        controller: controller.pageController,
        children: controller.screens,
      ),
    );
  }
}
