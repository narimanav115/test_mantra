import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_mantra/data/datasources/favorites_local_data_source.dart';
import 'package:test_mantra/data/models/repository_dto.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late FavoritesLocalDataSource dataSource;

  const tDtos = [
    RepositoryDto(
      id: 1,
      fullName: 'user/repo1',
      ownerAvatarUrl: 'https://example.com/1.png',
      subscribersCount: 5,
    ),
    RepositoryDto(
      id: 2,
      fullName: 'user/repo2',
      ownerAvatarUrl: 'https://example.com/2.png',
    ),
  ];

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = FavoritesLocalDataSource(mockPrefs);
  });

  group('FavoritesLocalDataSource.loadFavorites', () {
    test('returns empty list when nothing stored', () {
      when(() => mockPrefs.getString(any())).thenReturn(null);

      expect(dataSource.loadFavorites(), isEmpty);
    });

    test('deserializes stored favorites correctly', () {
      final json = jsonEncode(tDtos.map((d) => d.toJson()).toList());
      when(() => mockPrefs.getString(any())).thenReturn(json);

      final result = dataSource.loadFavorites();

      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].fullName, 'user/repo1');
      expect(result[1].id, 2);
      expect(result[1].subscribersCount, isNull);
    });
  });

  group('FavoritesLocalDataSource.saveFavorites', () {
    test('serializes and saves favorites to prefs', () async {
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.saveFavorites(tDtos);

      final captured =
          verify(() => mockPrefs.setString(any(), captureAny())).captured;
      final decoded = jsonDecode(captured.first as String) as List;
      expect(decoded.length, 2);
      expect(decoded[0]['id'], 1);
      expect(decoded[1]['id'], 2);
    });

    test('saves empty list correctly', () async {
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.saveFavorites([]);

      final captured =
          verify(() => mockPrefs.setString(any(), captureAny())).captured;
      final decoded = jsonDecode(captured.first as String) as List;
      expect(decoded, isEmpty);
    });
  });
}
