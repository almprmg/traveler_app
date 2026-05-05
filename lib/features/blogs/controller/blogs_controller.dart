import 'package:get/get.dart';
import 'package:traveler_app/features/blogs/model/blog_model.dart';
import 'package:traveler_app/features/blogs/service/blogs_service.dart';

class BlogsController extends GetxController {
  final BlogsService _service;
  BlogsController({required BlogsService service}) : _service = service;

  final blogs = <BlogListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      blogs.value = await _service.getBlogs(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void search(String q) {
    searchQuery.value = q;
    fetch();
  }
}

class BlogDetailController extends GetxController {
  final BlogsService _service;
  BlogDetailController({required BlogsService service}) : _service = service;

  final blog = Rxn<BlogDetail>();
  final comments = <BlogComment>[].obs;
  final isLoading = true.obs;
  final isPostingComment = false.obs;

  String get slug => Get.arguments?['slug'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      blog.value = await _service.getBlogDetail(slug);
      comments.value = await _service.getComments(slug);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitComment({
    required String comment,
    String? name,
    String? email,
  }) async {
    if (comment.trim().isEmpty) return false;
    isPostingComment.value = true;
    try {
      final created = await _service.postComment(
        slug: slug,
        comment: comment,
        name: name,
        email: email,
      );
      if (created != null) {
        comments.insert(0, created);
        return true;
      }
      return false;
    } finally {
      isPostingComment.value = false;
    }
  }
}
