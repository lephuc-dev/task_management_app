import 'package:flutter/material.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../resources/resources.dart';
import '../../widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  final SignUpBloc bloc;

  const SignUpPage(this.bloc, {Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseState<SignUpPage, SignUpBloc> {
  @override
  SignUpBloc get bloc => widget.bloc;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  void onSignUpClick() {
    primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() == true) {
      String name = nameTextController.text.toString().trim();
      String email = emailTextController.text.toString().trim();
      String password = passwordTextController.text.toString().trim();
      String confirmPassword = confirmPasswordTextController.text.toString().trim();

      if (password != confirmPassword) {
        onPasswordNotConfirmed();
        return;
      }
      bloc.onSignUp(name, email, password, () => onRegisterSuccess(), (error) => onRegisterError(error));
    }
  }

  void onPasswordNotConfirmed() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Register Failed",
          description: "The password confirms does not match",
          contentButton: "Close",
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  void onRegisterSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Register Success",
          description: "Please login to continue using",
          contentButton: "Close",
          onTap: () => {
            Navigator.pop(context),
            Navigator.pop(context),
          },
        );
      },
    );
  }

  void onRegisterError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Register Failed",
          description: error,
          contentButton: "Close",
          onTap: () => Navigator.pop(context),
        );
      },
    );
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
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign Up",
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
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Email",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textFieldType: TextFieldType.email,
                          textFieldConfig: TextFieldConfig(
                            controller: emailTextController,
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                            cursorColor: AppColors.primaryBlack,
                          ),
                          decorationConfig: TextFieldDecorationConfig(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Enter your email",
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
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Password",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textFieldType: TextFieldType.password,
                          textFieldConfig: TextFieldConfig(
                            controller: passwordTextController,
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.neutral10),
                            cursorColor: AppColors.primaryBlack,
                          ),
                          decorationConfig: TextFieldDecorationConfig(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Enter your password",
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
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Confirm password",
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
                            hintText: "Enter your password again",
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
                        ),
                        const SizedBox(height: 32),
                        CommonButton(
                          content: 'Sign Up',
                          onTap: () => onSignUpClick(),
                        ),
                      ],
                    ),
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
}
