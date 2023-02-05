import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../blocs.dart';

class ScheduleTabBloc extends BaseBloc<ScheduleTabState> {
  final TaskRepository taskRepository;
  final TaskParticipantRepository taskParticipantRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  ScheduleTabBloc(
    this.taskRepository,
    this.taskParticipantRepository,
    this.authenticationRepository,
    this.projectParticipantRepository,
    this.userRepository,
  );

  Stream<List<TaskParticipant>> getListTaskParticipantByMyIdStream() {
    return taskParticipantRepository.getListTaskParticipantByUidStream(authenticationRepository.getCurrentUserId());
  }

  Stream<TaskModel> getTaskStream(String taskId) {
    return taskRepository.getTaskStream(taskId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
