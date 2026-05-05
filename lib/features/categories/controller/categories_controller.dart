import 'package:get/get.dart';
import 'package:traveler_app/features/categories/model/category_model.dart';
import 'package:traveler_app/features/categories/service/categories_service.dart';

class CategoriesController extends GetxController {
  final CategoriesService _service;
  CategoriesController({required CategoriesService service})
      : _service = service;

  final selectedType = 'tour'.obs;
  final group = Rxn<CategoriesGroup>();
  final isLoading = false.obs;

  static const types = ['tour', 'hotel', 'activity', 'package'];

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      group.value = await _service.getCategories(type: selectedType.value);
    } finally {
      isLoading.value = false;
    }
  }

  void selectType(String type) {
    selectedType.value = type;
    fetch();
  }
}
