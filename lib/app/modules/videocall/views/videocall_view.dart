import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/modules/videocall/controllers/videocall_controller.dart';
import 'package:flutter_video_call/widgets/video_view_grid_item.dart';

import 'package:get/get.dart';

class VideoCallView extends GetView<VideoCallViewController> {
  const VideoCallView({Key? key}) : super(key: key);

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
                                : _buildRemoteViews()
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
              itemCount: 4,
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
    } else {
      return Column(
        children: [
          Expanded(
            // flex: 3,
            child: GridView.builder(
              itemCount: 4,
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
}
