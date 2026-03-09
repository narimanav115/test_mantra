import '../../domain/entities/repository_entity.dart';
import '../models/repository_dto.dart';

extension RepositoryEntityMapper on RepositoryEntity {
  RepositoryDto toDto() {
    return RepositoryDto(
      id: id,
      fullName: fullName,
      ownerAvatarUrl: ownerAvatarUrl,
      subscribersCount: subscribersCount,
    );
  }
}

extension RepositoryDtoMapper on RepositoryDto {
  RepositoryEntity toEntity() {
    return RepositoryEntity(
      id: id,
      fullName: fullName,
      ownerAvatarUrl: ownerAvatarUrl,
      subscribersCount: subscribersCount,
    );
  }
}
