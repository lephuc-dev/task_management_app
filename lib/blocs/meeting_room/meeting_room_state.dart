import 'package:equatable/equatable.dart';

class MeetingRoomState extends Equatable {
  final bool? success;
  final String? error;

  MeetingRoomState({
    MeetingRoomState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
