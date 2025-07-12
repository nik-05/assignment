import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transaction_dashboard/feature/dashboard/models/models.dart';
import 'package:transaction_dashboard/feature/dashboard/providers/providers.dart';
import 'package:transaction_dashboard/feature/dashboard/widgets/widgets.dart';
import 'package:transaction_dashboard/feature/payout_form/view/view.dart';
import 'package:transaction_dashboard/themes/themes.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTimeRange? _currentDateRange;
  TransactionStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Dashboard', style: AppTheme.font.heading.h1),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TransactionProvider>().refreshTransactions();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              FilterWidget(
                onFilterChanged: _onFilterChanged,
                initialDateRange: _currentDateRange,
                initialStatus: _currentStatus,
              ),
              Expanded(
                child: _buildContent(provider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PayoutFormView(),
            ),
          );
        },
        icon: const Icon(Icons.payment),
        label: const Text('Payout'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildContent(TransactionProvider provider) {
    switch (provider.state) {
      case TransactionState.initial:
        return const SizedBox.shrink();
        
      case TransactionState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
        
      case TransactionState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading transactions',
                style: AppTheme.font.heading.h3.copyWith(
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage,
                style: AppTheme.font.body.bodyM.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.fetchTransactions(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
        
      case TransactionState.loaded:
        final filteredTransactions = provider.getFilteredTransactions(
          dateRange: _currentDateRange,
          status: _currentStatus,
        );
        
        if (filteredTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions found',
                  style: AppTheme.font.heading.h3.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: AppTheme.font.body.bodyM.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => provider.refreshTransactions(),
          child: ListView.separated(
            itemCount: filteredTransactions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => TransactionCard(
              data: filteredTransactions[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        );
    }
  }

  void _onFilterChanged(DateTimeRange? dateRange, TransactionStatus? status) {
    setState(() {
      _currentDateRange = dateRange;
      _currentStatus = status;
    });
  }
}