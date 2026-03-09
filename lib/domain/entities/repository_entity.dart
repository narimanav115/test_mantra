class RepositoryEntity {
  final int id;
  final String fullName;
  final String ownerAvatarUrl;
  final int? subscribersCount;

  const RepositoryEntity({
    required this.id,
    required this.fullName,
    required this.ownerAvatarUrl,
    this.subscribersCount,
  });
}
