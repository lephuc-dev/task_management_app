import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../base/base.dart';
import '../blocs.dart';

class TaskBloc extends BaseBloc<TaskState> {
  final TaskRepository taskRepository;
  final TaskParticipantRepository taskParticipantRepository;
  final ProjectParticipantRepository projectParticipantRepository;
  final UserRepository userRepository;
  final CommentRepository commentRepository;
  final AuthenticationRepository authenticationRepository;

  TaskBloc(
    this.taskRepository,
    this.userRepository,
    this.taskParticipantRepository,
    this.projectParticipantRepository,
    this.commentRepository,
    this.authenticationRepository,
  );

  Stream<List<CommentModel>> getListCommentByTaskId(String taskId) {
    return commentRepository.getListCommentByTaskId(taskId);
  }

  Stream<TaskModel> getTaskStream(String taskId) {
    return taskRepository.getTaskStream(taskId);
  }

  Stream<List<TaskParticipant>> getListTaskParticipantByTaskIdStream(String taskId) {
    return taskParticipantRepository.getListTaskParticipantByTaskIdStream(taskId);
  }

  Stream<User> getInformationUserByIdStream(String uid) {
    return userRepository.getInformationUserByIdStream(uid);
  }

  void updateName(String taskId, String newName) {
    taskRepository.updateName(taskId, newName);
  }

  void updateDescription(String taskId, String newDescription) {
    taskRepository.updateDescription(taskId, newDescription);
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
    return projectParticipantRepository.getListProjectParticipantByProjectIdStream(projectId);
  }

  void createTaskParticipant({required String userId, required String taskId}) {
    taskParticipantRepository.createTaskParticipant(userId: userId, taskId: taskId);
  }

  void deleteTaskParticipant({required String participantId}) {
    taskParticipantRepository.deleteTaskParticipant(participantId: participantId);
  }

  void setDoneTaskState({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
    required bool isDone,
  }) {
    taskRepository.setDoneTaskState(
      taskId: taskId,
      checklist: checklist,
      index: index,
      isDone: isDone,
    );
  }

  void updateCheckListItemContent({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
    required String content,
  }) {
    taskRepository.updateCheckListItemContent(
      taskId: taskId,
      checklist: checklist,
      index: index,
      content: content,
    );
  }

  void deleteCheckListItem({
    required String taskId,
    required List<CheckListItemModel>? checklist,
    required int index,
  }) {
    taskRepository.deleteCheckListItem(
      taskId: taskId,
      checklist: checklist,
      index: index,
    );
  }

  void addCheckListItem({
    required String taskId,
    required List<CheckListItemModel>? checklist,
  }) {
    taskRepository.addCheckListItem(
      taskId: taskId,
      checklist: checklist,
    );
  }

  void deleteLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required int index,
  }) {
    taskRepository.deleteLinkListItem(
      taskId: taskId,
      list: list,
      index: index,
    );
  }

  void addLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required String title,
    required String url,
  }) {
    taskRepository.addLinkListItem(
      taskId: taskId,
      list: list,
      title: title,
      url: url,
    );
  }

  void updateLinkListItem({
    required String taskId,
    required List<LinkModel>? list,
    required int index,
    required String title,
    required String url,
  }) {
    taskRepository.updateLinkListItem(
      taskId: taskId,
      list: list,
      index: index,
      title: title,
      url: url,
    );
  }

  void createComment({required String taskId, required String content}) {
    commentRepository.createComment(authenticationRepository.getCurrentUserId(), taskId, content);
  }

  void deleteComment({required String commentId}) {
    commentRepository.deleteComment(commentId: commentId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
