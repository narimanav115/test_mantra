import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';
import 'package:test_mantra/domain/entities/search_result.dart';
import 'package:test_mantra/domain/usecases/search_repositories.dart';
import 'package:test_mantra/presentation/providers/providers.dart';

import '../../mocks/mocks.dart';

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

void main() {
  late MockGitHubRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockGitHubRepository();
    container = ProviderContainer(
      overrides: [
        gitHubRepositoryProvider.overrideWithValue(mockRepo),
        searchRepositoriesUseCaseProvider.overrideWith(
          (ref) => SearchRepositories(ref.watch(gitHubRepositoryProvider)),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('SearchNotifier.search', () {
    test('emits initial empty state', () {
      final state = container.read(searchProvider);
      expect(state, isA<SearchState>());
      expect(state.repositories, isEmpty);
      expect(state.query, '');
      expect(state.isLoading, isFalse);
    });

    test('clears state when query is blank', () async {
      await container.read(searchProvider.notifier).search('');
      final state = container.read(searchProvider);
      expect(state.repositories, isEmpty);
      expect(state.query, '');
    });

    test('sets loading state then populates results on success', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => const SearchResult(
            repositories: tRepositories,
            totalCount: 50,
          ));

      final states = <SearchState>[];
      final sub = container.listen(searchProvider, (_, next) => states.add(next));

      await container.read(searchProvider.notifier).search('flutter');

      sub.close();

      expect(states.first.isLoading, isTrue);
      expect(states.last.repositories, tRepositories);
      expect(states.last.totalCount, 50);
      expect(states.last.isLoading, isFalse);
      expect(states.last.hasMore, isTrue);
    });

    test('sets error state on failure', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(Exception('Network error'));

      await container.read(searchProvider.notifier).search('flutter');
      final state = container.read(searchProvider);

      expect(state.error, isNotNull);
      expect(state.repositories, isEmpty);
      expect(state.isLoading, isFalse);
    });
  });

  group('SearchNotifier.loadNextPage (pagination)', () {
    test('appends next page results to existing list', () async {
      var callCount = 0;
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async {
        callCount++;
        return SearchResult(
          repositories: callCount == 1
              ? [tRepositories[0]]
              : [tRepositories[1]],
          totalCount: 2,
        );
      });

      final notifier = container.read(searchProvider.notifier);
      await notifier.search('flutter');
      await notifier.loadNextPage();

      final state = container.read(searchProvider);
      expect(state.repositories.length, 2);
      expect(state.currentPage, 2);
      expect(state.hasMore, isFalse);
    });

    test('does nothing when hasMore is false', () async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => const SearchResult(
            repositories: tRepositories,
            totalCount: 2, // == results.length → hasMore: false
          ));

      final notifier = container.read(searchProvider.notifier);
      await notifier.search('flutter');
      await notifier.loadNextPage();

      verify(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).called(1); // only the initial search call
    });
  });
}
