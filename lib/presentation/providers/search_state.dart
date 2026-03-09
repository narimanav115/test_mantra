import '../../domain/entities/repository_entity.dart';

class SearchState {
  final List<RepositoryEntity> repositories;
  final bool isLoading;
  final String? error;
  final String query;
  final int currentPage;
  final int totalCount;
  final bool hasMore;

  const SearchState({
    this.repositories = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
    this.currentPage = 0,
    this.totalCount = 0,
    this.hasMore = false,
  });

  SearchState copyWith({
    List<RepositoryEntity>? repositories,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? query,
    int? currentPage,
    int? totalCount,
    bool? hasMore,
  }) {
    return SearchState(
      repositories: repositories ?? this.repositories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
