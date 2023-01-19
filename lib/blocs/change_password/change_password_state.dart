import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  final bool? success;
  final String? error;

  ChangePasswordState({
    ChangePasswordState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
