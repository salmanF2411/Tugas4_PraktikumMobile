import 'dart:convert';
import 'package:pertemuan4/Model/article_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _apiKey = 'ecefa7aabb9149ea8c2b5e4b9bad79ad';
  static const _baseUrl =
      'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$_apiKey';

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'];

        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to Load Articles');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
