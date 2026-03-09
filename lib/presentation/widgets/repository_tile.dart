import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/repository_entity.dart';
import '../providers/providers.dart';
import '../screens/detail_screen.dart';

class RepositoryTile extends ConsumerWidget {
  final RepositoryEntity repository;

  const RepositoryTile({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoritesProvider.select(
        (list) => list.any((r) => r.id == repository.id),
      ),
    );

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(repository.ownerAvatarUrl),
      ),
      title: Text(
        repository.fullName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.amber : null,
        ),
        onPressed: () => ref
            .read(favoritesProvider.notifier)
            .toggleFavoriteRepo(repository),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailScreen(fullName: repository.fullName),
          ),
        );
      },
    );
  }
}
