import '../entities/repository_entity.dart';
import 'github_repository.dart';
import '../../data/datasources/github_remote_data_source.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource _remoteDataSource;

  GitHubRepositoryImpl(this._remoteDataSource);

  @override
  Future<SearchResult> searchRepositories({
    required String query,
    int page = 1,
    int perPage = 30,
  }) async {
    final result = await _remoteDataSource.searchRepositories(
      query: query,
      page: page,
      perPage: perPage,
    );
    return SearchResult(
      repositories: result.items.map((dto) => dto.toEntity()).toList(),
      totalCount: result.totalCount,
    );
  }

  @override
  Future<RepositoryEntity> getRepositoryDetail(String fullName) async {
    final dto = await _remoteDataSource.getRepositoryDetail(fullName);
    return dto.toEntity();
  }
}
