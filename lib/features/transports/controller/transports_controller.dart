import 'package:get/get.dart';
import 'package:traveler_app/features/transports/model/transport_model.dart';
import 'package:traveler_app/features/transports/service/transports_service.dart';

class TransportsController extends GetxController {
  final TransportsService _service;
  TransportsController({required TransportsService service})
      : _service = service;

  final transports = <TransportListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedDestinationId = Rxn<String>();
  final selectedType = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _applyArgs();
    fetch();
  }

  void _applyArgs() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['destination_id'] != null) {
        selectedDestinationId.value = args['destination_id'].toString();
      }
      if (args['transport_type'] != null) {
        selectedType.value = args['transport_type'];
      }
    }
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      transports.value = await _service.getTransports(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        destinationId: selectedDestinationId.value,
        type: selectedType.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void search(String q) {
    searchQuery.value = q;
    fetch();
  }

  void clearFilters() {
    selectedDestinationId.value = null;
    selectedType.value = null;
    searchQuery.value = '';
    fetch();
  }
}

class TransportDetailController extends GetxController {
  final TransportsService _service;
  TransportDetailController({required TransportsService service})
      : _service = service;

  final transport = Rxn<TransportDetail>();
  final isLoading = true.obs;
  final selectedMode = ''.obs;
  String get slug => Get.arguments?['slug'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await _service.getTransportDetail(slug);
      transport.value = res;
      if (res != null && res.pricing.isNotEmpty) {
        selectedMode.value = res.pricing.keys.first;
      }
    } finally {
      isLoading.value = false;
    }
  }

  double currentPrice() {
    final t = transport.value;
    if (t == null) return 0;
    final p = t.pricing[selectedMode.value];
    if (p == null) return 0;
    return p.salePrice ?? p.price;
  }
}
