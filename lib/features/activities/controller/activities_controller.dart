import 'package:get/get.dart';
import 'package:traveler_app/features/activities/model/activity_model.dart';
import 'package:traveler_app/features/activities/service/activities_service.dart';

class ActivitiesController extends GetxController {
  final ActivitiesService _service;

  ActivitiesController({required ActivitiesService service})
      : _service = service;

  final activities = <ActivityListItem>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedDestinationId = Rxn<String>();
  final selectedSort = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _applyArgs();
    fetch();
  }

  void _applyArgs() {
    final args = Get.arguments;
    if (args is Map) {
      final destId = args['destination_id'];
      if (destId != null) selectedDestinationId.value = destId.toString();
    }
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final result = await _service.getActivities(
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        destinationId: selectedDestinationId.value,
        sort: selectedSort.value,
      );
      activities.value = result;
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
    selectedSort.value = null;
    searchQuery.value = '';
    fetch();
  }
}

class ActivityDetailController extends GetxController {
  final ActivitiesService _service;
  ActivityDetailController({required ActivitiesService service})
      : _service = service;

  final activity = Rxn<ActivityDetail>();
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
      activity.value = await _service.getActivityDetail(slug);
    } finally {
      isLoading.value = false;
    }
  }
}
