import 'package:get/get.dart';
import 'package:traveler_app/features/packages/model/package_model.dart';
import 'package:traveler_app/features/packages/service/packages_service.dart';

class PackagesController extends GetxController {
  final PackagesService _service;
  PackagesController({required PackagesService service}) : _service = service;

  final packages = <PackageListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedSort = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      packages.value = await _service.getPackages(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        sort: selectedSort.value,
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
    selectedSort.value = null;
    searchQuery.value = '';
    fetch();
  }
}

class PackageDetailController extends GetxController {
  final PackagesService _service;
  PackageDetailController({required PackagesService service})
      : _service = service;

  final pkg = Rxn<PackageDetail>();
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
      pkg.value = await _service.getPackageDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
