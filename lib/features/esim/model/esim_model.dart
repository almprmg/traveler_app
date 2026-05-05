class EsimCountry {
  final String code;
  final String name;
  final String? flagUrl;
  final int packagesCount;
  final double minPrice;
  final double maxPrice;

  EsimCountry({
    required this.code,
    required this.name,
    this.flagUrl,
    required this.packagesCount,
    required this.minPrice,
    required this.maxPrice,
  });

  factory EsimCountry.fromJson(Map<String, dynamic> json) => EsimCountry(
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        flagUrl: json['flag_url']?.toString(),
        packagesCount: (json['packages_count'] as num?)?.toInt() ?? 0,
        minPrice: (json['min_price'] as num?)?.toDouble() ?? 0,
        maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0,
      );
}

class EsimRegion {
  final String type;
  final String slug;
  final String name;
  final int packagesCount;
  final double minPrice;
  final double maxPrice;

  EsimRegion({
    required this.type,
    required this.slug,
    required this.name,
    required this.packagesCount,
    required this.minPrice,
    required this.maxPrice,
  });

  factory EsimRegion.fromJson(Map<String, dynamic> json) => EsimRegion(
        type: json['type']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        packagesCount: (json['packages_count'] as num?)?.toInt() ?? 0,
        minPrice: (json['min_price'] as num?)?.toDouble() ?? 0,
        maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0,
      );
}

class EsimPackage {
  final String id;
  final String title;
  final String? data;
  final String? days;
  final double price;
  final String currency;
  final String? countryCode;
  final String? countryName;
  final bool isUnlimited;

  EsimPackage({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.isUnlimited,
    this.data,
    this.days,
    this.countryCode,
    this.countryName,
  });

  factory EsimPackage.fromJson(Map<String, dynamic> json) => EsimPackage(
        id: (json['id'] ?? json['package_id'] ?? json['airalo_id'])
                ?.toString() ??
            '',
        title: json['title']?.toString() ?? '',
        data: json['data']?.toString() ?? json['data_volume']?.toString(),
        days: json['days']?.toString() ?? json['validity_days']?.toString(),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        currency: json['currency']?.toString() ?? 'USD',
        countryCode:
            json['country_code']?.toString() ?? json['country']?.toString(),
        countryName: json['country_name']?.toString(),
        isUnlimited: json['is_unlimited'] as bool? ?? false,
      );
}

class EsimOrderListItem {
  final String orderNumber;
  final String packageTitle;
  final String? countryCode;
  final int quantity;
  final double totalAmount;
  final String currency;
  final String paymentStatus;
  final String provisionStatus;
  final int profilesCount;
  final String createdAt;

  EsimOrderListItem({
    required this.orderNumber,
    required this.packageTitle,
    required this.quantity,
    required this.totalAmount,
    required this.currency,
    required this.paymentStatus,
    required this.provisionStatus,
    required this.profilesCount,
    required this.createdAt,
    this.countryCode,
  });

  factory EsimOrderListItem.fromJson(Map<String, dynamic> json) =>
      EsimOrderListItem(
        orderNumber: json['order_number']?.toString() ?? '',
        packageTitle: json['package_title']?.toString() ?? '',
        countryCode: json['country_code']?.toString(),
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
        currency: json['currency']?.toString() ?? 'USD',
        paymentStatus: json['payment_status']?.toString() ?? '',
        provisionStatus: json['provision_status']?.toString() ?? '',
        profilesCount: (json['profiles_count'] as num?)?.toInt() ?? 0,
        createdAt: json['created_at']?.toString() ?? '',
      );
}

class EsimProfile {
  final String iccid;
  final String? matchingId;
  final String? activationCode;
  final String? qrCode;
  final String status;
  final int dataUsedMb;
  final int dataRemainingMb;
  final String? lastSyncedAt;
  final String? packageTitle;
  final String? countryCode;

  EsimProfile({
    required this.iccid,
    required this.status,
    required this.dataUsedMb,
    required this.dataRemainingMb,
    this.matchingId,
    this.activationCode,
    this.qrCode,
    this.lastSyncedAt,
    this.packageTitle,
    this.countryCode,
  });

  factory EsimProfile.fromJson(Map<String, dynamic> json) => EsimProfile(
        iccid: json['iccid']?.toString() ?? '',
        matchingId: json['matching_id']?.toString(),
        activationCode: json['activation_code']?.toString(),
        qrCode: json['qr_code']?.toString() ?? json['qr_code_url']?.toString(),
        status: json['status']?.toString() ?? '',
        dataUsedMb: (json['data_used_mb'] as num?)?.toInt() ?? 0,
        dataRemainingMb: (json['data_remaining_mb'] as num?)?.toInt() ?? 0,
        lastSyncedAt: json['last_synced_at']?.toString(),
        packageTitle: json['package_title']?.toString(),
        countryCode: json['country_code']?.toString(),
      );

  double get usagePercent {
    final total = dataUsedMb + dataRemainingMb;
    if (total <= 0) return 0;
    return dataUsedMb / total;
  }
}

class EsimCheckoutResult {
  final String orderNumber;
  final String orderId;
  final double amount;
  final String currency;
  final String? paymentToken;
  final String paymentIframe;

  EsimCheckoutResult({
    required this.orderNumber,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentIframe,
    this.paymentToken,
  });

  factory EsimCheckoutResult.fromJson(Map<String, dynamic> json) =>
      EsimCheckoutResult(
        orderNumber: json['order_number']?.toString() ?? '',
        orderId: json['order_id']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        currency: json['currency']?.toString() ?? 'USD',
        paymentToken: json['payment_token']?.toString(),
        paymentIframe: json['payment_iframe']?.toString() ?? '',
      );
}
