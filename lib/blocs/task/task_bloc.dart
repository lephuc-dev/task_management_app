import '../../enum/ennum.dart';
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
  final NotificationRepository notificationRepository;

  TaskBloc(
    this.taskRepository,
    this.userRepository,
    this.taskParticipantRepository,
    this.projectParticipantRepository,
    this.commentRepository,
    this.authenticationRepository,
    this.notificationRepository,
  );

  Future<void> notification({required String taskId, required NotificationType type}) async {
    List<TaskParticipant> list = await taskParticipantRepository.getListTaskParticipantByTaskId(taskId);

    if (list.isNotEmpty) {
      for (var element in list) {
        if (element.userId != authenticationRepository.getCurrentUserId() &&
            element.userId != "" &&
            authenticationRepository.getCurrentUserId() != "") {
          notificationRepository.createNotification(
            projectId: "",
            userId: authenticationRepository.getCurrentUserId(),
            receiverId: element.userId ?? "",
            taskId: taskId,
            type: type,
          );
        }
      }
    }
  }

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
    notification(taskId: taskId, type: NotificationType.editTaskName);
  }

  void updateDescription(String taskId, String newDescription) {
    taskRepository.updateDescription(taskId, newDescription);
    notification(taskId: taskId, type: NotificationType.editTaskDescription);
  }

  Stream<List<ProjectParticipant>> getListProjectParticipantByProjectIdStream(String projectId) {
    return projectParticipantRepository.getListProjectParticipantByProjectIdStream(projectId);
  }

  void createTaskParticipant({required String userId, required String taskId}) {
    taskParticipantRepository.createTaskParticipant(userId: userId, taskId: taskId);
    notification(taskId: taskId, type: NotificationType.addTaskMember);
  }

  void deleteTaskParticipant({required String taskId, required String participantId}) {
    taskParticipantRepository.deleteTaskParticipant(participantId: participantId);
    notification(taskId: taskId, type: NotificationType.deleteTaskMember);
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
    notification(taskId: taskId, type: NotificationType.addTaskComment);
  }

  void deleteComment({required String commentId}) {
    commentRepository.deleteComment(commentId: commentId);
  }

  void updateFromAndToTime({required String taskId, required DateTime from, required DateTime to}) {
    taskRepository.updateFromAndToTime(taskId: taskId, from: from, to: to);
    notification(taskId: taskId, type: NotificationType.editTaskDeadline);
  }

  Stream<String> getRole({required String projectId}) {
    return projectParticipantRepository.getRole(userId: authenticationRepository.getCurrentUserId(), projectId: projectId);
  }

  void updateCompletedState({required String taskId, required bool value}) {
    taskRepository.updateCompletedState(taskId: taskId, value: value);
    notification(taskId: taskId, type: NotificationType.editTaskCompleted);
  }

  String getUid() {
    return authenticationRepository.getCurrentUserId();
  }

  void deleteTaskAndListParticipant({required String taskId}) {
    taskRepository.deleteTask(taskId: taskId);
    taskParticipantRepository.deleteListParticipant(taskId: taskId);
    notification(taskId: taskId, type: NotificationType.deleteTask);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
