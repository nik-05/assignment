import 'package:dio/dio.dart';
import 'package:transaction_dashboard/feature/dashboard/models/models.dart';
import 'package:transaction_dashboard/network/dio_client.dart';

class TransactionApiService {
  final DioClient _dioClient;

  TransactionApiService(this._dioClient);

  Future<List<TransactionDataModel>> getTransactions() async {
    try {
      final response = await _dioClient.get<List<dynamic>>('/transactions');
      
      if (response.data == null) {
        throw ApiException(500, 'No data received');
      }

      return response.data!
          .map((json) => TransactionDataModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionDataModel> getTransactionById(int id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/transactions/$id');
      
      if (response.data == null) {
        throw ApiException(404, 'Transaction not found');
      }

      return TransactionDataModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Failed to fetch transaction: $e');
    }
  }

  Future<TransactionDataModel> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/transactions',
        data: transactionData,
      );
      
      if (response.data == null) {
        throw ApiException(500, 'No data received');
      }

      return TransactionDataModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Failed to create transaction: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return ApiException(
          error.response?.statusCode ?? 500,
          error.response?.statusMessage ?? 'Unknown error',
        );
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      default:
        return NetworkException('Network error occurred');
    }
  }
} 