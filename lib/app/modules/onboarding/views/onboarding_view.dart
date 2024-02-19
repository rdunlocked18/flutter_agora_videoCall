// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingView'),
        centerTitle: true,
      ),
      bottomSheet: Container(
        height: 120,
      ),
      body: Column(
        children: [
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
}
