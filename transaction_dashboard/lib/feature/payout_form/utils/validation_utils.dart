class ValidationUtils {
  static String? validateBeneficiaryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Beneficiary name is required';
    }
    if (value.trim().length < 2) {
      return 'Beneficiary name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Beneficiary name must be less than 50 characters';
    }
    return null;
  }

  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    if (!RegExp(r'^\d{9,18}$').hasMatch(value.trim())) {
      return 'Account number must be 9-18 digits';
    }
    return null;
  }

  static String? validateIfscCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    final ifsc = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      return 'Invalid IFSC code format (e.g., SBIN0001234)';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount < 10) {
      return 'Amount must be at least ₹10';
    }
    
    if (amount > 100000) {
      return 'Amount cannot exceed ₹1,00,000';
    }
    
    return null;
  }

  static String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return '#4CAF50';
      case 'pending':
        return '#FF9800';
      case 'failed':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }
} 