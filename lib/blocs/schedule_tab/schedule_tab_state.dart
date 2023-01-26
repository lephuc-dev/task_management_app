import 'package:equatable/equatable.dart';

class ScheduleTabState extends Equatable {
  final bool? success;
  final String? error;

  ScheduleTabState({
    ScheduleTabState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
