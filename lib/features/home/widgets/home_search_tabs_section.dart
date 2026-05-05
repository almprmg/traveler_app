import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

typedef HugeIconData = List<List<dynamic>>;

enum _TabKind { tour, hotel, activities, visa, transport }

class HomeSearchTabsSection extends StatefulWidget {
  final List<Destination> destinations;
  const HomeSearchTabsSection({super.key, required this.destinations});

  @override
  State<HomeSearchTabsSection> createState() => _HomeSearchTabsSectionState();
}

class _HomeSearchTabsSectionState extends State<HomeSearchTabsSection> {
  _TabKind _active = _TabKind.tour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _TabsBar(
              active: _active,
              onChanged: (k) => setState(() => _active = k),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _formForTab(_active),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formForTab(_TabKind kind) {
    switch (kind) {
      case _TabKind.tour:
        return _TourForm(
          key: const ValueKey('tour'),
          destinations: widget.destinations,
        );
      case _TabKind.hotel:
        return _HotelForm(
          key: const ValueKey('hotel'),
          destinations: widget.destinations,
        );
      case _TabKind.activities:
        return _ActivitiesForm(
          key: const ValueKey('activities'),
          destinations: widget.destinations,
        );
      case _TabKind.visa:
        return const _VisaForm(key: ValueKey('visa'));
      case _TabKind.transport:
        return _TransportForm(
          key: const ValueKey('transport'),
          destinations: widget.destinations,
        );
    }
  }
}

// ---------------- Tabs bar ----------------

class _TabsBar extends StatelessWidget {
  final _TabKind active;
  final ValueChanged<_TabKind> onChanged;

