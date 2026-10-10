import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/drug_info.dart';

class DrugInfoService {
  final http.Client client;

  DrugInfoService(this.client);

  Future<http.Response> _get(Uri url) {
    return client.get(url).timeout(const Duration(seconds: 10));
  }

  Future<List<DrugInfo>> search(String name) async {
    final cleanName = name.replaceAll('"', '');
    final url = Uri.https('api.fda.gov', '/drug/label.json', {
      'search':
          'openfda.brand_name:"$cleanName"+openfda.generic_name:"$cleanName"',
      'limit': '10',
    });

    http.Response response;
    try {
      response = await _get(url);
      if (response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 2));
        response = await _get(url);
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on http.ClientException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('The request took too long. Please try again.');
    }

    if (response.statusCode == 200) {
      return _parseResults(response.body);
    }
    if (response.statusCode == 404) {
      return [];
    }
    if (response.statusCode == 429) {
      throw Exception('Too many requests. Please try again in a minute.');
    }
    throw Exception('Could not load drug info (code ${response.statusCode}).');
  }

  List<DrugInfo> _parseResults(String body) {
    final Map<String, dynamic> data = jsonDecode(body);
    final List<dynamic> results = data['results'];
    final List<DrugInfo> drugs = [];
    final List<String> seen = [];
    for (final result in results) {
      final info = DrugInfo.fromJson(result);
      final key =
          '${info.brandName.toLowerCase()}|${info.genericName.toLowerCase()}';
      if (!seen.contains(key)) {
        seen.add(key);
        drugs.add(info);
      }
    }
    return drugs;
  }
}
