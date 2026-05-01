import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/util/app_logger.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/util/location_permission_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSearchScreen extends StatefulWidget {
  final String? currentLocationLabel;

  const LocationSearchScreen({super.key, this.currentLocationLabel});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_PlaceResult> _results = [];
  bool _searching = false;
  Timer? _debounce;
  String _currentLocationLabel = '';
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _currentLocationLabel = widget.currentLocationLabel ?? '';
    if (_currentLocationLabel.isEmpty) {
      _loadCurrentLocationLabel();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCurrentLocationLabel() async {
    try {
      final result = await LocationPermissionHelper.getPermissionAndLocation();
      if (result.isGranted && result.position != null && mounted) {
        final loc = LatLng(
          result.position!.latitude,
          result.position!.longitude,
        );
        setState(() => _userLocation = loc);
        final label = await _reverseGeocodeLabel(loc);
        if (mounted) setState(() => _currentLocationLabel = label);
      }
    } catch (e) {
      AppLogger.error('Error loading current location label: $e');
    }
  }

  double _distanceTo(double lat, double lon) {
    if (_userLocation == null) return 0;
    final dLat = lat - _userLocation!.latitude;
    final dLon = lon - _userLocation!.longitude;
    return sqrt(dLat * dLat + dLon * dLon);
  }

  Future<String> _reverseGeocodeLabel(LatLng loc) async {
    try {
      final lang = Get.locale?.languageCode ?? 'ar';
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${loc.latitude},${loc.longitude}'
        '&key=$_apiKey'
        '&language=$lang',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          // Pick the most detailed result (first one is usually the most specific)
          return (results.first['formatted_address'] as String? ?? '');
        }
      }
    } catch (e) {
      AppLogger.error('Reverse geocode error: $e');
    }
    return '';
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    _debounce?.cancel();
    if (query.isEmpty) {
      setState(() => _results.clear());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(query));
  }

  static const _apiKey = 'AIzaSyCQ9WbjCH1uh9qNw5_Dw22Omnt7QO_W7js';

  Future<void> _search(String query) async {
    if (!mounted) return;
    setState(() => _searching = true);
    try {
      final lang = Get.locale?.languageCode ?? 'ar';
      // Google Places Autocomplete
      final autoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(query)}'
        '&key=$_apiKey'
        '&language=$lang'
        '&components=country:sa'
        '&types=geocode'
        '${_userLocation != null ? '&location=${_userLocation!.latitude},${_userLocation!.longitude}&radius=50000' : ''}',
      );
      final autoRes = await http.get(autoUri);
      if (autoRes.statusCode == 200 && mounted) {
        final autoData = json.decode(autoRes.body) as Map<String, dynamic>;
        final predictions = (autoData['predictions'] as List<dynamic>? ?? []);

        // Fetch coordinates for each prediction
        final places = <_PlaceResult>[];
        for (final p in predictions.take(10)) {
          final placeId = p['place_id'] as String;
          final mainText =
              (p['structured_formatting']?['main_text'] as String?) ??
              (p['description'] as String).split(',').first;
          final secondaryText =
              (p['structured_formatting']?['secondary_text'] as String?) ?? '';

          final detailUri = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json'
            '?place_id=$placeId&fields=geometry&key=$_apiKey',
          );
          final detailRes = await http.get(detailUri);
          if (detailRes.statusCode == 200) {
            final detail = json.decode(detailRes.body) as Map<String, dynamic>;
            final loc = detail['result']?['geometry']?['location'];
            if (loc != null) {
              final lat = (loc['lat'] as num).toDouble();
              final lon = (loc['lng'] as num).toDouble();
              places.add(
                _PlaceResult(
                  name: mainText,
                  subtitle: secondaryText,
                  lat: lat,
                  lon: lon,
                  distance: _distanceTo(lat, lon),
                ),
              );
            }
          }
        }
        places.sort((a, b) => a.distance.compareTo(b.distance));
        if (mounted) {
          setState(
            () => _results
              ..clear()
              ..addAll(places),
          );
        }
      }
    } catch (e) {
      AppLogger.error('Location search error: $e');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final result = await LocationPermissionHelper.requestPermission();
      if (result.isGranted && result.position != null) {
        Get.back(
          result: LatLng(result.position!.latitude, result.position!.longitude),
        );
      }
    } catch (e) {
      AppLogger.error('Error using current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'search_building_area'.tr,
            hintStyle: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 15,
            ),
            prefixIcon: IconButton(
              icon: HugeIcon(
                icon: Get.find<LocalizationController>().isLtr
                    ? HugeIcons.strokeRoundedArrowLeft01
                    : HugeIcons.strokeRoundedArrowRight01,
                color: AppTheme.textSecondary,
              ),
              onPressed: () => Get.back(),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                'assets/svg/search_icon.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppTheme.textTertiary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final hasQuery = _controller.text.trim().isNotEmpty;
    return CustomScrollView(
      slivers: [
        // Always show "use current location"
        SliverToBoxAdapter(child: _buildCurrentLocationTile()),

        if (hasQuery) ...[
          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text('search_results'.tr, style: AppTypography.h5),
            ),
          ),

          // Skeleton or results or empty
          if (_searching)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, __) => _buildSkeletonCard(),
                childCount: 5,
              ),
            )
          else if (_results.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 100,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_search_found.svg',
                      width: 90,
                      height: 90,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_results_found'.tr,
                      style: AppTypography.h5,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'try_different_search'.tr,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => _buildResultItem(_results[index]),
                childCount: _results.length,
              ),
            ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.shimmerBase,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppTheme.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 11,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationTile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _useCurrentLocation,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: 0.785398,
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedLocation01,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'use_my_current_location'.tr,
                        style: AppTypography.h6.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                      if (_currentLocationLabel.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          _currentLocationLabel,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                HugeIcon(
                  icon: Get.find<LocalizationController>().isLtr
                      ? HugeIcons.strokeRoundedArrowRight01
                      : HugeIcons.strokeRoundedArrowLeft01,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(_PlaceResult place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.back(result: LatLng(place.lat, place.lon)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/location_pin.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: AppTypography.h6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (place.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          place.subtitle,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                HugeIcon(
                  icon: Get.find<LocalizationController>().isLtr
                      ? HugeIcons.strokeRoundedArrowRight01
                      : HugeIcons.strokeRoundedArrowLeft01,
                  size: 18,
                  color: AppTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceResult {
  final String name;
  final String subtitle;
  final double lat;
  final double lon;
  final double distance;

  const _PlaceResult({
    required this.name,
    required this.subtitle,
    required this.lat,
    required this.lon,
    this.distance = 0,
  });
}
