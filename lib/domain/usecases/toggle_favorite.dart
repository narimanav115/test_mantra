import '../entities/repository_entity.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository _repository;

  ToggleFavorite(this._repository);

  Future<List<RepositoryEntity>> call({
    required List<RepositoryEntity> currentFavorites,
    required RepositoryEntity repository,
  }) async {
    final isFavorite = currentFavorites.any((r) => r.id == repository.id);
    final updated = isFavorite
        ? currentFavorites.where((r) => r.id != repository.id).toList()
        : [...currentFavorites, repository];
    await _repository.saveFavorites(updated);
    return updated;
  }
}
