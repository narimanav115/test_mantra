import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/datasources/github_remote_data_source.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/github_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/github_repository.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/get_repository_detail.dart';
import '../../domain/usecases/search_repositories.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'favorites_notifier.dart';
import 'search_notifier.dart';
import 'search_state.dart';

export 'favorites_notifier.dart';
export 'search_notifier.dart';
export 'search_state.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

final gitHubRemoteDataSourceProvider = Provider<GitHubRemoteDataSource>((ref) {
  return GitHubRemoteDataSource();
});

final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>((ref) {
  return FavoritesLocalDataSource(ref.watch(sharedPreferencesProvider));
});

final gitHubRepositoryProvider = Provider<GitHubRepository>((ref) {
  return GitHubRepositoryImpl(ref.watch(gitHubRemoteDataSourceProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider));
});

final searchRepositoriesUseCaseProvider = Provider<SearchRepositories>((ref) {
  return SearchRepositories(ref.watch(gitHubRepositoryProvider));
});

final getRepositoryDetailUseCaseProvider =
    Provider<GetRepositoryDetail>((ref) {
  return GetRepositoryDetail(ref.watch(gitHubRepositoryProvider));
});

final getFavoritesUseCaseProvider = Provider<GetFavorites>((ref) {
  return GetFavorites(ref.watch(favoritesRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavorite>((ref) {
  return ToggleFavorite(ref.watch(favoritesRepositoryProvider));
});

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<RepositoryEntity>>(
  FavoritesNotifier.new,
);

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

final repositoryDetailProvider =
    FutureProvider.family<RepositoryEntity, String>((ref, fullName) async {
  final getDetail = ref.watch(getRepositoryDetailUseCaseProvider);
  return getDetail(fullName);
});
