import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../router/router.dart';
import '../../../widgets/widgets.dart';

class MeetingItem extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingItem({Key? key, required this.meeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWrapper(
      onTap: () => Navigator.pushNamed(context, Routes.meetingRoom, arguments: meeting),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarWithName(
                  name: meeting.name ?? "",
                  shapeSize: 40,
                  fontSize: 16,
                  boxShape: BoxShape.rectangle,
                  count: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    meeting.name ?? "Unknown",
                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   height: 1,
          //   color: AppColors.primaryGray1.withOpacity(0.2),
          // )
        ],
      ),
    );
  }
}
