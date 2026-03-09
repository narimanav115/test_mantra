import 'package:flutter_test/flutter_test.dart';
import 'package:test_mantra/data/models/repository_dto.dart';

void main() {
  group('RepositoryDto', () {
    const tJson = {
      'id': 123,
      'full_name': 'octocat/Hello-World',
      'owner': {'avatar_url': 'https://example.com/avatar.png'},
      'subscribers_count': 42,
    };

    test('fromJson parses all fields correctly', () {
      final dto = RepositoryDto.fromJson(tJson);

      expect(dto.id, 123);
      expect(dto.fullName, 'octocat/Hello-World');
      expect(dto.ownerAvatarUrl, 'https://example.com/avatar.png');
      expect(dto.subscribersCount, 42);
    });

    test('fromJson → toJson round-trip preserves data', () {
      final dto = RepositoryDto.fromJson(tJson);
      final decoded = RepositoryDto.fromJson(dto.toJson());

      expect(decoded.id, dto.id);
      expect(decoded.fullName, dto.fullName);
      expect(decoded.ownerAvatarUrl, dto.ownerAvatarUrl);
      expect(decoded.subscribersCount, dto.subscribersCount);
    });

    test('toJson excludes subscribers_count when null', () {
      const dto = RepositoryDto(
        id: 1,
        fullName: 'test/repo',
        ownerAvatarUrl: 'https://example.com/a.png',
      );

      expect(dto.toJson().containsKey('subscribers_count'), isFalse);
    });

    test('toEntity maps all fields correctly', () {
      final dto = RepositoryDto.fromJson(tJson);
      final entity = dto.toEntity();

      expect(entity.id, dto.id);
      expect(entity.fullName, dto.fullName);
      expect(entity.ownerAvatarUrl, dto.ownerAvatarUrl);
      expect(entity.subscribersCount, dto.subscribersCount);
    });
  });
}

