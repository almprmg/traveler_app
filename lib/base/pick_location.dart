import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:traveler_app/util/app_logger.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/location_permission_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/location_search_screen.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _centerLocation = const LatLng(24.7136, 46.6753);
  bool _loading = true;
  bool _mapMoving = false;
  bool _geocoding = true;
  String _fullAddress = '';
  String _areaName = '';
  String _detailedAddress = '';
  Timer? _geocodeTimer;

  static const _redGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const CameraPosition _kDefaultPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 15.0,
  );

  static const double _bottomPanelHeight = 230.0;
  static const double _topBarHeight = 110.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _geocodeTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    if (mounted) setState(() => _loading = true);
    try {
      final result = await LocationPermissionHelper.requestPermission();
      if (result.isGranted && result.position != null) {
        final loc = LatLng(
          result.position!.latitude,
          result.position!.longitude,
        );
        final controller = await _controller.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: 15.0),
          ),
        );
        if (mounted) setState(() => _centerLocation = loc);
        _reverseGeocode(loc);
      } else {
        _reverseGeocode(_centerLocation);
      }
    } catch (e) {
      AppLogger.error('Error getting location: $e');
      _reverseGeocode(_centerLocation);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reverseGeocode(LatLng loc) async {
    if (mounted) setState(() => _geocoding = true);
    try {
      final lang = Get.locale?.languageCode ?? 'ar';
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${loc.latitude}&lon=${loc.longitude}&format=json&accept-language=$lang',
      );
      final res = await http.get(
        uri,
        headers: {
          'Accept-Language': lang,
          'User-Agent': 'KPIndividualsApp/1.0 contact@kpindividuals.com',
        },
      );
      if (res.statusCode == 200 && mounted) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>?;
        if (addr != null) {
          final road = (addr['road'] ?? addr['pedestrian'] ?? '') as String;
          final area =
              (addr['suburb'] ??
                      addr['neighbourhood'] ??
                      addr['quarter'] ??
                      addr['district'] ??
                      '')
                  as String;
          final city =
              (addr['city'] ?? addr['town'] ?? addr['county'] ?? '') as String;
          final country = (addr['country'] ?? '') as String;
          final state = (addr['state'] ?? addr['region'] ?? '') as String;
          setState(() {
            _areaName = area;
            _fullAddress = [
              city,
              state,
              country,
            ].where((s) => s.isNotEmpty).join('، ');
            // Detailed: road + area + city
            _detailedAddress = [
              road,
              area,
              city,
            ].where((s) => s.isNotEmpty).join('، ');
            if (_detailedAddress.isEmpty) {
              _detailedAddress = data['display_name'] as String? ?? '';
            }
          });
        }
      }
    } catch (e) {
      AppLogger.error('Reverse geocode error: $e');
    } finally {
      if (mounted) setState(() => _geocoding = false);
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (!_mapMoving) setState(() => _mapMoving = true);
    _centerLocation = position.target;
    _geocodeTimer?.cancel();
  }

  void _onCameraIdle() {
    setState(() => _mapMoving = false);
    _geocodeTimer = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocode(_centerLocation);
    });
  }

  Future<void> _openSearchScreen() async {
    final label = [
      _fullAddress,
      _areaName,
    ].where((s) => s.isNotEmpty).join(' - ');
    final result = await Get.to<LatLng>(
      () => LocationSearchScreen(
        currentLocationLabel: label.isNotEmpty ? label : null,
      ),
    );
    if (result != null) {
      final controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: result, zoom: 15.0),
        ),
      );
      if (mounted) setState(() => _centerLocation = result);
      _reverseGeocode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kDefaultPosition,
            onMapCreated: (controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            padding: const EdgeInsets.only(
              bottom: _bottomPanelHeight,
              top: _topBarHeight,
            ),
          ),

          // Center pin
          _buildCenterPin(),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: _buildSearchBar(),
          ),

          // Current location button + floating panel
          Positioned(
            bottom: 12 + MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCurrentLocationButton(),
                const SizedBox(height: 12),
                _buildBottomPanel(),
              ],
            ),
          ),

          if (_loading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterPin() {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, -0.25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Callout bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'order_will_be_delivered_here'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            // Triangle pointer
            CustomPaint(size: const Size(16, 8), painter: _TrianglePainter()),
            // Pin icon — lifts slightly when map is moving
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: _mapMoving
                  ? Matrix4.translationValues(0.0, -6.0, 0.0)
                  : Matrix4.identity(),
              child: ShaderMask(
                shaderCallback: (bounds) => _redGradient.createShader(bounds),
                child: SvgPicture.asset(
                  'assets/svg/location_pin.svg',
                  width: 46,
                  height: 46,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: _openSearchScreen,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'search_building_area'.tr,
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SvgPicture.asset(
                'assets/svg/search_icon.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppTheme.textTertiary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationButton() {
    return GestureDetector(
      onTap: _getCurrentLocation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => _redGradient.createShader(bounds),
              child: Transform.rotate(
                angle: 0.785398,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'current_location'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location name row
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/location_pin.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFD32F2F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: (_mapMoving || _geocoding)
                      ? _buildLocationSkeleton()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _detailedAddress.isNotEmpty
                                  ? _detailedAddress
                                  : 'unknown_location'.tr,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (_fullAddress.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                _fullAddress,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Confirm button
            AppButton(
              text: 'confirm_location'.tr,
              onPressed: () => Get.back(result: _centerLocation),
              width: double.infinity,
              borderRadius: 12,
              size: ButtonSize.large,
              type: ButtonType.gradient,
            ),
            const SizedBox(height: 12),

            // Skip
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                'skip'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed,
                  decorationColor: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 16,
          width: 120,
          decoration: BoxDecoration(
            color: AppTheme.shimmerBase,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 13,
          width: 180,
          decoration: BoxDecoration(
            color: AppTheme.shimmerBase,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
