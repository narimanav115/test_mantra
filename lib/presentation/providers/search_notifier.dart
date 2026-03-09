import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/search_repositories.dart';
import 'providers.dart';

class SearchNotifier extends Notifier<SearchState> {
  late final SearchRepositories _searchRepositories;
  static const _perPage = 30;

  @override
  SearchState build() {
    _searchRepositories = ref.read(searchRepositoriesUseCaseProvider);
    return const SearchState();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = SearchState(query: query, isLoading: true);

    try {
      final result = await _searchRepositories(
        query: query,
        page: 1,
        perPage: _perPage,
      );
      state = SearchState(
        query: query,
        repositories: result.repositories,
        currentPage: 1,
        totalCount: result.totalCount,
        hasMore: result.repositories.length < result.totalCount,
      );
    } catch (e) {
      state = SearchState(query: query, error: e.toString());
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _searchRepositories(
        query: state.query,
        page: nextPage,
        perPage: _perPage,
      );

      final allRepos = [...state.repositories, ...result.repositories];
      state = state.copyWith(
        repositories: allRepos,
        currentPage: nextPage,
        totalCount: result.totalCount,
        hasMore: allRepos.length < result.totalCount,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
