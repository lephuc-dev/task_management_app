import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

final String localUserID = math.Random().nextInt(10000).toString();

class VideoCallPage extends StatelessWidget {
  final String conferenceID;

  const VideoCallPage({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(conferenceID);
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 480400981,
        appSign:
        "e55ef0e51e5b8c9e74598aad825abf1b588e53678ddd8855bf6f50a1a160c22d",
        userID: localUserID,
        userName: "user_$localUserID",
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
            audioVideoViewConfig: ZegoPrebuiltAudioVideoViewConfig(
              //showAvatarInAudioMode: true,
              //isVideoMirror: true,
            ),
            topMenuBarConfig: ZegoTopMenuBarConfig(
                title: "Meet"
            ),
            memberListConfig: ZegoMemberListConfig()
        ),
      ),
    );
  }
}