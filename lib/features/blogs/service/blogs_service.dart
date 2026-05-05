import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/blogs/model/blog_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class BlogsService extends GetxService {
  final ApiClient apiClient;
  BlogsService({required this.apiClient});

  Future<List<BlogListItem>> getBlogs({
    String? query,
    String? category,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (category != null) params['category'] = category;

    final uri = Uri.parse(AppConstants.blogsUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final list = data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(BlogListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<BlogDetail?> getBlogDetail(String slug) async {
    final response = await apiClient.getData(AppConstants.blogDetailUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return BlogDetail.fromJson(body['data'] ?? body);
    }
    return null;
  }

  Future<List<BlogComment>> getComments(String slug) async {
    final response =
        await apiClient.getData(AppConstants.blogCommentsUrl(slug));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final raw = body['data'];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(BlogComment.fromJson)
            .toList();
      }
    }
    return [];
  }

  Future<BlogComment?> postComment({
    required String slug,
    required String comment,
    String? name,
    String? email,
    String? parentId,
  }) async {
    final body = <String, dynamic>{'comment': comment};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (parentId != null) body['parent_id'] = parentId;

    final response = await apiClient.postData(
      AppConstants.blogCommentsUrl(slug),
      body,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json0 = json.decode(response.body);
      return BlogComment.fromJson(json0['data'] ?? json0);
    }
    return null;
  }
}
