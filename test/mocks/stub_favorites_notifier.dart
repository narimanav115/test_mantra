import 'package:test_mantra/domain/entities/repository_entity.dart';
import 'package:test_mantra/presentation/providers/favorites_notifier.dart';

class StubFavoritesNotifier extends FavoritesNotifier {
  final List<RepositoryEntity> initial;
  StubFavoritesNotifier([this.initial = const []]);

  @override
  List<RepositoryEntity> build() => initial;

  @override
  Future<void> toggleFavoriteRepo(RepositoryEntity repo) async {
    state = isFavorite(repo.id)
        ? state.where((r) => r.id != repo.id).toList()
        : [...state, repo];
  }
}

