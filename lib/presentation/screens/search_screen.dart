import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/search_empty_view.dart';
import '../widgets/search_error_view.dart';
import '../widgets/search_home_view.dart';
import '../widgets/search_result_list.dart';
import '../widgets/search_text_field.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Column(
      children: [
        SearchTextField(
          controller: _controller,
          onSubmitted: (value) =>
              ref.read(searchProvider.notifier).search(value),
          onClear: () {
            _controller.clear();
            ref.read(searchProvider.notifier).search('');
          },
        ),
        Expanded(child: _buildBody(searchState)),
      ],
    );
  }

  Widget _buildBody(SearchState searchState) {
    if (searchState.query.isEmpty) return const SearchHomeView();

    if (searchState.isLoading && searchState.repositories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null && searchState.repositories.isEmpty) {
      return SearchErrorView(
        onRetry: () =>
            ref.read(searchProvider.notifier).search(searchState.query),
      );
    }

    if (searchState.repositories.isEmpty) return const SearchEmptyView();

    return SearchResultList(
      repositories: searchState.repositories,
      hasMore: searchState.hasMore,
      scrollController: _scrollController,
    );
  }
}
