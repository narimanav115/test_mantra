import 'package:flutter/material.dart';

import '../../domain/entities/repository_entity.dart';
import 'repository_tile.dart';

class SearchResultList extends StatelessWidget {
  final List<RepositoryEntity> repositories;
  final bool hasMore;
  final ScrollController scrollController;

  const SearchResultList({
    super.key,
    required this.repositories,
    required this.hasMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: repositories.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == repositories.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return RepositoryTile(repository: repositories[index]);
      },
    );
  }
}
