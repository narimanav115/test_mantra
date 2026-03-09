import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';
import 'package:test_mantra/presentation/providers/providers.dart';
import 'package:test_mantra/presentation/screens/favorites_screen.dart';
import 'package:test_mantra/presentation/widgets/repository_tile.dart';

import '../../helpers/test_helpers.dart';
import '../../mocks/stubs.dart';

const tFavorites = [
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
  setUpAll(() => HttpOverrides.global = FakeHttpOverrides());
  tearDownAll(() => HttpOverrides.global = null);

  group('FavoritesScreen — empty state', () {
    testWidgets('shows empty placeholder when no favorites', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            favoritesProvider.overrideWith(() => StubFavoritesNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: FavoritesScreen()),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_border), findsOneWidget);
      expect(find.text('No favorites yet'), findsOneWidget);
      expect(find.byType(RepositoryTile), findsNothing);
    });
  });

  group('FavoritesScreen — populated state', () {
    testWidgets('shows RepositoryTile for each favorite', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            favoritesProvider.overrideWith(
              () => StubFavoritesNotifier(tFavorites),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: FavoritesScreen()),
          ),
        ),
      );

      expect(find.byType(RepositoryTile), findsNWidgets(2));
      expect(find.text('flutter/flutter'), findsOneWidget);
      expect(find.text('dart-lang/sdk'), findsOneWidget);
    });

    testWidgets('shows star icon for each favorited repo', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            favoritesProvider.overrideWith(
              () => StubFavoritesNotifier(tFavorites),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: FavoritesScreen()),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(2));
    });
  });
}
