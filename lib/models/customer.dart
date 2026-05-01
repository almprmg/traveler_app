class Customer {
  final String? id;
  final String? mobileNumber;
  final String? type;
  final String? fullName;
  final String? email;
  final String? status;
  final String? firstName;
  final String? lastName;
  final String? profilePhoto;
  // ignore: non_constant_identifier_names - kept for API compatibility
  final DateTime? DOB;
  final Balance? balance;

  const Customer({
    this.id,
    this.mobileNumber,
    this.type,
    this.fullName,
    this.email,
    this.status,
    this.firstName,
    this.lastName,
    this.profilePhoto,
    // ignore: non_constant_identifier_names
    this.DOB,
    this.balance,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      type: json['type'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      DOB: _parseDateTime(json['DOB']),
      balance: json['balance'] != null
          ? Balance.fromJson(json['balance'] as Map<String, dynamic>)
          : null,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mobileNumber': mobileNumber,
      'type': type,
      'fullName': fullName,
      'email': email,
      'status': status,
      'firstName': firstName,
      'lastName': lastName,
      'profilePhoto': profilePhoto,
      'DOB': DOB?.toIso8601String(),
      'balance': balance?.toJson(),
    };
  }

  Customer copyWith({
    String? id,
    String? mobileNumber,
    String? type,
    String? fullName,
    String? email,
    String? status,
    String? firstName,
    String? lastName,
    String? profilePhoto,
    // ignore: non_constant_identifier_names
    DateTime? DOB,
    Balance? balance,
  }) {
    return Customer(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      type: type ?? this.type,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      DOB: DOB ?? this.DOB,
      balance: balance ?? this.balance,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, mobileNumber: $mobileNumber, type: $type, fullName: $fullName, '
        'email: $email, status: $status, firstName: $firstName, lastName: $lastName, DOB: $DOB)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer &&
        other.id == id &&
        other.mobileNumber == mobileNumber &&
        other.type == type &&
        other.fullName == fullName &&
        other.email == email &&
        other.status == status &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.DOB == DOB;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      mobileNumber,
      type,
      fullName,
      email,
      status,
      firstName,
      lastName,
      DOB,
    );
  }
}

class Balance {
  final num? money;
  final num? point;

  const Balance({this.money, this.point});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      money: json['money'] as num?,
      point: json['point'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'point': point,
    };
  }
}
