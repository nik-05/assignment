import 'package:flutter/material.dart';
import 'package:transaction_dashboard/feature/dashboard/models/models.dart';
import 'package:transaction_dashboard/network/transaction_api_service.dart';

enum TransactionState { initial, loading, loaded, error }

class TransactionProvider extends ChangeNotifier {
  final TransactionApiService _apiService;
  
  TransactionProvider(this._apiService);

  TransactionState _state = TransactionState.initial;
  List<TransactionDataModel> _transactions = [];
  String _errorMessage = '';
  bool _isRefreshing = false;

  TransactionState get state => _state;
  List<TransactionDataModel> get transactions => _transactions;
  String get errorMessage => _errorMessage;
  bool get isRefreshing => _isRefreshing;
  bool get isLoading => _state == TransactionState.loading;

  Future<void> fetchTransactions() async {
    if (_state == TransactionState.loading) return;

    _setState(TransactionState.loading);
    _errorMessage = '';

    try {
      final transactions = await _apiService.getTransactions();
      _transactions = transactions;
      _setState(TransactionState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(TransactionState.error);
    }
  }

  Future<void> refreshTransactions() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      final transactions = await _apiService.getTransactions();
      _transactions = transactions;
      _errorMessage = '';
      _setState(TransactionState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(TransactionState.error);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final newTransaction = await _apiService.createTransaction(transactionData);
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(TransactionState.error);
    }
  }

  List<TransactionDataModel> getFilteredTransactions({
    DateTimeRange? dateRange,
    TransactionStatus? status,
  }) {
    return _transactions.where((transaction) {
      if (dateRange != null) {
        final transactionDate = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        final startDate = DateTime(
          dateRange.start.year,
          dateRange.start.month,
          dateRange.start.day,
        );
        final endDate = DateTime(
          dateRange.end.year,
          dateRange.end.month,
          dateRange.end.day,
        );
        
        if (transactionDate.isBefore(startDate) || transactionDate.isAfter(endDate)) {
          return false;
        }
      }

      if (status != null && transaction.status != status) {
        return false;
      }

      return true;
    }).toList();
  }

  void clearError() {
    _errorMessage = '';
    if (_state == TransactionState.error) {
      _setState(TransactionState.initial);
    }
    notifyListeners();
  }

  void _setState(TransactionState state) {
    _state = state;
    notifyListeners();
  }
} 