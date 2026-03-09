# GitHub Repository Search App

A Flutter application to search GitHub public repositories and manage a local favorites list, built with **Clean Architecture** and **Riverpod**.

## Build & Run

```bash
flutter pub get
flutter run
flutter test
```

> Requires Flutter 3.35.x or higher. Tested on Android 10+ and iOS 14+.

## Features

- **Search** — search GitHub repositories by keyword via the GitHub REST API
- **Infinite scroll** — automatically loads the next page when reaching the end of the list
- **Repository Detail** — displays `full_name`, `owner.avatar_url`, and `subscribers_count`
- **Favorites** — add/remove repositories from any screen; persisted in `shared_preferences`
- **Real-time sync** — star status is reflected immediately across all screens
- **Error handling** — error views with a Retry button on both search and detail screens

## Screens

| Screen | Description |
|--------|-------------|
| Search | Search box + list of results with avatar and full_name. Shows Home / Loading / Empty / Error states |
| Detail | Full repository info with star toggle |
| Favorites | List of starred repositories, persisted across app restarts |

## Architecture

The project follows **Clean Architecture** with three layers:

```
lib/
├── data/
│   ├── datasources/        # GitHubRemoteDataSource, FavoritesLocalDataSource
│   ├── mappers/            # RepositoryDto ↔ RepositoryEntity extensions
│   └── models/             # RepositoryDto (JSON serialization)
├── domain/
│   ├── entities/           # RepositoryEntity, SearchResult
│   ├── repositories/       # Abstract interfaces + implementations
│   └── usecases/           # SearchRepositories, GetRepositoryDetail, ToggleFavorite, GetFavorites
└── presentation/
    ├── providers/          # Riverpod providers, SearchNotifier, FavoritesNotifier, SearchState
    ├── screens/            # HomeScreen, SearchScreen, DetailScreen, FavoritesScreen
    └── widgets/            # RepositoryTile, SearchTextField, SearchResultList, state views
```

## Key Implementation Points

**Dependency injection via Riverpod**  
All dependencies — data sources, repositories, use cases, and notifiers — are wired through `providers.dart` using `Provider` and `NotifierProvider`. `SharedPreferences` is injected at startup via `ProviderScope(overrides: [...])`.

**Favorites persistence**  
Favorites are stored as a JSON array in `shared_preferences`. `FavoritesLocalDataSource` handles serialization; `FavoritesRepositoryImpl` maps between `RepositoryDto` and `RepositoryEntity`. State is loaded synchronously on app start inside `FavoritesNotifier.build()`.

**Real-time star sync**  
`RepositoryTile` and `DetailScreen` both use `favoritesProvider.select(...)` to watch only the boolean `isFavorite` for a specific repo id — avoiding full list rebuilds on every favorites change.

**Infinite scroll**  
`SearchNotifier` tracks `currentPage`, `totalCount`, and `hasMore`. `SearchScreen` listens to `ScrollController` and calls `loadNextPage()` when within 200px of the bottom.

**Error handling**  
Network errors surface as an error string in `SearchState.error` or via `AsyncValue.error` in the detail provider. Both provide a visible Retry button. In production, errors would be typed (e.g., `NetworkException`, `NotFoundException`) and logged via a crash reporting service.

**Clean Architecture boundary**  
`RepositoryDto` is a pure data class that never leaks into the domain layer. Mapping is done via extension methods (`toEntity()`, `toDto()`) in `data/mappers/`.

## Tests

```
test/
├── data/
│   ├── datasources/    FavoritesLocalDataSource (MockSharedPreferences)
│   ├── mappers/        RepositoryMapper extensions
│   └── models/         RepositoryDto fromJson/toJson round-trip
├── domain/
│   └── usecases/       ToggleFavorite, SearchRepositories
├── presentation/
│   ├── providers/      SearchNotifier — search, pagination, error states
│   ├── screens/        SearchScreen (home/loading/error/empty/results), FavoritesScreen
│   └── widgets/        RepositoryTile (star toggle, navigation)
├── helpers/
│   ├── fake_http_client.dart     # Returns 1×1 PNG — suppresses NetworkImage errors
│   └── fake_http_overrides.dart
└── mocks/
    ├── mock_github_repository.dart
    ├── mock_favorites_repository.dart
    ├── mock_shared_preferences.dart
    ├── stub_favorites_notifier.dart
    └── stub_search_notifier.dart
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `http` | GitHub REST API calls |
| `shared_preferences` | Local favorites persistence |
| `flutter_riverpod` | State management and dependency injection |
| `mocktail` *(dev)* | Mocking in tests |
