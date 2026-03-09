import '../entities/repository_entity.dart';
import '../entities/search_result.dart';

export '../entities/search_result.dart';

abstract class GitHubRepository {
  Future<SearchResult> searchRepositories({
    required String query,
    int page = 1,
    int perPage = 30,
  });

  Future<RepositoryEntity> getRepositoryDetail(String fullName);
}
