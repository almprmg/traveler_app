class WalletBalance {
  final double balance;
  final double totalDeposited;
  final double totalSpent;
  final String currency;

  WalletBalance({
    required this.balance,
    required this.totalDeposited,
    required this.totalSpent,
    required this.currency,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        totalDeposited: (json['total_deposited'] as num?)?.toDouble() ?? 0,
        totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
        currency: json['currency']?.toString() ?? 'USD',
      );
}

class WalletTransaction {
  final String id;
  final String type;
  final double amount;
  final String? paymentMethod;
  final String? transactionId;
  final String? details;
  final String status;
  final String currency;
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.currency,
    required this.createdAt,
    this.paymentMethod,
    this.transactionId,
    this.details,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: json['id']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ??
            (json['total_amount'] as num?)?.toDouble() ??
            0,
        paymentMethod: json['payment_method']?.toString(),
        transactionId: json['transaction_id']?.toString(),
        details: json['details']?.toString(),
        status: json['status']?.toString() ?? '',
        currency: json['currency']?.toString() ?? 'USD',
        createdAt: json['created_at']?.toString() ?? '',
      );

  bool get isCredit => type.toLowerCase() == 'deposit' || amount > 0;
}

class WalletDepositInitiation {
  final String walletId;
  final double amount;
  final String? clientSecret;
  final String? publicKey;
  final String paymentUrl;

  WalletDepositInitiation({
    required this.walletId,
    required this.amount,
    required this.paymentUrl,
    this.clientSecret,
    this.publicKey,
  });

  factory WalletDepositInitiation.fromJson(Map<String, dynamic> json) =>
      WalletDepositInitiation(
        walletId: json['wallet_id']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        clientSecret: json['client_secret']?.toString(),
        publicKey: json['public_key']?.toString(),
        paymentUrl: json['payment_url']?.toString() ?? '',
      );
}
