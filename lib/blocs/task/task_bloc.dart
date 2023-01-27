import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../base/base.dart';
import '../blocs.dart';

class TaskBloc extends BaseBloc<TaskState> {
  final TaskRepository taskRepository;
  final UserRepository userRepository;

  TaskBloc(this.taskRepository, this.userRepository);

  Stream<TaskModel> getTaskStream(String taskId) {
    return taskRepository.getTaskStream(taskId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
