import '../entities/repository_entity.dart';

abstract class FavoritesRepository {
  List<RepositoryEntity> getFavorites();
  Future<void> saveFavorites(List<RepositoryEntity> favorites);
}
