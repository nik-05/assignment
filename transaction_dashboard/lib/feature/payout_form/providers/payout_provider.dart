import 'package:flutter/material.dart';
import '../models/payout_model.dart';
import '../services/payout_storage_service.dart';

class PayoutProvider extends ChangeNotifier {
  List<PayoutModel> _payouts = [];
  bool _isLoading = false;
  String? _error;

  List<PayoutModel> get payouts => _payouts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPayouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payouts = PayoutStorageService.getAllPayouts();
      _payouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = 'Failed to load payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitPayout({
    required String beneficiaryName,
    required String accountNumber,
    required String ifscCode,
    required double amount,
  }) async {
    try {
      final payout = PayoutModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        beneficiaryName: beneficiaryName.trim(),
        accountNumber: accountNumber.trim(),
        ifscCode: ifscCode.trim().toUpperCase(),
        amount: amount,
        createdAt: DateTime.now(),
      );

      await PayoutStorageService.savePayout(payout);
      await loadPayouts();
      return true;
    } catch (e) {
      _error = 'Failed to submit payout: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> deletePayout(String id) async {
    try {
      await PayoutStorageService.deletePayout(id);
      await loadPayouts();
    } catch (e) {
      _error = 'Failed to delete payout: $e';
      notifyListeners();
    }
  }

  Future<void> updatePayoutStatus(String id, String status) async {
    try {
      await PayoutStorageService.updatePayoutStatus(id, status);
      await loadPayouts();
    } catch (e) {
      _error = 'Failed to update payout status: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 