import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';
import 'package:task_management_app/models/meeting_participant_model.dart';
import 'package:task_management_app/models/models.dart';
import 'package:task_management_app/pages/meeting/widgets/meeting_item.dart';
import 'package:task_management_app/pages/meeting/widgets/project_item.dart';

import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class MeetingPage extends StatefulWidget {
  final MeetingBloc bloc;
  const MeetingPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends BaseState<MeetingPage, MeetingBloc> {

  TextEditingController meetingNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _projectformKey = GlobalKey<FormState>();

  Project? project = null;

  String? selected = "";

  @override
  void dispose() {
    meetingNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Meeting",
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            showMeetingDialog();
        },
        backgroundColor: AppColors.green60,
        child: SvgPicture.asset(
          VectorImageAssets.ic_add,
          height: 24,
          width: 24,
          color: AppColors.primaryWhite,
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<ProjectParticipant>>(
              stream: widget.bloc.getListProjectByMyIdStream(),
              builder: (context, snapshot){
                if(snapshot.hasData)
                {
                  if (snapshot.data!.isNotEmpty) {
                    return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8,),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              return StreamBuilder<Project>(
                                  stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
                                  builder: (context, projectSnapshot) {
                                    if (projectSnapshot.hasData) {
                                      return Container(
                                        child: StreamBuilder<List<MeetingModel>>(
                                          stream: widget.bloc.getListMeetingByMyProjectIdStream(projectSnapshot.data!.id.toString()),
                                          builder: (context, meetingsnapshot) {
                                            if(meetingsnapshot.hasData){
                                              if(meetingsnapshot.data!.isNotEmpty){
                                                return Column(
                                                  children: [
                                                    titleWidget(title: projectSnapshot.data!.name.toString()),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: meetingsnapshot.data!.length,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        itemBuilder: (BuildContext context, int index){
                                                          print("oke");
                                                          return MeetingItem(meeting: meetingsnapshot.data![index]);
                                                        }
                                                    ),
                                                  ],
                                                );
                                              }
                                              else{
                                                return Container();
                                              }
                                            }
                                            else
                                            {
                                              return Container();
                                            }
                                          }
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            },
                          ),
                        );
                  } else {
                    return Container();
                  }
                }
                else
                {
                  return Center(

                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showMeetingDialog() {
    selected = "";
    meetingNameController.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            title: Text(
              "Meeting name",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                   return Form(
                     key: _formKey,
                     child: SizedBox(
                       width: MediaQuery.of(context).size.width,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           CustomTextField(
                             textFieldType: TextFieldType.text,
                             textFieldConfig: TextFieldConfig(
                               controller: meetingNameController,
                               style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                               cursorColor: AppColors.primaryBlack,
                             ),
                             decorationConfig: TextFieldDecorationConfig(
                               hintText: "Enter meeting name",
                               hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                               errorStyle:
                               Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w300, fontSize: 13, color: AppColors.red60),
                               enabledBorder: const UnderlineInputBorder(
                                 borderSide: BorderSide(color: AppColors.neutral95, width: 1),
                               ),
                               focusedBorder: const UnderlineInputBorder(
                                 borderSide: BorderSide(color: AppColors.mediumPersianBlue, width: 1),
                               ),
                               errorBorder: const UnderlineInputBorder(
                                 borderSide: BorderSide(color: AppColors.red60, width: 1),
                               ),
                               focusedErrorBorder: const UnderlineInputBorder(
                                 borderSide: BorderSide(color: AppColors.red60, width: 1),
                               ),
                             ),
                           ),
                           Container(
                             child: SingleChildScrollView(
                               child: StreamBuilder<List<ProjectParticipant>>(
                                   stream: widget.bloc.getListOwnProjectByMyIdStream(),
                                   builder: (context, snapshot){
                                     if(snapshot.hasData)
                                     {
                                       if (snapshot.data!.isNotEmpty) {
                                         return Column(
                                           children: [
                                             titleWidget(title: "Project"),
                                             Padding(
                                               padding: const EdgeInsets.symmetric(vertical: 8),
                                               child: ListView.builder(
                                                 shrinkWrap: true,
                                                 itemCount: snapshot.data!.length,
                                                 physics: const NeverScrollableScrollPhysics(),
                                                 itemBuilder: (BuildContext context, int i) {
                                                   return Container(
                                                     child: Row(
                                                       children: <Widget>[
                                                         Radio(
                                                             value: snapshot.data![i].projectId,
                                                             groupValue: selected,
                                                             onChanged: (s){
                                                               setState((){
                                                                 selected = s;
                                                                 print(s);
                                                               });
                                                             }
                                                         ),
                                                         Container(
                                                           child: StreamBuilder<Project>(
                                                             stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
                                                           builder: (context, projectSnapshot) {
                                                             if (projectSnapshot.hasData) {
                                                               return ProjectItem(
                                                                   project: projectSnapshot.data!,
                                                                   );

                                                             } else {
                                                               return Container();
                                                             }
                                                       }),
                                                         )
                                                       ],
                                                     ),
                                                   );
                                                 },
                                               ),
                                             ),
                                           ],
                                         );
                                       } else {
                                         return Container();
                                       }
                                     }
                                     else
                                     {
                                         return Center(

                                         );
                                     }
                                   },
                               ),
                             ),
                             // child: Container(
                             //   child: titleWidget(title: "Project"),
                             // ),
                           ),
                           // titleListWidget(title: project == null ? "No project" : project!.name.toString(), onTap:(){
                           //   showProjectDialog();})
                         ],
                       ),
                     ),
                   );
                },
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Create',
                  style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
                ),
                onPressed: () {
                  primaryFocus?.unfocus();
                  if (_formKey.currentState?.validate() == true && meetingNameController.text != "" && selected != "") {
                    primaryFocus?.unfocus();
                    bloc.createMeeting(name: meetingNameController.text.trim(), projectId: selected!);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }


  // void showProjectDialog() {
  //   //project = null;
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           insetPadding: const EdgeInsets.all(16),
  //           title: Text(
  //             "Project",
  //             style: Theme.of(context).textTheme.headline3,
  //           ),
  //           content: StatefulBuilder(
  //              builder: (BuildContext context, void Function(void Function()) setState) {
  //                return Form(
  //                  key: _projectformKey,
  //                  child: SizedBox(
  //                    width: MediaQuery.of(context).size.width,
  //                    child: Column(
  //                      mainAxisSize: MainAxisSize.min,
  //                      children: [
  //                        Container(
  //                          child: SingleChildScrollView(
  //                            child: StreamBuilder<List<ProjectParticipant>>(
  //                              stream: widget.bloc.getListProjectByMyIdStream(),
  //                              builder: (context, snapshot){
  //                                if(snapshot.hasData)
  //                                {
  //                                  if (snapshot.data!.isNotEmpty) {
  //                                    return Column(
  //                                      children: [
  //                                        Padding(
  //                                          padding: const EdgeInsets.symmetric(vertical: 8),
  //                                          child: ListView.builder(
  //                                            shrinkWrap: true,
  //                                            itemCount: snapshot.data!.length,
  //                                            physics: const NeverScrollableScrollPhysics(),
  //                                            itemBuilder: (BuildContext context, int i) {
  //                                              return StreamBuilder<Project>(
  //                                                  stream: widget.bloc.getProjectStream(snapshot.data![i].projectId ?? ""),
  //                                                  builder: (context, projectSnapshot) {
  //                                                    if (projectSnapshot.hasData) {
  //                                                      return ProjectItem(
  //                                                        project: projectSnapshot.data!,
  //                                                        onPress: (){
  //                                                          print("??????");
  //                                                          Navigator.pop(context);
  //                                                          setState(() {
  //                                                            project = projectSnapshot.data!;
  //                                                          });
  //                                                        },
  //                                                      );
  //                                                    } else {
  //                                                      return Container();
  //                                                    }
  //                                                  });
  //                                            },
  //                                          ),
  //                                        ),
  //                                      ],
  //                                    );
  //                                  } else {
  //                                    return Container();
  //                                  }
  //                                }
  //                                else
  //                                {
  //                                  return Center(
  //
  //                                  );
  //                                }
  //                              },
  //                            ),
  //                          ),
  //
  //                        ),
  //
  //                      ],
  //                    ),
  //                  ),
  //                );
  //              },
  //           ),
  //           actions: [
  //             TextButton(
  //               child: Text(
  //                 'Cancel',
  //                 style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.primaryBlack),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text(
  //                 'Create',
  //                 style: Theme.of(context).textTheme.button?.copyWith(color: AppColors.mediumPersianBlue),
  //               ),
  //               onPressed: () {
  //                 primaryFocus?.unfocus();
  //                 if (_projectformKey.currentState?.validate() == true && meetingNameController.text != "") {
  //                   primaryFocus?.unfocus();
  //                   bloc.createMeeting(name: meetingNameController.text.trim(), projectId: "");
  //                   Navigator.pop(context);
  //                 }
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

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
  MeetingBloc get bloc => widget.bloc;
}
