import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';
import 'package:test_mantra/domain/usecases/toggle_favorite.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockFavoritesRepository mockRepo;
  late ToggleFavorite useCase;

  const tRepo = RepositoryEntity(
    id: 1,
    fullName: 'user/repo',
    ownerAvatarUrl: 'https://example.com/1.png',
  );

  const tRepo2 = RepositoryEntity(
    id: 2,
    fullName: 'user/repo2',
    ownerAvatarUrl: 'https://example.com/2.png',
  );

  setUp(() {
    mockRepo = MockFavoritesRepository();
    useCase = ToggleFavorite(mockRepo);
    when(() => mockRepo.saveFavorites(any())).thenAnswer((_) async {});
  });

  group('ToggleFavorite', () {
    test('adds repo when not in favorites', () async {
      final result = await useCase(
        currentFavorites: const [],
        repository: tRepo,
      );

      expect(result, [tRepo]);
      verify(() => mockRepo.saveFavorites([tRepo])).called(1);
    });

    test('removes repo when already in favorites', () async {
      final result = await useCase(
        currentFavorites: const [tRepo, tRepo2],
        repository: tRepo,
      );

      expect(result, [tRepo2]);
      verify(() => mockRepo.saveFavorites([tRepo2])).called(1);
    });

    test('keeps other repos when removing one', () async {
      final result = await useCase(
        currentFavorites: const [tRepo, tRepo2],
        repository: tRepo2,
      );

      expect(result, [tRepo]);
    });

    test('adds to existing favorites list', () async {
      final result = await useCase(
        currentFavorites: const [tRepo],
        repository: tRepo2,
      );

      expect(result.length, 2);
      expect(result, containsAll([tRepo, tRepo2]));
    });
  });
}
