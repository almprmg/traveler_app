import 'package:get/get.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/service/home_service.dart';

class HomeController extends GetxController {
  final HomeService homeService;

  HomeController({required this.homeService});

  final Rx<HomeModel?> homeData = Rx(null);
  final RxBool isLoading = false.obs;
  final RxInt bannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHome();
  }

  Future<void> fetchHome() async {
    isLoading.value = true;
    homeData.value = await homeService.getHomeData();
    isLoading.value = false;
  }
}
