/// Product rating model.
class Rate {
  final int rate;
  final int totalRate;
  final int rateCount;

  const Rate({
    required this.rate,
    required this.totalRate,
    required this.rateCount,
  });

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      rate: json['rate'] as int? ?? 0,
      totalRate: json['totalRate'] as int? ?? 0,
      rateCount: json['rateCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'totalRate': totalRate,
      'rateCount': rateCount,
    };
  }
}
