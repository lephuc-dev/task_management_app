import 'package:flutter/material.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  final ChangePasswordBloc bloc;
  const ChangePasswordPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends BaseState<ChangePasswordPage, ChangePasswordBloc> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  bool isCurrentPasswordEmpty = true;
  bool isNewPasswordEmpty = true;
  bool isConfirmPasswordEmpty = true;

  bool isEnableButton = false;

  String email = "";

  @override
  void initState() {
    super.initState();
    bloc.getInformationUserStream().first.then((value) {
      setState(() {
        email = value.email ?? "";
      });
    });
  }

  @override
  void dispose() {
    currentPasswordTextController.dispose();
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
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
                                "Change password",
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
                                "Current password",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                textFieldType: TextFieldType.password,
                                textFieldConfig: TextFieldConfig(
                                  controller: currentPasswordTextController,
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                  cursorColor: AppColors.primaryBlack,
                                ),
                                decorationConfig: TextFieldDecorationConfig(
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: "Enter your current password",
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
                                  String? errorMessage = TextFieldValidatorUtils.validatePassword(value, errorMessage: "haveError");
                                  if (value == "" || errorMessage != null) {
                                    setState(() {
                                      isCurrentPasswordEmpty = true;
                                    });
                                  } else {
                                    isCurrentPasswordEmpty = false;
                                  }
                                  enableButton();
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "New password",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                textFieldType: TextFieldType.password,
                                textFieldConfig: TextFieldConfig(
                                  controller: newPasswordTextController,
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                  cursorColor: AppColors.primaryBlack,
                                ),
                                decorationConfig: TextFieldDecorationConfig(
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: "Enter your new password",
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
                                  String? errorMessage = TextFieldValidatorUtils.validatePassword(value, errorMessage: "haveError");
                                  if (value == "" || errorMessage != null) {
                                    setState(() {
                                      isNewPasswordEmpty = true;
                                    });
                                  } else {
                                    setState(() {
                                      isNewPasswordEmpty = false;
                                    });
                                  }
                                  enableButton();
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Confirm new password",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                textFieldType: TextFieldType.password,
                                textFieldConfig: TextFieldConfig(
                                  controller: confirmPasswordTextController,
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                                  cursorColor: AppColors.primaryBlack,
                                ),
                                decorationConfig: TextFieldDecorationConfig(
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: "Enter your current password again",
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
                                  String? errorMessage = TextFieldValidatorUtils.validatePassword(value, errorMessage: "haveError");
                                  if (value == "" || errorMessage != null) {
                                    setState(() {
                                      isConfirmPasswordEmpty = true;
                                    });
                                  } else {
                                    setState(() {
                                      isConfirmPasswordEmpty = false;
                                    });
                                  }
                                  enableButton();
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
                            content: 'Change password',
                            isEnableButton: isEnableButton,
                            onTap: () => onUpdatePasswordClick(),
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

  void enableButton() {
    if (isCurrentPasswordEmpty == false && isNewPasswordEmpty == false && isConfirmPasswordEmpty == false) {
      setState(() {
        isEnableButton = true;
      });
    } else {
      setState(() {
        isEnableButton = false;
      });
    }
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

  void onUpdatePasswordClick() {
    primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() == true) {
      String password = currentPasswordTextController.text.toString().trim();
      String newPassword = newPasswordTextController.text.toString().trim();
      String confirmPassword = confirmPasswordTextController.text.toString().trim();

      bloc.emitLoading(true);

      if (newPassword != confirmPassword) {
        bloc.emitLoading(false);
        onPasswordNotConfirmed();
        return;
      }

      bloc.onSignIn(
        email,
        password,
        () {
          bloc.onUpdatePassword(
            newPassword,
            () => onUpdateSuccess(),
            (error) => onUpdateError(error),
          );
        },
        (msg) => onCheckPasswordFail(msg),
      );
    }
  }

  void onPasswordNotConfirmed() {
    bloc.emitLoading(false);
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Failed",
          description: "The password confirms does not match",
          contentButton: "Close",
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  void onUpdateSuccess() {
    bloc.emitLoading(false);
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Update password Success",
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
            title: "Failed",
            description: error,
            contentButton: "Close",
            onTap: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                });
      },
    );
  }

  void onCheckPasswordFail(String error) {
    bloc.emitLoading(false);
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
            title: "Password not true",
            description: error,
            contentButton: "Close",
            onTap: () => {
                  Navigator.pop(context),
                });
      },
    );
  }

  @override
  ChangePasswordBloc get bloc => widget.bloc;
}
