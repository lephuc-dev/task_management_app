import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:task_management_app/models/models.dart';
import 'package:task_management_app/resources/colors.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

final String localUserID = math.Random().nextInt(10000).toString();

class VideoCallPage extends StatelessWidget {
  final String conferenceID;
  final User currentuser;

  const VideoCallPage({
    Key? key,
    required this.conferenceID,
    required this.currentuser,
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
        userName: currentuser.name.toString(),
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    currentuser.avatar!,
                  ),
                ),
              ),
            );
          },
            topMenuBarConfig: ZegoTopMenuBarConfig(
                title: "Meet"
            ),
          onLeaveConfirmation: (BuildContext context) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                  title: const Text("Leave the meeting",
                      style: TextStyle(color: Colors.white70)),
                  content: const Text(
                      "Are you sure to leave the meeting?",
                      style: TextStyle(color: Colors.white70)),
                  actions: [
                    ElevatedButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white70)),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ElevatedButton(
                      child: const Text("Exit"),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              },
            );
          },
        )
      ),
    );
  }
}