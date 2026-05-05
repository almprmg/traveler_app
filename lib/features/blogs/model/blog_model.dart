class BlogListItem {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final String imageUrl;
  final String? category;
  final String? author;
  final String? publishedAt;

  BlogListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.imageUrl,
    this.excerpt,
    this.category,
    this.author,
    this.publishedAt,
  });

  factory BlogListItem.fromJson(Map<String, dynamic> json) {
    return BlogListItem(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      excerpt: json['excerpt']?.toString(),
      category: json['category']?.toString(),
      author: json['author']?.toString(),
      publishedAt: json['published_at']?.toString(),
    );
  }
}

class BlogDetail {
  final String id;
  final String slug;
  final String title;
  final String content;
  final String? excerpt;
  final String imageUrl;
  final String? category;
  final String? author;
  final List<String> tags;
  final String? publishedAt;

  BlogDetail({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.tags,
    this.excerpt,
    this.category,
    this.author,
    this.publishedAt,
  });

  factory BlogDetail.fromJson(Map<String, dynamic> json) {
    return BlogDetail(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      excerpt: json['excerpt']?.toString(),
      category: json['category']?.toString(),
      author: json['author']?.toString(),
      tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
      publishedAt: json['published_at']?.toString(),
    );
  }
}

class BlogComment {
  final String id;
  final String name;
  final String comment;
  final String createdAt;
  final List<BlogComment> replies;

  BlogComment({
    required this.id,
    required this.name,
    required this.comment,
    required this.createdAt,
    required this.replies,
  });

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    return BlogComment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      replies: (json['replies'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(BlogComment.fromJson)
          .toList(),
    );
  }
}
