import 'package:flutter/material.dart';
import 'package:task_management_app/base/base.dart';
import 'package:task_management_app/blocs/blocs.dart';
import 'package:task_management_app/resources/resources.dart';
import 'package:task_management_app/widgets/widgets.dart';

class ChangeNamePage extends StatefulWidget {
  final ChangeNameBloc bloc;
  const ChangeNamePage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends BaseState<ChangeNamePage, ChangeNameBloc> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameTextController = TextEditingController();

  bool isEnableButton = false;
  String currentName = '';

  @override
  void initState() {
    super.initState();
    bloc.getInformationUserStream().first.then((value) {
      nameTextController.text = value.name ?? "";
      setState(() {
        currentName = value.name ?? "";
      });
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusedWidget(
      child: StreamBuilder<bool>(
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
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change name",
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
                              Text(
                                "Name",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                textFieldType: TextFieldType.name,
                                textFieldConfig: TextFieldConfig(
                                  controller: nameTextController,
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                  cursorColor: AppColors.primaryBlack,
                                ),
                                decorationConfig: TextFieldDecorationConfig(
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: "Enter your name",
                                  fillColor: AppColors.neutral95,
                                  filled: true,
                                  hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral60),
                                  errorStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                        color: AppColors.red60,
                                      ),
                                  enabledBorder: _getEnabledBorder(),
                                  focusedBorder: _getFocusedBorder(),
                                  errorBorder: _getErrorBorder(),
                                  focusedErrorBorder: _getFocusedErrorBorder(),
                                ),
                                onChanged: (value) {
                                  if (value == '' || value == currentName) {
                                    setState(() {
                                      isEnableButton = false;
                                    });
                                  } else {
                                    setState(() {
                                      isEnableButton = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IntrinsicHeight(
                          child: CommonButton(
                            content: 'Change name',
                            isEnableButton: isEnableButton,
                            onTap: () => onClick(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _getEnabledBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.neutral95, width: 1),
        borderRadius: BorderRadius.circular(4),
      );

  _getFocusedBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.mediumPersianBlue, width: 1),
        borderRadius: BorderRadius.circular(4),
      );

  _getErrorBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.red60, width: 1),
        borderRadius: BorderRadius.circular(4),
      );

  _getFocusedErrorBorder() => OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.red60, width: 1),
        borderRadius: BorderRadius.circular(4),
      );

  void onClick() {
    primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() == true) {
      String name = nameTextController.text.toString().trim();

      bloc.onUpdateUser(
          name, () => onSuccess(), (error) => onError(error));
    }
  }

  void onSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Success",
          description: "Your name is changed",
          contentButton: "Close",
          onTap: () => {
            Navigator.pop(context),
            Navigator.pop(context),
          },
        );
      },
    );
  }

  void onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Failed",
          description: error,
          contentButton: "Close",
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  ChangeNameBloc get bloc => widget.bloc;
}
