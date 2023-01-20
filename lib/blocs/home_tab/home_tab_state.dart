import 'package:equatable/equatable.dart';

class HomeTabState extends Equatable {
  final bool? success;
  final String? error;

  HomeTabState({
    HomeTabState? state,
    bool? success,
    String? error,
  })  : success = success ?? state?.success,
        error = error ?? state?.error;

  @override
  List<Object?> get props => [success, error];
}
