import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

typedef _HugeIconData = List<List<dynamic>>;
typedef SearchFormCallback = void Function(Map<String, dynamic> args);

// ---------------- Card wrapper ----------------

class _FormCard extends StatelessWidget {
  final Widget child;
  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        child: child,
      ),
    );
  }
}

// ---------------- Reusable field button ----------------

class _FieldButton extends StatelessWidget {
  final _HugeIconData icon;
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
              const HugeIcon(
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

class TourSearchForm extends StatefulWidget {
  final List<Destination> destinations;
  final SearchFormCallback onSearch;
  const TourSearchForm({
    super.key,
    required this.destinations,
    required this.onSearch,
  });

  @override
  State<TourSearchForm> createState() => _TourSearchFormState();
}

class _TourSearchFormState extends State<TourSearchForm> {
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
    return _FormCard(
      child: Column(
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
            onPressed: () => widget.onSearch({
              'destination_id': _destination?.id,
              'destination_name': _destination?.name,
              'tour_type': _tourType,
              'month': _month?.toIso8601String(),
              'duration': _duration,
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------- Hotel form ----------------

class HotelSearchForm extends StatefulWidget {
  final List<Destination> destinations;
  final SearchFormCallback onSearch;
  const HotelSearchForm({
    super.key,
    required this.destinations,
    required this.onSearch,
  });

  @override
  State<HotelSearchForm> createState() => _HotelSearchFormState();
}

class _HotelSearchFormState extends State<HotelSearchForm> {
  Destination? _destination;
  DateTimeRange? _range;
  String? _roomType;
  int _guests = 2;

  static const _roomTypes = ['Single', 'Double', 'Twin', 'Suite', 'Family'];

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      child: Column(
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
            onPressed: () => widget.onSearch({
              'destination_id': _destination?.id,
              'destination_name': _destination?.name,
              'check_in': _range?.start.toIso8601String(),
              'check_out': _range?.end.toIso8601String(),
              'room_type': _roomType,
              'guests': _guests,
            }),
          ),
        ],
      ),
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
  final _HugeIconData icon;
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

class ActivitiesSearchForm extends StatefulWidget {
  final List<Destination> destinations;
  final SearchFormCallback onSearch;
  const ActivitiesSearchForm({
    super.key,
    required this.destinations,
    required this.onSearch,
  });

  @override
  State<ActivitiesSearchForm> createState() => _ActivitiesSearchFormState();
}

class _ActivitiesSearchFormState extends State<ActivitiesSearchForm> {
  Destination? _location;
  DateTime? _day;
  int _travelers = 1;

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      child: Column(
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
            onPressed: () => widget.onSearch({
              'destination_id': _location?.id,
              'destination_name': _location?.name,
              'date': _day?.toIso8601String(),
              'travelers': _travelers,
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------- Visa form ----------------

class VisaSearchForm extends StatefulWidget {
  final SearchFormCallback onSearch;
  const VisaSearchForm({super.key, required this.onSearch});

  @override
  State<VisaSearchForm> createState() => _VisaSearchFormState();
}

class _VisaSearchFormState extends State<VisaSearchForm> {
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
    return _FormCard(
      child: Column(
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
            onPressed: () => widget.onSearch({
              'country': _country,
              'visa_type': _visaType,
              'visa_mode': _visaMode,
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------- Transport form ----------------

class TransportSearchForm extends StatefulWidget {
  final List<Destination> destinations;
  final SearchFormCallback onSearch;
  const TransportSearchForm({
    super.key,
    required this.destinations,
    required this.onSearch,
  });

  @override
  State<TransportSearchForm> createState() => _TransportSearchFormState();
}

class _TransportSearchFormState extends State<TransportSearchForm> {
  Destination? _from;
  String? _type;
  DateTime? _date;

  static const _types = ['Car', 'Bus', 'Van', 'Limousine', 'Boat'];

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      child: Column(
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
            onPressed: () => widget.onSearch({
              'destination_id': _from?.id,
              'destination_name': _from?.name,
              'transport_type': _type,
              'date': _date?.toIso8601String(),
            }),
          ),
        ],
      ),
    );
  }
}
