import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// OS-level connectivity controller. Mirrors the behaviour of major apps:
///
/// • **Optimistic by default** — assume online until the OS says otherwise,
///   so the offline banner never flashes on cold start.
/// • **Single source of truth: `connectivity_plus`**, which surfaces what the
///   OS itself reports. No DNS pings, no third-party servers — those produce
///   false negatives on restricted networks (corporate VPNs, Saudi-region
///   blocks, captive portals, ad-blockers).
/// • **Small debounce on disconnect** to avoid flicker during quick handovers
///   (e.g. WiFi → cellular).
/// • **Real "internet works" verification** is left to actual API calls
///   (handled in `ApiHandler`) — that's the only signal that matters for
///   the user's task.
class InternetController extends GetxController {
  final RxBool isConnected = true.obs;
  final RxString connectionType = 'wifi'.obs;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _disconnectDebounce;

  static const Duration _disconnectGrace = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    recheck();
    _subscription = _connectivity.onConnectivityChanged.listen(_handle);
  }

  /// Re-query the OS for the current network state. Safe to call from a
  /// "Retry" button — it does NOT ping any server, so it's free.
  Future<void> recheck() async {
    final result = await _connectivity.checkConnectivity();
    _handle(result);
  }

  void _handle(List<ConnectivityResult> result) {
    final hasNetwork = result.any((r) => r != ConnectivityResult.none);
    connectionType.value = _typeFor(result);

    if (hasNetwork) {
      _disconnectDebounce?.cancel();
      _disconnectDebounce = null;
      if (!isConnected.value) isConnected.value = true;
    } else {
      // Debounce — quick handovers between networks briefly report none.
      if (_disconnectDebounce?.isActive ?? false) return;
      _disconnectDebounce = Timer(_disconnectGrace, () {
        isConnected.value = false;
      });
    }
  }

  String _typeFor(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) return _tr('wifi');
    if (result.contains(ConnectivityResult.mobile)) return _tr('mobile_data');
    if (result.contains(ConnectivityResult.ethernet)) return _tr('ethernet');
    if (result.contains(ConnectivityResult.none)) {
      return _tr('no_internet_connection');
    }
    return _tr('other');
  }

  String _tr(String key) {
    try {
      return Get.locale != null ? key.tr : key;
    } catch (_) {
      return key;
    }
  }

  @override
  void onClose() {
    _disconnectDebounce?.cancel();
    _subscription?.cancel();
    super.onClose();
  }
}
