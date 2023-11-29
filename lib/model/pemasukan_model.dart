import 'dart:convert';

class PemasukanModel {
  String? id;
  final double amount;
  final String transactionDate;
  final String description;
  PemasukanModel({
    this.id,
    required this.amount,
    required this.transactionDate,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'transactionDate': transactionDate,
      'description': description,
    };
  }

  factory PemasukanModel.fromMap(Map<String, dynamic> map) {
    return PemasukanModel(
      id: map['id'],
      amount: map['amount']?.toDouble() ?? 0.0,
      transactionDate: map['transactionDate'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PemasukanModel.fromJson(String source) =>
      PemasukanModel.fromMap(json.decode(source));
}
