class ReservationListItem {
  final String id;
  final String bookingNumber;
  final String productType;
  final String productName;
  final String? productImage;
  final String status;
  final double totalAmount;
  final String bookingDate;
  final String? startDate;

  ReservationListItem({
    required this.id,
    required this.bookingNumber,
    required this.productType,
    required this.productName,
    this.productImage,
    required this.status,
    required this.totalAmount,
    required this.bookingDate,
    this.startDate,
  });

  factory ReservationListItem.fromJson(Map<String, dynamic> json) {
    return ReservationListItem(
      id: json['id']?.toString() ?? '',
      bookingNumber: json['booking_number'] ?? '',
      productType: json['product_type'] ?? '',
      productName: json['product_name'] ??
          json['product']?['title'] ??
          json['product']?['name'] ??
          '',
      productImage: json['product']?['image_url'],
      status: json['status'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      bookingDate: json['booking_date'] ?? json['created_at'] ?? '',
      startDate: json['start_date'],
    );
  }
}

class ReservationDetail {
  final String id;
  final String bookingNumber;
  final String productType;
  final String productId;
  final String productName;
  final String? productImage;
  final String status;
  final double totalAmount;
  final String bookingDate;
  final String? startDate;
  final String? endDate;
  final int adults;
  final int children;
  final String? notes;
  final String? paymentStatus;
  final String? paymentMethod;
  final String contactName;
  final String contactPhone;
  final String contactEmail;

  ReservationDetail({
    required this.id,
    required this.bookingNumber,
    required this.productType,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.status,
    required this.totalAmount,
    required this.bookingDate,
    this.startDate,
    this.endDate,
    required this.adults,
    required this.children,
    this.notes,
    this.paymentStatus,
    this.paymentMethod,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
  });

  factory ReservationDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReservationDetail(
      id: data['id']?.toString() ?? '',
      bookingNumber: data['booking_number'] ?? '',
      productType: data['product_type'] ?? '',
      productId: data['product_id']?.toString() ?? '',
      productName: data['product_name'] ??
          data['product_title'] ??
          data['product']?['title'] ??
          data['product']?['name'] ??
          '',
      productImage: data['product']?['image_url'],
      status: data['status'] ?? '',
      totalAmount: (data['total_amount'] as num?)?.toDouble() ?? 0,
      bookingDate: data['booking_date'] ?? data['created_at'] ?? '',
      startDate: data['start_date'],
      endDate: data['end_date'],
      adults: (data['adults'] as num?)?.toInt() ?? 1,
      children: (data['children'] as num?)?.toInt() ?? 0,
      notes: data['notes'],
      paymentStatus: data['payment_status'],
      paymentMethod: data['payment_method'],
      contactName: data['contact_name'] ?? data['user']?['name'] ?? '',
      contactPhone: data['contact_phone'] ?? data['user']?['phone'] ?? '',
      contactEmail: data['contact_email'] ?? data['user']?['email'] ?? '',
    );
  }
}
