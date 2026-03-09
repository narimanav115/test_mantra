import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/repository_dto.dart';

class GitHubRemoteDataSource {
  final http.Client _client;

  GitHubRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  static const _baseUrl = 'https://api.github.com';
  static const _headers = {'Accept': 'application/vnd.github+json'};

  Future<({List<RepositoryDto> items, int totalCount})> searchRepositories({
    required String query,
    int page = 1,
    int perPage = 30,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/search/repositories'
      '?q=${Uri.encodeComponent(query)}&page=$page&per_page=$perPage',
    );

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to search repositories: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (json['items'] as List)
        .map((item) => RepositoryDto.fromJson(item as Map<String, dynamic>))
        .toList();

    return (items: items, totalCount: json['total_count'] as int);
  }

  Future<RepositoryDto> getRepositoryDetail(String fullName) async {
    final uri = Uri.parse('$_baseUrl/repos/$fullName');

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to get repository: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return RepositoryDto.fromJson(json);
  }
}
