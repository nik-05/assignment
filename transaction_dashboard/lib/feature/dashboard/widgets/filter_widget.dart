import 'package:flutter/material.dart';
import 'package:transaction_dashboard/feature/dashboard/models/models.dart';
import 'package:transaction_dashboard/themes/app_theme.dart';

class FilterWidget extends StatefulWidget {
  final Function(DateTimeRange? dateRange, TransactionStatus? status) onFilterChanged;
  final DateTimeRange? initialDateRange;
  final TransactionStatus? initialStatus;

  const FilterWidget({
    super.key,
    required this.onFilterChanged,
    this.initialDateRange,
    this.initialStatus,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  DateTimeRange? _selectedDateRange;
  TransactionStatus? _selectedStatus;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange;
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildFilterContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: AppTheme.textColor.tertiary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Filters',
              style: AppTheme.font.heading.h3.copyWith(
                color: AppTheme.textColor.primary,
              ),
            ),
            const Spacer(),
            _buildActiveFiltersCount(),
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppTheme.textColor.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersCount() {
    int activeCount = 0;
    if (_selectedDateRange != null) activeCount++;
    if (_selectedStatus != null) activeCount++;

    if (activeCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.textColor.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$activeCount',
        style: AppTheme.font.body.bodyM.copyWith(
          color: AppTheme.textColor.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildDateRangeFilter(),
          const SizedBox(height: 20),

          _buildStatusFilter(),
          const SizedBox(height: 20),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: AppTheme.font.heading.h3.copyWith(
            color: AppTheme.textColor.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _showDateRangePicker,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.textColor.tertiary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedDateRange != null
                          ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                          : 'Select date range',
                      style: AppTheme.font.body.bodyM.copyWith(
                        color: _selectedDateRange != null
                            ? AppTheme.textColor.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                  if (_selectedDateRange != null)
                    IconButton(
                      onPressed: _clearDateRange,
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: AppTheme.font.heading.h3.copyWith(
            color: AppTheme.textColor.primary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TransactionStatus.values.map((status) {
            final isSelected = _selectedStatus == status;
            return _buildStatusChip(status, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusChip(TransactionStatus status, bool isSelected) {
    Color chipColor;
    Color textColor;
    
    switch (status) {

      case TransactionStatus.completed:
        chipColor = isSelected ? AppTheme.success : AppTheme.success.withOpacity(0.1);
        textColor = isSelected ? Colors.white : AppTheme.success;
        break;
      case TransactionStatus.pending:
        chipColor = isSelected ? AppTheme.pending : AppTheme.pending.withOpacity(0.1);
        textColor = isSelected ? Colors.white : AppTheme.pending;
        break;
      case TransactionStatus.failed:
        chipColor = isSelected ? AppTheme.error : AppTheme.error.withOpacity(0.1);
        textColor = isSelected ? Colors.white : AppTheme.error;
        break;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = isSelected ? null : status;
        });
        _applyFilters();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : textColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 16,
              color: textColor,
            ),
            const SizedBox(width: 6),
            Text(
              status.name.toUpperCase(),
              style: AppTheme.font.body.bodyM.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Icons.check_circle;
      case TransactionStatus.pending:
        return Icons.schedule;
      case TransactionStatus.failed:
        return Icons.error;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _clearAllFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Text(
              'Clear All',
              style: AppTheme.font.body.bodyM.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.textColor.tertiary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: AppTheme.font.body.bodyM.copyWith(
                color: AppTheme.textColor.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.textColor.tertiary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
    });
    _applyFilters();
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedStatus = null;
    });
    _applyFilters();
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedDateRange, _selectedStatus);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}