  const _TabsBar({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = <_TabSpec>[
      _TabSpec(
        kind: _TabKind.tour,
        label: 'tab_tour'.tr,
        icon: HugeIcons.strokeRoundedLocation04,
      ),
      _TabSpec(
        kind: _TabKind.hotel,
        label: 'tab_hotel'.tr,
        icon: HugeIcons.strokeRoundedHotel01,
      ),
      _TabSpec(
        kind: _TabKind.activities,
        label: 'tab_activities'.tr,
        icon: HugeIcons.strokeRoundedActivity01,
      ),
      _TabSpec(
        kind: _TabKind.visa,
        label: 'tab_visa'.tr,
        icon: HugeIcons.strokeRoundedPassport,
      ),
      _TabSpec(
        kind: _TabKind.transport,
        label: 'tab_transport'.tr,
        icon: HugeIcons.strokeRoundedCar01,
      ),
    ];

    return Container(
      color: AppTheme.primary.withValues(alpha: 0.06),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final t in tabs) ...[
              _TabPill(
                spec: t,
                selected: t.kind == active,
                onTap: () => onChanged(t.kind),
              ),
              const SizedBox(width: 6),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  final _TabKind kind;
  final String label;
  final HugeIconData icon;
  _TabSpec({required this.kind, required this.label, required this.icon});
}

class _TabPill extends StatelessWidget {
  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppTheme.white : AppTheme.primaryDark;
    return Material(
      color: selected ? AppTheme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(icon: spec.icon, color: fg, size: 18),
              const SizedBox(width: 6),
              Text(
                spec.label,
                style: AppTypography.labelLarge.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Reusable field button ----------------

class _FieldButton extends StatelessWidget {
  final HugeIconData icon;
  final String label;
  final String? value;
  final String hint;
  final VoidCallback onTap;

  const _FieldButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return Material(
      color: AppTheme.primary.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              HugeIcon(icon: icon, color: AppTheme.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasValue ? value! : hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: hasValue
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              HugeIcon(
                icon: HugeIcons.strokeRoundedArrowDown01,
                color: AppTheme.textTertiary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Search button ----------------

class _SearchActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SearchActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          color: AppTheme.white,
          size: 20,
        ),
        label: Text(
          'search'.tr,
          style: AppTypography.buttonMedium.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius12),
          ),
        ),
      ),
    );
  }
}

// ---------------- Pickers ----------------

Future<T?> _pickFromList<T>(
  BuildContext context, {
  required String title,
  required List<T> items,
  required String Function(T) labelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppTheme.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(title, style: AppTypography.h4),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppTheme.border),
                  itemBuilder: (_, i) => ListTile(
                    title: Text(
                      labelOf(items[i]),
                      style: AppTypography.bodyLarge,
                    ),
                    onTap: () => Navigator.of(ctx).pop(items[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);
String _fmtMonth(DateTime d) => DateFormat('MMMM yyyy').format(d);

// ---------------- Tour form ----------------

class _TourForm extends StatefulWidget {
  final List<Destination> destinations;
  const _TourForm({super.key, required this.destinations});

  @override
  State<_TourForm> createState() => _TourFormState();
}

class _TourFormState extends State<_TourForm> {
  Destination? _destination;
  String? _tourType;
  DateTime? _month;
  String? _duration;

  static const _tourTypes = [
    'Adventure',
    'Cultural',
    'Family',
    'Honeymoon',
    'Group',
  ];
  static const _durations = ['1-3 days', '4-7 days', '8-14 days', '15+ days'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: HugeIcons.strokeRoundedLocation01,
          label: 'destination_label'.tr,
          hint: 'select_destination'.tr,
          value: _destination?.name,
          onTap: () async {
            final v = await _pickFromList<Destination>(
              context,
              title: 'select_destination'.tr,
              items: widget.destinations,
              labelOf: (d) => d.name,
            );
            if (v != null) setState(() => _destination = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedBriefcase01,
          label: 'tour_type_label'.tr,
          hint: 'select_tour_type'.tr,
          value: _tourType,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'select_tour_type'.tr,
              items: _tourTypes,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _tourType = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedClock01,
          label: 'when_label'.tr,
          hint: 'select_month'.tr,
          value: _month == null ? null : _fmtMonth(_month!),
          onTap: () async {
            final now = DateTime.now();
            final v = await showDatePicker(
              context: context,
              initialDate: _month ?? now,
              firstDate: DateTime(now.year, now.month, 1),
              lastDate: DateTime(now.year + 2, 12, 31),
            );
            if (v != null) {
              setState(() => _month = DateTime(v.year, v.month, 1));
            }
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedCalendar03,
          label: 'tour_duration_label'.tr,
          hint: 'select_duration'.tr,
          value: _duration,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'select_duration'.tr,
              items: _durations,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _duration = v);
          },
        ),
        const SizedBox(height: 14),
        _SearchActionButton(
          onPressed: () {
            Get.toNamed(
              toursRoute,
              arguments: {
                'destination_id': _destination?.id,
                'destination_name': _destination?.name,
                'tour_type': _tourType,
                'month': _month?.toIso8601String(),
                'duration': _duration,
              },
            );
          },
        ),
      ],
    );
  }
}

// ---------------- Hotel form ----------------

class _HotelForm extends StatefulWidget {
  final List<Destination> destinations;
  const _HotelForm({super.key, required this.destinations});

  @override
  State<_HotelForm> createState() => _HotelFormState();
}

class _HotelFormState extends State<_HotelForm> {
  Destination? _destination;
  DateTimeRange? _range;
  String? _roomType;
  int _guests = 2;

  static const _roomTypes = ['Single', 'Double', 'Twin', 'Suite', 'Family'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: HugeIcons.strokeRoundedLocation01,
          label: 'location_label'.tr,
          hint: 'select_location'.tr,
          value: _destination?.name,
          onTap: () async {
            final v = await _pickFromList<Destination>(
              context,
              title: 'select_location'.tr,
              items: widget.destinations,
              labelOf: (d) => d.name,
            );
            if (v != null) setState(() => _destination = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedClock01,
          label: 'check_in_out_label'.tr,
          hint: 'select_dates'.tr,
          value: _range == null
              ? null
              : '${_fmtDate(_range!.start)} - ${_fmtDate(_range!.end)}',
          onTap: () async {
            final now = DateTime.now();
            final v = await showDateRangePicker(
              context: context,
              initialDateRange:
                  _range ??
                  DateTimeRange(
                    start: now,
                    end: now.add(const Duration(days: 3)),
                  ),
              firstDate: now,
              lastDate: DateTime(now.year + 2, 12, 31),
            );
            if (v != null) setState(() => _range = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedHotel01,
          label: 'room_label'.tr,
          hint: 'room_type'.tr,
          value: _roomType,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'room_type'.tr,
              items: _roomTypes,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _roomType = v);
          },
        ),
        const SizedBox(height: 10),
        _GuestCounter(
          value: _guests,
          onChanged: (v) => setState(() => _guests = v),
        ),
        const SizedBox(height: 14),
        _SearchActionButton(
          onPressed: () {
            Get.toNamed(
              hotelsRoute,
              arguments: {
                'destination_id': _destination?.id,
                'destination_name': _destination?.name,
                'check_in': _range?.start.toIso8601String(),
                'check_out': _range?.end.toIso8601String(),
                'room_type': _roomType,
                'guests': _guests,
              },
            );
          },
        ),
      ],
    );
  }
}

class _GuestCounter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _GuestCounter({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedUserMultiple,
            color: AppTheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'guest_label'.tr,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${value.toString().padLeft(2, '0')} ${'guest_person'.tr}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _CounterButton(
            icon: HugeIcons.strokeRoundedMinusSign,
            onTap: value > 1 ? () => onChanged(value - 1) : null,
          ),
          const SizedBox(width: 8),
          _CounterButton(
            icon: HugeIcons.strokeRoundedPlusSign,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final HugeIconData icon;
  final VoidCallback? onTap;
  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primary : AppTheme.border,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: HugeIcon(icon: icon, color: AppTheme.white, size: 16),
      ),
    );
  }
}

// ---------------- Activities form ----------------

class _ActivitiesForm extends StatefulWidget {
  final List<Destination> destinations;
  const _ActivitiesForm({super.key, required this.destinations});

  @override
  State<_ActivitiesForm> createState() => _ActivitiesFormState();
}

class _ActivitiesFormState extends State<_ActivitiesForm> {
  Destination? _location;
  DateTime? _day;
  int _travelers = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: HugeIcons.strokeRoundedLocation01,
          label: 'location_label'.tr,
          hint: 'select_location'.tr,
          value: _location?.name,
          onTap: () async {
            final v = await _pickFromList<Destination>(
              context,
              title: 'select_location'.tr,
              items: widget.destinations,
              labelOf: (d) => d.name,
            );
            if (v != null) setState(() => _location = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedClock01,
          label: 'activity_day_label'.tr,
          hint: 'select_date'.tr,
          value: _day == null ? null : _fmtDate(_day!),
          onTap: () async {
            final now = DateTime.now();
            final v = await showDatePicker(
              context: context,
              initialDate: _day ?? now,
              firstDate: now,
              lastDate: DateTime(now.year + 2, 12, 31),
            );
            if (v != null) setState(() => _day = v);
          },
        ),
        const SizedBox(height: 10),
        _GuestCounter(
          value: _travelers,
          onChanged: (v) => setState(() => _travelers = v),
        ),
        const SizedBox(height: 14),
        _SearchActionButton(
          onPressed: () {
            Get.toNamed(
              activitiesRoute,
              arguments: {
                'destination_id': _location?.id,
                'destination_name': _location?.name,
                'date': _day?.toIso8601String(),
                'travelers': _travelers,
              },
            );
          },
        ),
      ],
    );
  }
}

// ---------------- Visa form ----------------

class _VisaForm extends StatefulWidget {
  const _VisaForm({super.key});

