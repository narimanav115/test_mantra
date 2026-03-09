import '../entities/repository_entity.dart';
import '../repositories/github_repository.dart';

class GetRepositoryDetail {
  final GitHubRepository _repository;

  GetRepositoryDetail(this._repository);

  Future<RepositoryEntity> call(String fullName) {
    return _repository.getRepositoryDetail(fullName);
  }
}
