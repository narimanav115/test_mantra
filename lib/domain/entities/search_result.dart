import 'repository_entity.dart';

class SearchResult {
  final List<RepositoryEntity> repositories;
  final int totalCount;

  const SearchResult({
    required this.repositories,
    required this.totalCount,
  });
}

