import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';
import "package:test_mantra/domain/entities/search_result.dart" show SearchResult;
import 'package:test_mantra/domain/usecases/search_repositories.dart';
import 'package:test_mantra/presentation/providers/providers.dart';
import 'package:test_mantra/presentation/screens/search_screen.dart';
import 'package:test_mantra/presentation/widgets/repository_tile.dart';
import 'package:test_mantra/presentation/widgets/search_empty_view.dart';
import 'package:test_mantra/presentation/widgets/search_error_view.dart';
import 'package:test_mantra/presentation/widgets/search_home_view.dart';

import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';
import '../../mocks/stubs.dart';

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

  setUpAll(() => HttpOverrides.global = FakeHttpOverrides());
  tearDownAll(() => HttpOverrides.global = null);

  setUp(() => mockRepo = MockGitHubRepository());

  group('SearchScreen — home state', () {
    testWidgets('shows SearchHomeView when no query entered', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitHubRepositoryProvider.overrideWithValue(mockRepo),
            searchRepositoriesUseCaseProvider.overrideWith(
              (ref) => SearchRepositories(ref.watch(gitHubRepositoryProvider)),
            ),
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
          ],
          child: const MaterialApp(home: Scaffold(body: SearchScreen())),
        ),
      );

      expect(find.byType(SearchHomeView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('SearchScreen — loading state', () {
    testWidgets('shows CircularProgressIndicator while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitHubRepositoryProvider.overrideWithValue(mockRepo),
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
            searchProvider.overrideWith(
              () => StubSearchNotifier(const SearchState(
                query: 'flutter',
                isLoading: true,
              )),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: SearchScreen())),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('SearchScreen — error state', () {
    testWidgets('shows SearchErrorView on failure', (tester) async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(Exception('Network error'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitHubRepositoryProvider.overrideWithValue(mockRepo),
            searchRepositoriesUseCaseProvider.overrideWith(
              (ref) => SearchRepositories(ref.watch(gitHubRepositoryProvider)),
            ),
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
          ],
          child: const MaterialApp(home: Scaffold(body: SearchScreen())),
        ),
      );
      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.pump();

      expect(find.byType(SearchErrorView), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('SearchScreen — empty state', () {
    testWidgets('shows SearchEmptyView when results are empty', (tester) async {
      when(() => mockRepo.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => const SearchResult(
            repositories: [],
            totalCount: 0,
          ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitHubRepositoryProvider.overrideWithValue(mockRepo),
            searchRepositoriesUseCaseProvider.overrideWith(
              (ref) => SearchRepositories(ref.watch(gitHubRepositoryProvider)),
            ),
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
          ],
          child: const MaterialApp(home: Scaffold(body: SearchScreen())),
        ),
      );
      await tester.enterText(find.byType(TextField), 'xyznotfound');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.pump();

      expect(find.byType(SearchEmptyView), findsOneWidget);
    });
  });

  group('SearchScreen — results state', () {
    testWidgets('shows RepositoryTile list on success', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitHubRepositoryProvider.overrideWithValue(mockRepo),
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
            searchProvider.overrideWith(
              () => StubSearchNotifier(const SearchState(
                query: 'flutter',
                repositories: tRepositories,
                totalCount: 2,
                currentPage: 1,
              )),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: SearchScreen())),
        ),
      );
      await tester.pump();

      expect(find.byType(RepositoryTile), findsNWidgets(2));
      expect(find.text('flutter/flutter'), findsOneWidget);
      expect(find.text('dart-lang/sdk'), findsOneWidget);
    });
  });
}
