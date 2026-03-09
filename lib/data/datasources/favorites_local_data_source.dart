import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/repository_dto.dart';

class FavoritesLocalDataSource {
  static const _key = 'favorite_repositories';

  final SharedPreferences _prefs;

  FavoritesLocalDataSource(this._prefs);

  List<RepositoryDto> loadFavorites() {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return [];
    final list = jsonDecode(jsonString) as List;
    return list
        .map((item) => RepositoryDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorites(List<RepositoryDto> favorites) async {
    final jsonString = jsonEncode(favorites.map((r) => r.toJson()).toList());
    await _prefs.setString(_key, jsonString);
  }
}
