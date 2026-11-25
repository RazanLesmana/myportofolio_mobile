import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'HTTP $statusCode: $body';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();
  final http.Client _client;
  final String baseUrl;
  static const projects = '/api/v1/projects/';

  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      Uri.parse('$baseUrl$projects'),
      headers: {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
        .map((item) => Project.fromJson(item))
        .toList();
  }

  Future<http.Response> _post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: body == null ? null : jsonEncode(body),
    );
    _ensureSuccess(response);
    return response;
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _post(
      projects,
      body: project.toJson(),
      token: token,
    );
    if (response.statusCode != 201) {
      throw ApiException(response.statusCode, response.body);
    }
    return Project.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _post(
      '/api/v1/auth/token/',
      body: {'username': username, 'password': password},
    );
    return jsonDecode(response.body)['token'] as String;
  }

  Future<void> logout({required String token}) async {
    await _post('/api/v1/auth/logout/', token: token);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
