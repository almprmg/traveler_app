import 'package:get/get.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/features/tours/service/tours_service.dart';

class ToursController extends GetxController {
  final ToursService _service;

  ToursController({required ToursService service}) : _service = service;

  final tours = <TourListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategoryId = Rxn<String>();
  final selectedDestinationId = Rxn<String>();
  final selectedDestinationName = Rxn<String>();
  final selectedTourType = Rxn<String>();
  final selectedMonth = Rxn<DateTime>();
  final selectedDuration = Rxn<String>();
  final selectedSort = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final result = await _service.getTours(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        categoryId: selectedCategoryId.value,
        destinationId: selectedDestinationId.value,
        sort: selectedSort.value,
      );
      tours.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters({
    String? categoryId,
    String? destinationId,
    String? sort,
  }) {
    selectedCategoryId.value = categoryId;
    selectedDestinationId.value = destinationId;
    selectedSort.value = sort;
    fetch();
  }

  void search(String q) {
    searchQuery.value = q;
    fetch();
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    selectedDestinationId.value = null;
    selectedDestinationName.value = null;
    selectedTourType.value = null;
    selectedMonth.value = null;
    selectedDuration.value = null;
    selectedSort.value = null;
    searchQuery.value = '';
    fetch();
  }
}
