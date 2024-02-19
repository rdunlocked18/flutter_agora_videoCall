library agora_manager;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraManager {
  late Map<String, dynamic> config;
  int localUid = -1;
  String appId = "cfa03c516b39404b98385605334f5b60", channelName = "Rohit";
  List<int> remoteUids = [];
  bool isJoined = false;
  bool isBroadcaster = true;
  RtcEngine? agoraEngine;

  Function(String message) messageCallback;
  Function(String eventName, Map<String, dynamic> eventArgs) eventCallback;

  AgoraManager.protectedConstructor({
    required this.messageCallback,
    required this.eventCallback,
  });

  static Future<AgoraManager> create({
    required Function(String message) messageCallback,
    required Function(String eventName, Map<String, dynamic> eventArgs)
        eventCallback,
  }) async {
    final manager = AgoraManager.protectedConstructor(
      messageCallback: messageCallback,
      eventCallback: eventCallback,
    );

    await manager.initialize();
    return manager;
  }

  Future<void> initialize() async {
    // try {
    //   String configString =
    //       await rootBundle.loadString('assets/config/config.json');
    //   config = jsonDecode(configString);
    //   appId = config["appId"];
    //   channelName = config["channelName"];
    //   localUid = config["uid"];
    // } catch (e) {
    //   messageCallback(e.toString());
    // }
  }

  AgoraVideoView remoteVideoView(int remoteUid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agoraEngine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: channelName),
      ),
    );
  }

  AgoraVideoView localVideoView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: agoraEngine!,
        canvas: const VideoCanvas(
            uid: 0,
            renderMode:
                RenderModeType.renderModeHidden), // Use uid = 0 for local view
      ),
    );
  }

  RtcEngineEventHandler getEventHandler() {
    return RtcEngineEventHandler(
      // Occurs when the network connection state changes
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        if (reason ==
            ConnectionChangedReasonType.connectionChangedLeaveChannel) {
          remoteUids.clear();
          isJoined = false;
        }
        Map<String, dynamic> eventArgs = {};
        eventArgs["connection"] = connection;
        eventArgs["state"] = state;
        eventArgs["reason"] = reason;
        eventCallback("onConnectionStateChanged", eventArgs);
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        isJoined = true;
        messageCallback(
            "Local user uid:${connection.localUid} joined the channel");
        Map<String, dynamic> eventArgs = {};
        eventArgs["connection"] = connection;
        eventArgs["elapsed"] = elapsed;
        eventCallback("onJoinChannelSuccess", eventArgs);
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        remoteUids.add(remoteUid);
        messageCallback("Remote user uid:$remoteUid joined the channel");
        // Notify the UI
        Map<String, dynamic> eventArgs = {};
        eventArgs["connection"] = connection;
        eventArgs["remoteUid"] = remoteUid;
        eventArgs["elapsed"] = elapsed;
        eventCallback("onUserJoined", eventArgs);
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        remoteUids.remove(remoteUid);
        messageCallback("Remote user uid:$remoteUid left the channel");
        Map<String, dynamic> eventArgs = {};
        eventArgs["connection"] = connection;
        eventArgs["remoteUid"] = remoteUid;
        eventArgs["reason"] = reason;
        eventCallback("onUserOffline", eventArgs);
      },
    );
  }

  Future<void> setupAgoraEngine() async {
    await [Permission.microphone, Permission.camera].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine!.initialize(RtcEngineContext(appId: appId));

    await agoraEngine!.enableVideo();

    agoraEngine!.registerEventHandler(getEventHandler());
  }

  Future<void> join({
    String channelName = '',
    String token = '',
    int uid = -1,
    ClientRoleType clientRole = ClientRoleType.clientRoleBroadcaster,
  }) async {
    channelName = (channelName.isEmpty) ? this.channelName : channelName;
    token = (token.isEmpty) ? config['rtcToken'] : token;
    uid = (uid == -1) ? localUid : uid;

    // Set up Agora engine
    if (agoraEngine == null) await setupAgoraEngine();

    // Enable the local video preview
    await agoraEngine!.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = ChannelMediaOptions(
      clientRoleType: clientRole,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    // Join a channel
    await agoraEngine!.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  Future<void> leave() async {
    // Clear saved remote Uids
    remoteUids.clear();

    // Leave the channel
    if (agoraEngine != null) {
      await agoraEngine!.leaveChannel();
    }
    isJoined = false;

    // Destroy the Agora engine instance
    destroyAgoraEngine();
  }

  void destroyAgoraEngine() {
    // Release the RtcEngine instance to free up resources
    if (agoraEngine != null) {
      agoraEngine!.release();
      agoraEngine = null;
    }
  }

  Future<void> dispose() async {
    if (isJoined) {
      await leave();
    }
    destroyAgoraEngine();
  }
}
