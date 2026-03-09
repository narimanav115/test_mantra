import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/repository_entity.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'providers.dart';

class FavoritesNotifier extends Notifier<List<RepositoryEntity>> {
  late final GetFavorites _getFavorites;
  late final ToggleFavorite _toggleFavorite;

  @override
  List<RepositoryEntity> build() {
    _getFavorites = ref.read(getFavoritesUseCaseProvider);
    _toggleFavorite = ref.read(toggleFavoriteUseCaseProvider);
    return _getFavorites();
  }

  bool isFavorite(int repositoryId) =>
      state.any((repo) => repo.id == repositoryId);

  Future<void> toggleFavoriteRepo(RepositoryEntity repo) async {
    state = await _toggleFavorite(
      currentFavorites: state,
      repository: repo,
    );
  }
}
