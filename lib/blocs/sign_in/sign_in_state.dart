import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final bool? success;
  final String? error;

  SignInState({
    SignInState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
