// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/core/app_constants.dart';
import 'package:flutter_video_call/app/core/app_enums.dart';
import 'package:get/get.dart';

class VideoCallViewController extends GetxController {
  RxInt myremoteUid = 0.obs;
  RxBool localUserJoined = false.obs;
  RxBool muted = false.obs;
  RxBool videoPaused = false.obs;
  RxBool switchMainView = false.obs;
  RxBool mutedVideo = false.obs;
  RxBool reConnectingRemoteView = false.obs;
  RxBool isFront = false.obs;
  late RtcEngine engine;
  RxList<int> remoteUids = RxList<int>.empty();
  RxString channelNameMain = ''.obs;
  VideoCallViewType videocallType = VideoCallViewType.group;
  RxDouble zoneHeight = 250.0.obs;
  RxDouble zoneWidth = 200.0.obs;
  RxDouble topY = 21.0.obs;
  RxDouble leftX = 16.0.obs;
  RxDouble initX = 0.0.obs;
  RxDouble initY = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initilize();
  }

  @override
  void onClose() {
    super.onClose();
    clear();
  }

  void clear() {
    engine.leaveChannel();
    isFront.value = false;
    reConnectingRemoteView.value = false;
    videoPaused.value = false;
    muted.value = false;
    mutedVideo.value = false;
    switchMainView.value = false;
    localUserJoined.value = false;
    update();
  }

  Future<void> initilize() async {
    var arguments = Get.arguments;
    var _token = arguments['token'];
    var userId = arguments['userId'];
    videocallType = arguments['type'];
    channelNameMain.value = arguments['channelName'];
    debugPrint("Argument Dataa : $_token $userId ${channelNameMain.value}");

    Future.delayed(Duration.zero, () async {
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      VideoEncoderConfiguration configuration = const VideoEncoderConfiguration(
          dimensions: VideoDimensions(
        width: 1080,
        height: 1920,
      ));
      await engine.setVideoEncoderConfiguration(configuration);
      await engine.joinChannel(
        token: _token,
        channelId: channelNameMain.value,
        uid: userId,
        options: const ChannelMediaOptions(),
      );
      update();
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: AppConstants.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await engine.enableVideo();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  void _addAgoraEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            localUserJoined.value = true;
            update();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            localUserJoined.value = true;
            myremoteUid.value = remoteUid;
            remoteUids.add(remoteUid);
            update();
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            if (reason == UserOfflineReasonType.userOfflineDropped) {
              myremoteUid.value = 0;
              onCallEnd();
              update();
            } else {
              myremoteUid.value = 0;
              onCallEnd();
              update();
            }
          },
          onRemoteVideoStats:
              (RtcConnection connection, RemoteVideoStats remoteVideoStats) {
            if (remoteVideoStats.receivedBitrate == 0) {
              videoPaused.value = true;
              update();
            } else {
              videoPaused.value = false;
              update();
            }
          },
          onTokenPrivilegeWillExpire:
              (RtcConnection connection, String token) {},
          onLeaveChannel: (RtcConnection connection, stats) {
            clear();
            onCallEnd();
            update();
          }),
    );
  }

  void onVideoOff() {
    mutedVideo.value = !mutedVideo.value;
    engine.muteLocalVideoStream(mutedVideo.value);
    update();
  }

  void onCallEnd() {
    clear();
    update();
  }

  void onToggleMute() {
    muted.value = !muted.value;
    engine.muteLocalAudioStream(muted.value);
    update();
  }

  void onToggleMuteVideo() {
    mutedVideo.value = !mutedVideo.value;
    engine.muteLocalVideoStream(mutedVideo.value);
    update();
  }

  void onSwitchCamera() {
    engine.switchCamera().then((value) => {}).catchError((err) {
      debugPrint(err);
      return {'error': err};
    });
  }

  @override
  void dispose() {
    engine.leaveChannel();
    engine.release();
    super.dispose();
  }
}
