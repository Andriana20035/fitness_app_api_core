import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions.dart';
import '../models/feed_response_model.dart';
import '../models/gym_details_model.dart';

abstract interface class FitnessRemoteDataSource {
  Future<FeedResponseModel> fetchFeed();

  Future<GymDetailsResponseModel> fetchGymDetails();
}

class FitnessRemoteDataSourceImpl implements FitnessRemoteDataSource {
  FitnessRemoteDataSourceImpl({
    http.Client? client,
    this.baseUrl = 'https://test-api-jlbn.onrender.com/lab2026/v3',
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  @override
  Future<FeedResponseModel> fetchFeed() async {
    final json = await _getJson('/feed');
    return _parse(() => FeedResponseModel.fromJson(json));
  }

  @override
  Future<GymDetailsResponseModel> fetchGymDetails() async {
    final json = await _getJson('/feed/details');
    return _parse(() => GymDetailsResponseModel.fromJson(json));
  }

  Future<Map<String, dynamic>> _getJson(String path) async {
    final http.Response response;
    try {
      response = await _client.get(
        Uri.parse('$baseUrl$path'),
        headers: const {'Accept': 'application/json'},
      ).timeout(timeout);
    } on TimeoutException {
      throw const NetworkException(
        'Serverul nu a răspuns la timp. Încearcă din nou.',
      );
    } on http.ClientException {
      throw const NetworkException(
        'Nu există conexiune la internet. Verifică rețeaua și încearcă din nou.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(
        'Serverul a răspuns cu codul ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const ParsingException('Răspunsul serverului are un format neașteptat.');
      }
      return decoded;
    } on FormatException {
      throw const ParsingException('Răspunsul serverului nu este JSON valid.');
    }
  }

  T _parse<T>(T Function() parse) {
    try {
      return parse();
    } on TypeError {
      throw const ParsingException('Structura datelor primite este invalidă.');
    }
  }

  void dispose() => _client.close();
}
