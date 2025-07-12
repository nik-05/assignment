import 'package:flutter/material.dart';
import '../widgets/payout_form_widget.dart';
import '../widgets/payout_history_widget.dart';

class PayoutFormView extends StatefulWidget {
  const PayoutFormView({super.key});

  @override
  State<PayoutFormView> createState() => _PayoutFormViewState();
}

class _PayoutFormViewState extends State<PayoutFormView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payout Management'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.onPrimary,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          tabs: const [
            Tab(
              icon: Icon(Icons.payment),
              text: 'New Payout',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'History',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PayoutFormWidget(),
          PayoutHistoryWidget(),
        ],
      ),
    );
  }
} 