  @override
  State<_VisaForm> createState() => _VisaFormState();
}

class _VisaFormState extends State<_VisaForm> {
  String? _country;
  String? _visaType;
  String? _visaMode;

  static const _countries = [
    'Saudi Arabia',
    'United Arab Emirates',
    'Egypt',
    'Turkey',
    'United Kingdom',
    'United States',
    'Schengen',
  ];
  static const _types = ['Tourist', 'Business', 'Student', 'Work', 'Transit'];
  static const _modes = ['Single Entry', 'Multiple Entry', 'e-Visa'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: HugeIcons.strokeRoundedLocation01,
          label: 'country_label'.tr,
          hint: 'select_country'.tr,
          value: _country,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'select_country'.tr,
              items: _countries,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _country = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedBriefcase01,
          label: 'visa_type_label'.tr,
          hint: 'select_visa_type'.tr,
          value: _visaType,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'select_visa_type'.tr,
              items: _types,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _visaType = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedUserMultiple,
          label: 'visa_mode_label'.tr,
          hint: 'select_visa_mode'.tr,
          value: _visaMode,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'select_visa_mode'.tr,
              items: _modes,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _visaMode = v);
          },
        ),
        const SizedBox(height: 14),
        _SearchActionButton(
          onPressed: () {
            Get.toNamed(
              visasRoute,
              arguments: {
                'country': _country,
                'visa_type': _visaType,
                'visa_mode': _visaMode,
              },
            );
          },
        ),
      ],
    );
  }
}

// ---------------- Transport form ----------------

class _TransportForm extends StatefulWidget {
  final List<Destination> destinations;
  const _TransportForm({super.key, required this.destinations});

  @override
  State<_TransportForm> createState() => _TransportFormState();
}

class _TransportFormState extends State<_TransportForm> {
  Destination? _from;
  String? _type;
  DateTime? _date;

  static const _types = ['Car', 'Bus', 'Van', 'Limousine', 'Boat'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldButton(
          icon: HugeIcons.strokeRoundedLocation01,
          label: 'location_from_label'.tr,
          hint: 'select_location'.tr,
          value: _from?.name,
          onTap: () async {
            final v = await _pickFromList<Destination>(
              context,
              title: 'select_location'.tr,
              items: widget.destinations,
              labelOf: (d) => d.name,
            );
            if (v != null) setState(() => _from = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedCar01,
          label: 'transport_type_label'.tr,
          hint: 'which_type'.tr,
          value: _type,
          onTap: () async {
            final v = await _pickFromList<String>(
              context,
              title: 'which_type'.tr,
              items: _types,
              labelOf: (s) => s,
            );
            if (v != null) setState(() => _type = v);
          },
        ),
        const SizedBox(height: 10),
        _FieldButton(
          icon: HugeIcons.strokeRoundedClock01,
          label: 'reserve_date_label'.tr,
          hint: 'select_date'.tr,
          value: _date == null ? null : _fmtDate(_date!),
          onTap: () async {
            final now = DateTime.now();
            final v = await showDatePicker(
              context: context,
              initialDate: _date ?? now,
              firstDate: now,
              lastDate: DateTime(now.year + 2, 12, 31),
            );
            if (v != null) setState(() => _date = v);
          },
        ),
        const SizedBox(height: 14),
        _SearchActionButton(
          onPressed: () {
            Get.toNamed(
              transportsRoute,
              arguments: {
                'destination_id': _from?.id,
                'destination_name': _from?.name,
                'transport_type': _type,
                'date': _date?.toIso8601String(),
              },
            );
          },
        ),
      ],
    );
  }
}
