import 'package:equatable/equatable.dart';

class MeetingState extends Equatable {
  final bool? success;
  final String? error;

  MeetingState({
    MeetingState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
