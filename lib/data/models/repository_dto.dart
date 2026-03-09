import '../../domain/entities/repository_entity.dart';

class RepositoryDto {
  final int id;
  final String fullName;
  final String ownerAvatarUrl;
  final int? subscribersCount;

  const RepositoryDto({
    required this.id,
    required this.fullName,
    required this.ownerAvatarUrl,
    this.subscribersCount,
  });

  factory RepositoryDto.fromJson(Map<String, dynamic> json) {
    return RepositoryDto(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      ownerAvatarUrl: json['owner']['avatar_url'] as String,
      subscribersCount: json['subscribers_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'owner': {'avatar_url': ownerAvatarUrl},
      if (subscribersCount != null) 'subscribers_count': subscribersCount,
    };
  }

  RepositoryEntity toEntity() {
    return RepositoryEntity(
      id: id,
      fullName: fullName,
      ownerAvatarUrl: ownerAvatarUrl,
      subscribersCount: subscribersCount,
    );
  }
}
