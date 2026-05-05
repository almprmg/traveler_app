import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/blogs/controller/blogs_controller.dart';
import 'package:traveler_app/features/blogs/model/blog_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class BlogDetailScreen extends StatelessWidget {
  const BlogDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BlogDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final b = c.blog.value;
        if (b == null) return DetailErrorView(onRetry: c.fetch);
        return CustomScrollView(
          slivers: [
            ProductHeroSliver(imageUrl: b.imageUrl),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (b.category != null)
                      DetailBadge(text: b.category!),
                    const SizedBox(height: 10),
                    Text(b.title, style: AppTypography.h2),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          size: 14,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          b.author ?? '',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (b.publishedAt != null) ...[
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedCalendar03,
                            size: 14,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            b.publishedAt!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HtmlWidget(b.content, textStyle: AppTypography.bodyMedium),
              ),
            ),
            if (b.tags.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'tags'.tr,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: b.tags.map((t) => DetailBadge(text: t)).toList(),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: DetailSection(
                title: '${'comments'.tr} (${c.comments.length})',
                child: Column(
                  children: [
                    for (final cm in c.comments) _CommentTile(comment: cm),
                    const SizedBox(height: 8),
                    _AddCommentBox(controller: c),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      }),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final BlogComment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(color: AppTheme.cardBorder, width: 1),
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.primary,
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    color: AppTheme.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comment.name,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  comment.createdAt,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(comment.comment, style: AppTypography.bodyMedium),
            if (comment.replies.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: Column(
                  children: [
                    for (final r in comment.replies)
                      _CommentTile(comment: r),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddCommentBox extends StatefulWidget {
  final BlogDetailController controller;
  const _AddCommentBox({required this.controller});

  @override
  State<_AddCommentBox> createState() => _AddCommentBoxState();
}

class _AddCommentBoxState extends State<_AddCommentBox> {
  final _commentCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.cardBorder, width: 1),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'name_label'.tr,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'add_comment_hint'.tr,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => ElevatedButton.icon(
                onPressed: widget.controller.isPostingComment.value
                    ? null
                    : () async {
                        final ok = await widget.controller.submitComment(
                          comment: _commentCtrl.text,
                          name: _nameCtrl.text.isEmpty
                              ? null
                              : _nameCtrl.text,
                        );
                        if (ok) _commentCtrl.clear();
                      },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSent,
                  color: AppTheme.white,
                  size: 18,
                ),
                label: Text(
                  widget.controller.isPostingComment.value
                      ? 'sending'.tr
                      : 'submit_comment'.tr,
                ),
              )),
        ],
      ),
    );
  }
}
