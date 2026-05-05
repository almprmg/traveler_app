import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/esim/model/esim_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class EsimService extends GetxService {
  final ApiClient apiClient;
  EsimService({required this.apiClient});

  List _itemsOf(dynamic data) {
    if (data is Map && data['items'] is List) return data['items'] as List;
    if (data is List) return data;
    return const [];
  }

  Future<List<EsimCountry>> getCountries() async {
    final response = await apiClient.getData(AppConstants.esimCountriesUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return _itemsOf(body['data'] ?? body)
          .whereType<Map<String, dynamic>>()
          .map(EsimCountry.fromJson)
          .toList();
    }
    return [];
  }

  Future<List<EsimRegion>> getRegions() async {
    final response = await apiClient.getData(AppConstants.esimRegionsUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return _itemsOf(body['data'] ?? body)
          .whereType<Map<String, dynamic>>()
          .map(EsimRegion.fromJson)
          .toList();
    }
    return [];
  }

  Future<List<EsimPackage>> getPackages({
    String? country,
    String? region,
    String? type,
    String? query,
    bool? unlimitedOnly,
    String? sort,
    int page = 1,
  }) async {
    final params = <String, String>{'page': page.toString()};
    if (country != null) params['country'] = country;
    if (region != null) params['region'] = region;
    if (type != null) params['type'] = type;
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (unlimitedOnly == true) params['unlimited_only'] = 'true';
    if (sort != null) params['sort'] = sort;
    final uri = Uri.parse(AppConstants.esimPackagesUrl)
        .replace(queryParameters: params)
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return _itemsOf(body['data'] ?? body)
          .whereType<Map<String, dynamic>>()
          .map(EsimPackage.fromJson)
          .toList();
    }
    return [];
  }

  Future<EsimPackage?> getPackage(String id) async {
    final response =
        await apiClient.getData(AppConstants.esimPackageDetailUrl(id));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) return EsimPackage.fromJson(data);
    }
    return null;
  }

  Future<EsimCheckoutResult?> checkout({
    required String packageId,
    int quantity = 1,
    required String methodKey,
    String? email,
  }) async {
    final body = <String, dynamic>{
      'package_id': packageId,
      'quantity': quantity,
      'method_key': methodKey,
    };
    if (email != null) body['email'] = email;
    final response =
        await apiClient.postData(AppConstants.esimCheckoutUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body0 = json.decode(response.body);
      return EsimCheckoutResult.fromJson(body0['data'] ?? body0);
    }
    return null;
  }

  Future<List<EsimOrderListItem>> getOrders({int page = 1}) async {
    final uri = Uri.parse(AppConstants.esimOrdersUrl)
        .replace(queryParameters: {'page': page.toString()})
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return _itemsOf(body['data'] ?? body)
          .whereType<Map<String, dynamic>>()
          .map(EsimOrderListItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<List<EsimProfile>> getProfiles({int page = 1}) async {
    final uri = Uri.parse(AppConstants.esimProfilesUrl)
        .replace(queryParameters: {'page': page.toString()})
        .toString();
    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return _itemsOf(body['data'] ?? body)
          .whereType<Map<String, dynamic>>()
          .map(EsimProfile.fromJson)
          .toList();
    }
    return [];
  }

  Future<EsimProfile?> getProfile(String iccid) async {
    final response =
        await apiClient.getData(AppConstants.esimProfileDetailUrl(iccid));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) return EsimProfile.fromJson(data);
    }
    return null;
  }

  Future<EsimProfile?> refreshProfile(String iccid) async {
    final response = await apiClient.postData(
      AppConstants.esimProfileRefreshUrl(iccid),
      null,
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) return EsimProfile.fromJson(data);
    }
    return null;
  }
}
