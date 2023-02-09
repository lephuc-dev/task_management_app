import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';
import 'package:task_management_app/models/models.dart';
import 'package:task_management_app/pages/meeting/widgets/meeting_item.dart';
import 'package:task_management_app/repositories/authentication_repository.dart';


import '../../resources/resources.dart';
import '../../widgets/widgets.dart';
import 'widgets/call_page.dart';

class MeetingRoomPage extends StatefulWidget {
  final MeetingRoomBloc bloc;
  const MeetingRoomPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<MeetingRoomPage> createState() => _MeetingRoomPageState();
}

class _MeetingRoomPageState extends BaseState<MeetingRoomPage, MeetingRoomBloc> {

  bool isInit = false;
  TextEditingController meetingNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _projectformKey = GlobalKey<FormState>();

  late MeetingModel meeting;

  Project? project = null;

  String? selected = "";

  void init() {
    if (isInit == false) {
      final meetingTemp = ModalRoute.of(context)!.settings.arguments as MeetingModel;
      setState(() {
        meeting = meetingTemp;
        isInit = true;
      });
    }
  }

  @override
  void dispose() {
    meetingNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "About meeting",
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            titleWidget(title: "Name"),
            MeetingItem(meeting: meeting,),
            titleWidget(title: "Member"),
            StreamBuilder<List<ProjectParticipant>>(
              stream: widget.bloc.getListProjectParticipantStream(meeting.projectId.toString()),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int i)
                          {
                            return StreamBuilder<User>(
                                stream: widget.bloc.getUserStream(snapshot.data![i].userId.toString()),
                                builder: (context, meetingsnapshot) {
                                  if(meetingsnapshot.hasData){
                                    return Container(
                                      child: Row(
                                        children: [
                                          meetingsnapshot.data!.avatar.toString() == ""
                                              ? AvatarWithName(
                                              name: meetingsnapshot.data!.name.toString(),
                                              fontSize: 16,
                                              shapeSize: 40)
                                              : Image.network(
                                                meetingsnapshot.data!.avatar!,
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, event) {
                                                  if (event == null) return child;
                                                  return const LoadingContainer(height: 60, width: 60);
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              meetingsnapshot.data!.name ?? "Unknown",
                                              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16),
                                            ),

                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    return Container();
                                  }
                                }
                            );
                          }
                      ),
                    );
                  }else{
                    return Container();
                  }
                }
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VideoCallPage(conferenceID: meeting.id.toString())));
              },
              icon: Icon(Icons.video_call),
              label: Text("start call"),
              style: OutlinedButton.styleFrom(
                primary: Colors.indigo,
                side: BorderSide(color: Colors.indigo),
                fixedSize: Size(350, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
            // StreamBuilder<List<ProjectParticipant>>(
            //   stream: widget.bloc.getListProjectByMyIdStream(),
            //   builder: (context, snapshot){
            //     if(snapshot.hasData)
            //     {
            //       if (snapshot.data!.isNotEmpty) {
            //         return Container(
            //           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            //           child: ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: snapshot.data!.length,
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemBuilder: (BuildContext context, int i) {
            //               return StreamBuilder<Project>(
            //                   stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
            //                   builder: (context, projectSnapshot) {
            //                     if (projectSnapshot.hasData) {
            //                       return Container(
            //                         child: StreamBuilder<List<MeetingModel>>(
            //                             stream: widget.bloc.getListMeetingByMyProjectIdStream(projectSnapshot.data!.id.toString()),
            //                             builder: (context, meetingsnapshot) {
            //                               if(meetingsnapshot.hasData){
            //                                 return ListView.builder(
            //                                     shrinkWrap: true,
            //                                     itemCount: meetingsnapshot.data!.length,
            //                                     physics: const NeverScrollableScrollPhysics(),
            //                                     itemBuilder: (BuildContext context, int index){
            //                                       print("oke");
            //                                       return MeetingItem(meeting: meetingsnapshot.data![index]);
            //                                     }
            //                                 );
            //                               }
            //                               else
            //                               {
            //                                 return Container();
            //                               }
            //                             }
            //                         ),
            //                       );
            //                     } else {
            //                       return Container();
            //                     }
            //                   });
            //             },
            //           ),
            //         );
            //       } else {
            //         return Container();
            //       }
            //     }
            //     else
            //     {
            //       return Center(
            //
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget titleWidget({required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          color: AppColors.primaryWhite,
          border: Border(
            bottom: BorderSide(color: Color(0xFFC1C2C4), width: 0.5),
            top: BorderSide(color: Color(0xFFC1C2C4), width: 0.5),
          )),
      width: MediaQuery.of(context).size.width,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget titleListWidget({required String title, required VoidCallback onTap})
  {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }

  @override
  MeetingRoomBloc get bloc => widget.bloc;
}
