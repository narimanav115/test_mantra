import '../entities/repository_entity.dart';
import 'favorites_repository.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/mappers/repository_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  List<RepositoryEntity> getFavorites() {
    return _localDataSource.loadFavorites().map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> saveFavorites(List<RepositoryEntity> favorites) {
    return _localDataSource.saveFavorites(
      favorites.map((e) => e.toDto()).toList(),
    );
  }
}
