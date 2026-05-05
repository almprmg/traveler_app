import 'package:get/get.dart';
import 'package:traveler_app/features/esim/model/esim_model.dart';
import 'package:traveler_app/features/esim/service/esim_service.dart';
import 'package:traveler_app/features/payments/model/payment_method_model.dart';
import 'package:traveler_app/features/payments/service/payments_service.dart';

class EsimBrowseController extends GetxController {
  final EsimService _service;
  EsimBrowseController({required EsimService service}) : _service = service;

  final countries = <EsimCountry>[].obs;
  final regions = <EsimRegion>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      countries.value = await _service.getCountries();
      regions.value = await _service.getRegions();
    } finally {
      isLoading.value = false;
    }
  }
}

class EsimPackagesController extends GetxController {
  final EsimService _service;
  EsimPackagesController({required EsimService service}) : _service = service;

  final packages = <EsimPackage>[].obs;
  final isLoading = false.obs;
  final filterCountry = Rxn<String>();
  final filterRegion = Rxn<String>();
  final unlimitedOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      filterCountry.value = args['country']?.toString();
      filterRegion.value = args['region']?.toString();
    }
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      packages.value = await _service.getPackages(
        country: filterCountry.value,
        region: filterRegion.value,
        unlimitedOnly: unlimitedOnly.value ? true : null,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class EsimCheckoutController extends GetxController {
  final EsimService _service;
  final PaymentsService _payments;
  EsimCheckoutController({
    required EsimService service,
    required PaymentsService payments,
  })  : _service = service,
        _payments = payments;

  final isLoading = false.obs;

  Future<List<PaymentMethod>> getMethods() => _payments.getMethods();

  Future<EsimCheckoutResult?> checkout({
    required String packageId,
    required String methodKey,
    int quantity = 1,
    String? email,
  }) async {
    isLoading.value = true;
    try {
      return await _service.checkout(
        packageId: packageId,
        methodKey: methodKey,
        quantity: quantity,
        email: email,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class EsimOrdersController extends GetxController {
  final EsimService _service;
  EsimOrdersController({required EsimService service}) : _service = service;

  final orders = <EsimOrderListItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      orders.value = await _service.getOrders();
    } finally {
      isLoading.value = false;
    }
  }
}

class EsimProfilesController extends GetxController {
  final EsimService _service;
  EsimProfilesController({required EsimService service}) : _service = service;

  final profiles = <EsimProfile>[].obs;
  final isLoading = false.obs;
  final isRefreshing = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      profiles.value = await _service.getProfiles();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile(String iccid) async {
    isRefreshing.value = iccid;
    try {
      final updated = await _service.refreshProfile(iccid);
      if (updated != null) {
        final i = profiles.indexWhere((p) => p.iccid == iccid);
        if (i >= 0) profiles[i] = updated;
      }
    } finally {
      isRefreshing.value = '';
    }
  }
}
