import '../entities/repository_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository _repository;

  GetFavorites(this._repository);

  List<RepositoryEntity> call() {
    return _repository.getFavorites();
  }
}
