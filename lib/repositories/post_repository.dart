import 'dart:convert';
import 'package:assignment_app/models/post_models.dart';
import 'package:http/http.dart' as http;

/// Handles API calls related to posts.
class PostRepository {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetch posts from the API.
  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode == 200) {
      // Parse JSON and convert to list of PostModel
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
