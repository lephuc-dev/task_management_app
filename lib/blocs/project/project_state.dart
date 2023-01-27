import 'package:equatable/equatable.dart';

class ProjectState extends Equatable {
  final bool? success;
  final String? error;

  ProjectState({
    ProjectState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
