import 'package:get/get.dart';
import 'package:traveler_app/features/visas/model/visa_model.dart';
import 'package:traveler_app/features/visas/service/visas_service.dart';

class VisasController extends GetxController {
  final VisasService _service;
  VisasController({required VisasService service}) : _service = service;

  final visas = <VisaListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCountry = Rxn<String>();
  final selectedCategory = Rxn<String>();
  final selectedMode = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _applyArgs();
    fetch();
  }

  void _applyArgs() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['country'] != null) selectedCountry.value = args['country'];
      if (args['visa_type'] != null) selectedCategory.value = args['visa_type'];
      if (args['visa_mode'] != null) selectedMode.value = args['visa_mode'];
    }
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      visas.value = await _service.getVisas(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        country: selectedCountry.value,
        category: selectedCategory.value,
        mode: selectedMode.value,
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
    selectedCountry.value = null;
    selectedCategory.value = null;
    selectedMode.value = null;
    searchQuery.value = '';
    fetch();
  }
}

class VisaDetailController extends GetxController {
  final VisasService _service;
  VisaDetailController({required VisasService service}) : _service = service;

  final visa = Rxn<VisaDetail>();
  final isLoading = true.obs;
  String get slug => Get.arguments?['slug'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      visa.value = await _service.getVisaDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
