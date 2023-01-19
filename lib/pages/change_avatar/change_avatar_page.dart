import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class ChangeAvatarPage extends StatefulWidget {
  final ChangeAvatarBloc bloc;
  const ChangeAvatarPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends BaseState<ChangeAvatarPage, ChangeAvatarBloc> {
  String avatar = "";
  String name = "";
  bool isEnableButton = false;

  XFile? _imageFile;
  @override
  void initState() {
    super.initState();
    bloc.getInformationUserStream().first.then((value) {
      setState(() {
        avatar = value.avatar ?? "";
        name = value.name ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.loadingStream,
        builder: (context, snapshot) {
          return LoadingOverLayWidget(
            isLoading: snapshot.data ?? false,
            child: Scaffold(
              backgroundColor: AppColors.primaryWhite,
              appBar: AppBar(
                backgroundColor: AppColors.primaryWhite,
                elevation: 0,
                iconTheme: const IconThemeData(color: AppColors.primaryBlack),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Change avatar",
                            style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Create account and manage your tasks",
                            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  color: AppColors.neutral60,
                                  fontSize: 14,
                                ),
                          ),
                          const SizedBox(height: 32),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              LoadingContainer(
                                height: MediaQuery.of(context).size.width - 32,
                                width: MediaQuery.of(context).size.width - 32,
                              ),
                              InkWellWrapper(
                                onTap: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    setState(() {
                                      _imageFile = pickedFile;
                                      isEnableButton = true;
                                    });
                                  }
                                },
                                child: _imageFile == null
                                    ? Image.network(
                                        avatar,
                                        height: MediaQuery.of(context).size.width - 32,
                                        width: MediaQuery.of(context).size.width - 32,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, event) {
                                          if (event == null) return child;
                                          return const LoadingContainer(height: 74, width: 74);
                                        },
                                        errorBuilder: (context, object, stacktrace) {
                                          return AvatarWithName(
                                            name: name,
                                            boxShape: BoxShape.rectangle,
                                            fontSize: (MediaQuery.of(context).size.width - 32) / 4,
                                            shapeSize: MediaQuery.of(context).size.width - 32,
                                            count: 2,
                                          );
                                        },
                                      )
                                    : Image.file(
                                        File(_imageFile!.path),
                                        height: MediaQuery.of(context).size.width - 32,
                                        width: MediaQuery.of(context).size.width - 32,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, object, stacktrace) {
                                          return AvatarWithName(
                                            name: name,
                                            boxShape: BoxShape.rectangle,
                                            fontSize: (MediaQuery.of(context).size.width - 32) / 4,
                                            shapeSize: MediaQuery.of(context).size.width - 32,
                                            count: 2,
                                          );
                                        },
                                      ),
                              ),
                              Visibility(
                                visible: _imageFile == null ? false : true,
                                child: InkWellWrapper(
                                  onTap: () async {
                                    _cropImage();
                                  },
                                  paddingChild: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  borderRadius: BorderRadius.circular(4),
                                  margin: const EdgeInsets.all(8),
                                  color: AppColors.primaryWhite.withOpacity(0.8),
                                  child: SvgPicture.asset(
                                    VectorImageAssets.ic_crop,
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IntrinsicHeight(
                        child: CommonButton(
                          content: 'Change avatar',
                          isEnableButton: isEnableButton,
                          onTap: () => {
                            onChangeAvatarClick(),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.primaryBlack,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: AppColors.mediumPersianBlue,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = XFile(croppedFile.path);
        });
      }
    }
  }

  void onChangeAvatarClick() {
    bloc.emitLoading(true);
    if (_imageFile != null) {
      bloc.uploadImage(
        _imageFile!.path,
        onUpdateSuccess,
        (error) => onUpdateError(error),
      );
    }
  }

  void onUpdateSuccess() {
    bloc.emitLoading(false);
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Update Avatar Success",
          description: "Success!",
          contentButton: "Close",
          onTap: () => {
            Navigator.pop(context),
            Navigator.pop(context),
          },
        );
      },
    );
  }

  void onUpdateError(String error) {
    bloc.emitLoading(false);
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
            title: "Update Avatar Failed",
            description: error,
            contentButton: "Close",
            onTap: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                });
      },
    );
  }

  @override
  ChangeAvatarBloc get bloc => widget.bloc;
}
