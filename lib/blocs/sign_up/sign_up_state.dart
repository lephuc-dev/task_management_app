import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final bool? success;
  final String? error;

  SignUpState({
    SignUpState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
