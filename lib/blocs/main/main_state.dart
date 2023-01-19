import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final bool? success;
  final String? error;

  MainState({
    MainState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
