// ignore_for_file: prefer_const_constructors

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class VideoViewGridItem extends StatefulWidget {
  final String nameInitial;
  final bool isVideoOn;
  final int userId;
  final String userName;
  final RtcEngine engine;
  final String channelName;

  const VideoViewGridItem({
    super.key,
    this.nameInitial = 'R',
    this.isVideoOn = false,
    required this.userId,
    this.userName = 'Rohit',
    required this.channelName,
    required this.engine,
  });

  @override
  State<VideoViewGridItem> createState() => _VideoViewGridItemState();
}

class _VideoViewGridItemState extends State<VideoViewGridItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 184, 218, 149),
      ),
      child: widget.isVideoOn
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: widget.engine,
                canvas: VideoCanvas(uid: widget.userId),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            )
          : Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    widget.nameInitial,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
