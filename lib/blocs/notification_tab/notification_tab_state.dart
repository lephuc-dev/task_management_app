import 'package:equatable/equatable.dart';

class NotificationTabState extends Equatable {
  final bool? success;
  final String? error;

  NotificationTabState({
    NotificationTabState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
