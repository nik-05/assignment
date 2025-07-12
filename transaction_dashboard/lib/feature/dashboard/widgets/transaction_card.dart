import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_dashboard/themes/app_theme.dart';

import '../models/models.dart';

class TransactionCard extends StatefulWidget {
  final TransactionDataModel data;

  const TransactionCard({super.key, required this.data});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
                         child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '₹${widget.data.amount}',
                        style: AppTheme.font.heading.h1.copyWith(color: switch(widget.data.status) {
                          TransactionStatus.pending => AppTheme.pending,
                          TransactionStatus.completed => AppTheme.success,
                          TransactionStatus.failed => AppTheme.error,
                        }),
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy').format(widget.data.date), 
                      style: AppTheme.font.body.bodyS
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              
                                 const SizedBox(height: 8),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    Text('${widget.data.type.value} - ${widget.data.status.value}', style: AppTheme.font.body.bodyM),
                    Expanded(child: Text('Transaction ID: ${widget.data.id}', style: AppTheme.font.body.bodyM, textAlign: TextAlign.end)),
                  ],
                ),
              ],
            ),
          ),
          
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SelectableText(
                      widget.data.toJsonString(),
                      style: AppTheme.font.body.bodyS.copyWith(
                        color: Colors.green[300],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

}