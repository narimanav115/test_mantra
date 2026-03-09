import 'package:flutter_test/flutter_test.dart';
import 'package:test_mantra/data/mappers/repository_mapper.dart';
import 'package:test_mantra/data/models/repository_dto.dart';
import 'package:test_mantra/domain/entities/repository_entity.dart';

void main() {
  group('RepositoryEntityMapper (toDto)', () {
    const entity = RepositoryEntity(
      id: 5,
      fullName: 'owner/repo',
      ownerAvatarUrl: 'https://example.com/5.png',
      subscribersCount: 10,
    );

    test('converts entity to dto with all fields', () {
      final dto = entity.toDto();

      expect(dto.id, entity.id);
      expect(dto.fullName, entity.fullName);
      expect(dto.ownerAvatarUrl, entity.ownerAvatarUrl);
      expect(dto.subscribersCount, entity.subscribersCount);
    });

    test('converts entity without subscribersCount', () {
      const e = RepositoryEntity(
        id: 1,
        fullName: 'a/b',
        ownerAvatarUrl: 'https://x.com/a.png',
      );
      final dto = e.toDto();
      expect(dto.subscribersCount, isNull);
    });
  });

  group('RepositoryDtoMapper (toEntity)', () {
    test('converts dto to entity with all fields', () {
      const dto = RepositoryDto(
        id: 7,
        fullName: 'user/proj',
        ownerAvatarUrl: 'https://example.com/7.png',
        subscribersCount: 99,
      );
      final entity = dto.toEntity();

      expect(entity.id, dto.id);
      expect(entity.fullName, dto.fullName);
      expect(entity.ownerAvatarUrl, dto.ownerAvatarUrl);
      expect(entity.subscribersCount, dto.subscribersCount);
    });
  });
}

