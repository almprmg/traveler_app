import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/esim/controller/esim_controller.dart';
import 'package:traveler_app/features/esim/model/esim_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class EsimProfilesScreen extends StatefulWidget {
  const EsimProfilesScreen({super.key});

  @override
  State<EsimProfilesScreen> createState() => _EsimProfilesScreenState();
}

class _EsimProfilesScreenState extends State<EsimProfilesScreen> {
  late final EsimProfilesController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<EsimProfilesController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('esim_profiles'.tr)),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_c.profiles.isEmpty) return EmptyState(onRefresh: _c.fetch);
        return RefreshIndicator(
          onRefresh: _c.fetch,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _c.profiles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ProfileCard(
              profile: _c.profiles[i],
              isRefreshing: _c.isRefreshing.value == _c.profiles[i].iccid,
              onRefresh: () => _c.refreshProfile(_c.profiles[i].iccid),
            ),
          ),
        );
      }),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final EsimProfile profile;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  const _ProfileCard({
    required this.profile,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWithOpacity,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSmartPhone01,
                  color: AppTheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.packageTitle ?? profile.iccid,
                      style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'ICCID: ${profile.iccid}',
                      style: AppTypography.labelSmall.copyWith(
                          color: AppTheme.textTertiary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: isRefreshing ? null : onRefresh,
                icon: isRefreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const HugeIcon(
                        icon: HugeIcons.strokeRoundedRefresh,
                        color: AppTheme.primary,
                        size: 20,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: profile.usagePercent.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppTheme.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'esim_used'.tr}: ${_formatMb(profile.dataUsedMb)}',
                style: AppTypography.bodySmall,
              ),
              Text(
                '${'esim_remaining'.tr}: ${_formatMb(profile.dataRemainingMb)}',
                style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (profile.qrCode != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedQrCode,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      profile.qrCode!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                          color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMb(int mb) {
    if (mb >= 1024) return '${(mb / 1024).toStringAsFixed(1)} GB';
    return '$mb MB';
  }
}
