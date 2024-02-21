// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        title: const Text(
          'OnboardingView',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      // bottomSheet: Container(
      //   height: 120,
      // ),
      body: Stack(
        children: [
          buildBottomControls(),
          // Expanded(
          //   flex: 3,
          //   child: GridView.builder(
          //     itemCount: 4,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.8,
          //     ),
          //     itemBuilder: (BuildContext context, int index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: VideoViewGridItem(userId: 1, channelName: '',engine: ),
          //       );
          //     },
          //   ),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: ListView.builder(
          //     itemCount: 3,
          //     scrollDirection: Axis.horizontal,
          //     // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     //   crossAxisCount: 2,
          //     //   childAspectRatio: 0.7,
          //     // ),
          //     itemBuilder: (BuildContext context, int index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(2.0),
          //         child: VideoViewGridItem(nameInitial: index.toString()),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildBottomControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color.fromARGB(59, 96, 96, 96),
                Color.fromARGB(51, 47, 47, 47),
                Color.fromARGB(48, 60, 60, 60),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                color: Colors.white,
                onPressed: () {
                  // controller.onSwitchCamera();
                },
                icon: const Icon(
                  Iconsax.microphone5,
                  color: Colors.black,
                ),
              ),
            ),
            Gap(10),
            SizedBox(
              height: 52,
              width: 200,
              child: ElevatedButton.icon(
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'End Call',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                icon: Icon(
                  Iconsax.call_remove,
                  fill: 1,
                  color: Colors.white,
                ),
                onPressed: () {
                  //controller.startvideoCustomChannelVideoCall();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xffFF0017),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Gap(10),
            SizedBox(
              height: 60,
              width: 60,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                color: Colors.white,
                onPressed: () {
                  // controller.onSwitchCamera();
                },
                icon: const Icon(
                  Iconsax.arrange_square,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
