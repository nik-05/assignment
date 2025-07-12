import 'dart:convert';

enum TransactionType {
  credit('Credit'),
  debit('Debit');

  const TransactionType(this.value);
  final String value;
}

enum TransactionStatus {
  pending('Pending'),
  completed('Completed'),
  failed('Failed');

  const TransactionStatus(this.value);
  final String value;
}

class TransactionDataModel {
  final int id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;

  TransactionDataModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      id: json['id'],
      amount: json['amount'] != null ? json['amount'].toDouble() : 0.0,
      date: DateTime.parse(json['date']),
      type: TransactionType.values.byName(json['type']),
      status: TransactionStatus.values.byName(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'status': status.name,
    };
  }

  String toJsonString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

final List<TransactionDataModel> transactionData = mockData.map((Map<String, dynamic> map) => TransactionDataModel.fromJson(map)).toList();

final List<Map<String, dynamic>> mockData = [
  {
    "id": 1,
    "amount": 1250.0,
    "date": "2025-01-15T10:30:00Z",
    "type": "credit",
    "status": "completed"
  },
  {
    "id": 2,
    "amount": 750.5,
    "date": "2025-01-14T14:20:00Z",
    "type": "debit",
    "status": "pending"
  },
  {
    "id": 3,
    "amount": 2100.75,
    "date": "2025-01-13T09:15:00Z",
    "type": "credit",
    "status": "completed"
  },
  {
    "id": 4,
    "amount": 450.25,
    "date": "2025-01-12T16:45:00Z",
    "type": "debit",
    "status": "failed"
  },
  {
    "id": 5,
    "amount": 1800.0,
    "date": "2025-01-11T11:10:00Z",
    "type": "credit",
    "status": "completed"
  }
];
