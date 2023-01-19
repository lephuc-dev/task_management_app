import 'package:equatable/equatable.dart';

class ProfileTabState extends Equatable {
  final bool? success;
  final String? error;

  ProfileTabState({
    ProfileTabState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
