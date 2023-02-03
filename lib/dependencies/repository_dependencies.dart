import '../repositories/repositories.dart';
import 'package:get_it/get_it.dart';

class RepositoryDependencies {
  static Future setup(GetIt injector) async {
    injector.registerFactory<AuthenticationRepository>(() => AuthenticationRepository());
    injector.registerFactory<UserRepository>(() => UserRepository());
    injector.registerFactory<ProjectParticipantRepository>(() => ProjectParticipantRepository());
    injector.registerFactory<ProjectRepository>(() => ProjectRepository());
    injector.registerFactory<BoardRepository>(() => BoardRepository());
    injector.registerFactory<TaskRepository>(() => TaskRepository());
    injector.registerFactory<TaskParticipantRepository>(() => TaskParticipantRepository());
  }
}
