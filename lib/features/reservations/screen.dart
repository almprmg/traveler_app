import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/reservations/controller/reservations_controller.dart';
import 'package:traveler_app/features/reservations/model/reservation_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:hugeicons/hugeicons.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late final ReservationsController _c;
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _c = Get.find<ReservationsController>();
    _auth = Get.find<AuthController>();
    if (_auth.isLoggedIn()) _c.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('reservations'.tr),
        automaticallyImplyLeading: false,
      ),
      body: _auth.isLoggedIn() ? _buildList() : _buildLoginPrompt(),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Container(
          color: AppTheme.white,
          child: Row(
            children: [
              _tabItem('upcoming'.tr, 0),
              _tabItem('completed'.tr, 1),
              _tabItem('cancelled'.tr, 2),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (_c.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final list = _c.currentList;
            if (list.isEmpty) {
              return EmptyState(onRefresh: _c.fetchAll);
            }
            return RefreshIndicator(
              onRefresh: _c.fetchAll,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ReservationCard(item: list[i]),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(icon: HugeIcons.strokeRoundedLockKey, size: 64, color: AppTheme.textTertiary),
            const SizedBox(height: 16),
            Text(
              'login_to_view_reservations'.tr,
              style: AppTypography.h5.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.toNamed(loginRoute),
              child: Text('login'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: () => _c.selectedTab.value = index,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _c.selectedTab.value == index
                      ? AppTheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: _c.selectedTab.value == index
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
                fontWeight: _c.selectedTab.value == index
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationListItem item;
  const _ReservationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        reservationDetailRoute,
        arguments: {'id': item.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: AppTypography.h5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '#${item.bookingNumber}',
              style: AppTypography.bodySmall
                  .copyWith(color: AppTheme.textTertiary),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.startDate ?? item.bookingDate,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppTheme.textSecondary),
                ),
                MoneyWithIcon(
                  money: item.totalAmount,
                  precision: 0,
                  textSize: 14,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        color = AppTheme.success;
        bg = AppTheme.successWithOpacity;
        break;
      case 'cancelled':
        color = AppTheme.error;
        bg = AppTheme.errorWithOpacity;
        break;
      case 'pending':
        color = AppTheme.warning;
        bg = AppTheme.warningWithOpacity;
        break;
      default:
        color = AppTheme.textSecondary;
        bg = AppTheme.backgroundDark;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radius4),
      ),
      child: Text(
        status,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
