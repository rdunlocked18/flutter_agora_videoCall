import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/core/app_enums.dart';
import 'package:flutter_video_call/app/modules/videocall/controllers/videocall_controller.dart';
import 'package:flutter_video_call/widgets/video_view_grid_item.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VideoCallView extends GetView<VideoCallViewController> {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          title: Text(
            controller.videocallType == VideoCallViewType.group
                ? 'Meeting : ${controller.channelNameMain.value}'
                : 'Personal : ${controller.channelNameMain.value}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.showSnackbar(const GetSnackBar(
                  message: 'Share not available',
                  duration: Duration(seconds: 2),
                  isDismissible: true,
                ));
              },
              icon: const Icon(
                Iconsax.share,
                color: Colors.white,
              ),
            )
          ],
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Obx(
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
                            'Waiting for others to join..',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          controller.videocallType == VideoCallViewType.group
                              ? Center(
                                  child: controller.localUserJoined.value ==
                                          true
                                      ? controller.videoPaused.value == true
                                          ? Container(
                                              color: Colors.red,
                                              child: Center(
                                                  child: Text(
                                                "Remote Video Paused",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.white70),
                                              )))
                                          : _buildRemoteViews()
                                      : const Center(
                                          child: Text(
                                            'No Remote',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                )
                              : Center(
                                  child: AgoraVideoView(
                                    controller: VideoViewController.remote(
                                      rtcEngine: controller.engine,
                                      canvas: VideoCanvas(
                                          uid: controller.remoteUids[0]),
                                      connection: RtcConnection(
                                          channelId:
                                              controller.channelNameMain.value),
                                    ),
                                  ),
                                ),
                          Obx(
                            () => Positioned(
                              left: controller.leftX.value,
                              top: controller.topY.value,
                              child: GestureDetector(
                                onPanStart: (details) {
                                  controller.initX.value =
                                      details.globalPosition.dx;
                                  controller.initY.value =
                                      details.globalPosition.dy;
                                },
                                onPanUpdate: (details) {
                                  final dx = details.globalPosition.dx -
                                      controller.initX.value;
                                  final dy = details.globalPosition.dy -
                                      controller.initY.value;
                                  controller.initX.value =
                                      details.globalPosition.dx;
                                  controller.initY.value =
                                      details.globalPosition.dy;
                                  controller.topY.value =
                                      (controller.topY.value + dy)
                                          .clamp(0.0, double.infinity);
                                  controller.leftX.value =
                                      (controller.leftX.value + dx)
                                          .clamp(0.0, double.infinity);
                                },
                                child: SizedBox(
                                  width: controller.zoneWidth.value,
                                  height: controller.zoneHeight.value,
                                  child: Center(
                                      child: controller.localUserJoined.value
                                          ? AgoraVideoView(
                                              controller: VideoViewController(
                                                rtcEngine: controller.engine,
                                                canvas:
                                                    const VideoCanvas(uid: 0),
                                              ),
                                            )
                                          : const CircularProgressIndicator()),
                                ),
                              ),
                            ),
                          ),
                          buildBottomControls(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteViews() {
    if (controller.remoteUids.length == 1) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.engine,
          canvas: VideoCanvas(uid: controller.remoteUids[0]),
          connection:
              RtcConnection(channelId: controller.channelNameMain.value),
        ),
      );
    } else if (controller.remoteUids.length == 2) {
      return Column(
        children: [
          Expanded(
            // flex: 3,
            child: GridView.builder(
              itemCount: 2,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoViewGridItem(
                    userId: controller.remoteUids[index],
                    channelName: '',
                    engine: controller.engine,
                    isVideoOn: true,
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            // flex: 3,
            child: GridView.builder(
              itemCount: controller.remoteUids.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoViewGridItem(
                    userId: controller.remoteUids[index],
                    channelName: '',
                    engine: controller.engine,
                    isVideoOn: true,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildBottomControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
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
              height: 50,
              width: 50,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                color: Colors.white,
                onPressed: () {
                  controller.onToggleMute();
                },
                icon: Icon(
                  controller.muted.value
                      ? Iconsax.microphone5
                      : Iconsax.microphone_slash5,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 52,
              width: 200,
              child: ElevatedButton.icon(
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'End Call',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                icon: const Icon(
                  Iconsax.call_remove,
                  fill: 1,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.onCallEnd();
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
            // const Gap(10),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                color: Colors.white,
                onPressed: () {
                  controller.onSwitchCamera();
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
