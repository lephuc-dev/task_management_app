import '../blocs.dart';
import '../../base/base.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProjectBloc extends BaseBloc<ProjectState> {
  final ProjectRepository projectRepository;
  final BoardRepository boardRepository;
  final TaskRepository taskRepository;
  final ProjectParticipantRepository participantRepository;
  final UserRepository userRepository;

  ProjectBloc(
    this.projectRepository,
    this.boardRepository,
    this.participantRepository,
    this.taskRepository,
    this.userRepository,
  );

  Stream<List<BoardModel>> getListBoardOrderByIndexStream(String projectId) {
    return boardRepository.getListBoardOrderByIndexStream(projectId);
  }

  Stream<List<TaskModel>> getListTaskOrderByIndexStream(String boardId) {
    return taskRepository.getListTaskOrderByIndexStream(boardId);
  }

  void updateBoardPosition(String id, int index) {
    boardRepository.updateBoardPosition(id, index);
  }

  Stream<Project> getProjectStream(String projectId) {
    return projectRepository.getProjectStream(projectId);
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
    return participantRepository.getListProjectParticipantByProjectIdStream(projectId);
  }

  Stream<User> getInformationUserByIdStream(String uid) {
    return userRepository.getInformationUserByIdStream(uid);
  }

  void createTask({required String name, required String boardId, required String projectId, required int index}) {
    taskRepository.createTask(name: name, boardId: boardId, projectId: projectId, index: index);
  }

  void updateBoardName({required String id, required String name}) {
    boardRepository.updateBoardName(id: id, name: name);
  }

  void updateProjectName({required String projectId, required String name}) {
    projectRepository.updateName(projectId: projectId, name: name);
  }

  void updateProjectDescription({required String projectId, required String description}) {
    projectRepository.updateDescription(projectId: projectId, description: description);
  }

  void createBoard({required String projectId, required String name, required int index}) {
    boardRepository.createBoard(projectId: projectId, name: name, index: index);
  }
}
