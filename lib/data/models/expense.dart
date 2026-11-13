class Expense {
  final String id;
  final double amount; // minor units (whole francs for XOF)
  final DateTime date;
  final String? note;
  final String paymentMethod;
  final int categoryId;
  final String? categoryLabel; // filled by JOIN queries, never stored

  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.categoryLabel,
    this.note,
    this.paymentMethod = 'cash',
  });

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
      paymentMethod: map['payment_method'] as String? ?? 'cash',
      categoryId: map['category_id'] as int,
      categoryLabel: map['category_label'] as String?,
    );
  }

  /// Only real table columns, so it can go straight into insert/update.
  Map<String, Object?> toMap() => {
    'id': id,
    'amount': amount,
    'date': date.toIso8601String(),
    'note': note,
    'payment_method': paymentMethod,
    'category_id': categoryId,
  };

  Expense copyWith({
    double? amount,
    DateTime? date,
    String? note,
    String? paymentMethod,
    int? categoryId,
    String? categoryLabel,
  }) {
    return Expense(
      id: id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      categoryId: categoryId ?? this.categoryId,
      categoryLabel: categoryLabel ?? this.categoryLabel,
    );
  }
}