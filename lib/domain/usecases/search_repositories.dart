import '../repositories/github_repository.dart';

class SearchRepositories {
  final GitHubRepository _repository;

  SearchRepositories(this._repository);

  Future<SearchResult> call({
    required String query,
    int page = 1,
    int perPage = 30,
  }) {
    return _repository.searchRepositories(
      query: query,
      page: page,
      perPage: perPage,
    );
  }
}
