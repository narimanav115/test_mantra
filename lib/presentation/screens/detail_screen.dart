import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class DetailScreen extends ConsumerWidget {
  final String fullName;

  const DetailScreen({super.key, required this.fullName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(repositoryDetailProvider(fullName));

    return Scaffold(
      appBar: AppBar(
        title: Text(fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load details',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(repositoryDetailProvider(fullName)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (repository) {
          final isFavorite = ref.watch(
            favoritesProvider.select(
              (list) => list.any((r) => r.id == repository.id),
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(repository.ownerAvatarUrl),
                ),
                const SizedBox(height: 16),
                Text(
                  repository.fullName,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${repository.subscribersCount ?? 0} watchers',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                IconButton(
                  iconSize: 48,
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => ref
                      .read(favoritesProvider.notifier)
                      .toggleFavoriteRepo(repository),
                ),
                Text(
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
