import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'phillips_hue_base.dart';

class ApiClient {
  final Client _client = new Client();
  final String hostname;
  final String username;

  ApiClient(this.hostname, this.username);

  Future<Light> getState(int bulbId) async {
    final Uri url = Uri.parse('http://$hostname/api/$username/lights/$bulbId');

    final String s = await _client.get(url);

    return new Light.fromJson(JSON.decode(s));
  }

  Stream<Light> getStates() async* {
    final Uri url = Uri.parse('http://$hostname/api/$username/lights');

    final String s = await _client.get(url);
    final Map<String, dynamic> lightsMap = JSON.decode(s);

    for (String key in lightsMap.keys) {
      yield new Light.fromJson(lightsMap[key], id: int.parse(key));
    }
  }

  Future<Null> turnOn(int bulb) async {
    final Uri url =
        Uri.parse('http://' + hostname + '/api/$username/lights/$bulb/state');

    await _client.put(url, '{"on":true}');
  }

  Future<Null> turnOff(int bulb) async {
    final Uri url =
        Uri.parse('http://' + hostname + '/api/$username/lights/$bulb/state');

    await _client.put(url, '{"on":false}');
  }
}

Future<String> _extractContent(Stream<List<int>> request) {
  Completer<String> completer = new Completer<String>();
  List<int> completeRawContent = new List<int>();

  request.listen(completeRawContent.addAll,
      onError: (dynamic error) => completer.completeError(error), onDone: () {
    try {
      String content = ASCII.decode(completeRawContent);
      completer.complete(content);
    } catch (error) {
      completer.completeError(error);
    }
  }, cancelOnError: true);

  return completer.future;
}

/// HTTP Client for use with dart:io.
class Client {
  static final ContentType _contentTypeJson =
      new ContentType("application", "json", charset: "utf-8");

  final HttpClient client = new HttpClient();

  /// Retrives [resource] using HTTP GET.
  Future<String> get(Uri resource) async {
    HttpClientRequest request = await client.getUrl(resource);
    HttpClientResponse response = await request.close();

    return await _handleResponse(response, 'GET', resource);
  }

  /// Retrives [resource] using HTTP PUT, sending [payload].
  ///
  /// Throws subclasses of [StorageException] upon failure.
  Future<String> put(Uri resource, String payload) async {
    final HttpClientRequest request = await client.putUrl(resource)
      ..headers.contentType = _contentTypeJson
      ..write(payload);
    print(resource);
    print(payload);
    HttpClientResponse response = await request.close();

    return await _handleResponse(response, 'PUT', resource);
  }

  /// Retrives [resource] using HTTP POST, sending [payload].
  ///
  /// Throws subclasses of [StorageException] upon failure.
  Future<String> post(Uri resource, String payload) async {
    HttpClientRequest request = await client.postUrl(resource)
      ..headers.contentType = _contentTypeJson
      ..write(payload);
    HttpClientResponse response = await request.close();

    return await _handleResponse(response, 'POST', resource);
  }

  /// Retrives [resource] using HTTP DELETE.
  ///
  /// Throws subclasses of [StorageException] upon failure.
  Future<String> delete(Uri resource) async {
    HttpClientRequest request = await client.deleteUrl(resource);
    HttpClientResponse response = await request.close();

    return await _handleResponse(response, 'DELETE', resource);
  }
}

Future<String> _handleResponse(
    HttpClientResponse response, String method, Uri resource) async {
  final String body = await _extractContent(response);

  return body;
}
