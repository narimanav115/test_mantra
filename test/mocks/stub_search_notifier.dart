import 'package:test_mantra/presentation/providers/search_notifier.dart';
import 'package:test_mantra/presentation/providers/search_state.dart';

class StubSearchNotifier extends SearchNotifier {
  final SearchState initial;
  StubSearchNotifier(this.initial);

  @override
  SearchState build() => initial;
}

