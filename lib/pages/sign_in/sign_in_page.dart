import 'package:flutter/material.dart';
import '../../router/router.dart';
import '../../resources/resources.dart';
import '../../base/base.dart';
import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';

class SignInPage extends StatefulWidget {
  final SignInBloc bloc;
  const SignInPage(this.bloc, {Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends BaseState<SignInPage, SignInBloc> {
  @override
  SignInBloc get bloc => widget.bloc;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void onLogInClick() {
    primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() == true) {
      String email = emailTextController.text.toString().trim();
      String password = passwordTextController.text.toString().trim();
      bloc.onSignIn(email, password, () => onLogInSuccess(), (error) => onLogInError(error));
    }
  }

  void onLogInSuccess() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  void onLogInError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          title: "Login Failed",
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
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Log In",
                          style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 28),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Welcome back!",
                          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                color: AppColors.neutral60,
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 32),
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
                        const SizedBox(height: 32),
                        CommonButton(
                          content: 'Log In',
                          onTap: () => onLogInClick(),
                        ),
                        const SizedBox(height: 16),
                        InkWellWrapper(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () => Navigator.pushNamed(context, Routes.signUp),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Sign Up",
                                  style: Theme.of(context).textTheme.headline3?.copyWith(
                                        color: AppColors.mediumPersianBlue,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                          ),
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
