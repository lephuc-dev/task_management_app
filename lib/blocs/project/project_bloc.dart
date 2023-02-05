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

  // Stream<QuerySnapshot<dynamic>> getListTaskCardByProjectidStream(
  //     String project_id) {
  //   return taskRepository.getListTaskCardByProjectidStream(project_id);
  // }

  // Stream<QuerySnapshot<dynamic>> getListListTaskByProjectTdStream(String projectId) {
  //   return groupTaskRepository.getListListTaskByProjectidStream(projectId);
  // }

  // Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
  //   return participantRepository.getListProjectParticipantByProjectIdStream(projectId);
  // }
  //
  // Future<void> AddNewListState(String projectId, String name, int index) {
  //   return groupTaskRepository.AddNewListState(projectId, name, index);
  // }
}