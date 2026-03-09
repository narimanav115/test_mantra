import 'dart:async';
import 'dart:io';

import 'package:mocktail/mocktail.dart';

/// Fake [HttpClient] that returns a 1x1 transparent PNG for every image
/// request — prevents NetworkImageLoadException in widget tests.
class FakeHttpClient extends Fake implements HttpClient {
  static const List<int> _transparentPng = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
    0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82,
  ];

  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async =>
      _FakeHttpClientRequest(_transparentPng);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeHttpClientRequest(_transparentPng);
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  final List<int> _body;
  _FakeHttpClientRequest(this._body);

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse(_body);

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  void add(List<int> data) {}

  @override
  void write(Object? object) {}
}

class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  final List<int> _body;
  _FakeHttpClientResponse(this._body);

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _body.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_body).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  List<String>? operator [](String name) => null;

  @override
  String? value(String name) => null;
}

