import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/core/app_constants.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => controller.myremoteUid.value == 0
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Waiting for others to join',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Center(
                        child: controller.localUserJoined.value == true
                            ? controller.videoPaused.value == true
                                ? Container(
                                    color: Colors.red,
                                    child: Center(
                                        child: Text(
                                      "Remote Video Paused",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white70),
                                    )))
                                : AgoraVideoView(
                                    controller: VideoViewController.remote(
                                      rtcEngine: controller.engine,
                                      canvas: VideoCanvas(
                                          uid: controller.myremoteUid.value),
                                      connection: RtcConnection(
                                          channelId: AppConstants.channelName),
                                    ),
                                  )
                            : const Center(
                                child: Text(
                                  'No Remote',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 200,
                          height: 250,
                          child: Center(
                              child: controller.localUserJoined.value
                                  ? AgoraVideoView(
                                      controller: VideoViewController(
                                        rtcEngine: controller.engine,
                                        canvas: const VideoCanvas(uid: 0),
                                      ),
                                    )
                                  : const CircularProgressIndicator()),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  controller.onToggleMute();
                                },
                                child: Icon(
                                  controller.muted.value
                                      ? Icons.mic
                                      : Icons.mic_off,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  controller.onCallEnd();
                                },
                                child: const Icon(
                                  Icons.call,
                                  size: 35,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  controller.onVideoOff();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Center(
                                      child: Icon(
                                        Icons.photo_camera_front,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  controller.onSwitchCamera();
                                },
                                child: const Icon(
                                  Icons.switch_camera,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
