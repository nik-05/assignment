import 'package:hive_flutter/hive_flutter.dart';
import '../models/payout_model.dart';

class PayoutStorageService {
  static const String _boxName = 'payouts';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PayoutModelAdapter());
    await Hive.openBox<PayoutModel>(_boxName);
  }

  static Future<void> savePayout(PayoutModel payout) async {
    final box = Hive.box<PayoutModel>(_boxName);
    await box.add(payout);
  }

  static List<PayoutModel> getAllPayouts() {
    final box = Hive.box<PayoutModel>(_boxName);
    return box.values.toList();
  }

  static Future<void> deletePayout(String id) async {
    final box = Hive.box<PayoutModel>(_boxName);
    final index = box.values.toList().indexWhere((payout) => payout.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  static Future<void> updatePayoutStatus(String id, String status) async {
    final box = Hive.box<PayoutModel>(_boxName);
    final index = box.values.toList().indexWhere((payout) => payout.id == id);
    if (index != -1) {
      final payout = box.getAt(index);
      if (payout != null) {
        final updatedPayout = PayoutModel(
          id: payout.id,
          beneficiaryName: payout.beneficiaryName,
          accountNumber: payout.accountNumber,
          ifscCode: payout.ifscCode,
          amount: payout.amount,
          createdAt: payout.createdAt,
          status: status,
        );
        await box.putAt(index, updatedPayout);
      }
    }
  }

  static Future<void> clearAllPayouts() async {
    final box = Hive.box<PayoutModel>(_boxName);
    await box.clear();
  }

  static Future<void> addSampleData() async {
    final box = Hive.box<PayoutModel>(_boxName);
    if (box.isEmpty) {
      final samplePayouts = [
        PayoutModel(
          id: '1',
          beneficiaryName: 'Nik J',
          accountNumber: '1234567890',
          ifscCode: 'SBIN0001234',
          amount: 5000.0,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'completed',
        ),
        PayoutModel(
          id: '2',
          beneficiaryName: 'Nik J',
          accountNumber: '0987654321',
          ifscCode: 'HDFC0005678',
          amount: 15000.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'pending',
        ),
        PayoutModel(
          id: '3',
          beneficiaryName: 'Nik J',
          accountNumber: '1122334455',
          ifscCode: 'ICIC0009999',
          amount: 25000.0,
          createdAt: DateTime.now(),
          status: 'pending',
        ),
      ];

      for (final payout in samplePayouts) {
        await box.add(payout);
      }
    }
  }
} 