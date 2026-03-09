import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';
import 'package:test_mantra/domain/entities/search_result.dart';
import 'package:test_mantra/domain/usecases/search_repositories.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockGitHubRepository mockRepo;
  late SearchRepositories useCase;

  const tRepositories = [
    RepositoryEntity(
      id: 1,
      fullName: 'flutter/flutter',
      ownerAvatarUrl: 'https://example.com/1.png',
    ),
    RepositoryEntity(
      id: 2,
      fullName: 'dart-lang/sdk',
      ownerAvatarUrl: 'https://example.com/2.png',
    ),
  ];

  final tSearchResult = SearchResult(
    repositories: tRepositories,
    totalCount: 100,
  );

  setUp(() {
    mockRepo = MockGitHubRepository();
    useCase = SearchRepositories(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(const SearchResult(repositories: [], totalCount: 0));
  });

  group('SearchRepositories', () {
    test('returns SearchResult from repository', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => tSearchResult);

      final result = await useCase(query: 'flutter', page: 1, perPage: 30);

      expect(result.repositories, tRepositories);
      expect(result.totalCount, 100);
    });

    test('passes correct params to repository', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => tSearchResult);

      await useCase(query: 'dart', page: 2, perPage: 10);

      verify(() => mockRepo.searchRepositories(
            query: 'dart',
            page: 2,
            perPage: 10,
          )).called(1);
    });

    test('throws when repository throws', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(Exception('Network error'));

      expect(
        () => useCase(query: 'flutter'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
