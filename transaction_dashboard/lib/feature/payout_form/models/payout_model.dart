import 'package:hive/hive.dart';

part 'payout_model.g.dart';

@HiveType(typeId: 0)
class PayoutModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String beneficiaryName;

  @HiveField(2)
  final String accountNumber;

  @HiveField(3)
  final String ifscCode;

  @HiveField(4)
  final double amount;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String status;

  PayoutModel({
    required this.id,
    required this.beneficiaryName,
    required this.accountNumber,
    required this.ifscCode,
    required this.amount,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiaryName': beneficiaryName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'],
      beneficiaryName: json['beneficiaryName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }
} 