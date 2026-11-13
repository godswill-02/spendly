class ExpenseCategory {
  final int? id;
  final String label;

  const ExpenseCategory({
        this.id,
        required this.label
      });

  factory ExpenseCategory.fromMap(Map<String, Object?> map) {
    return ExpenseCategory(
      id: map['id'] as int?,
      label: map['label'] as String,
    );
  }

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'label': label,
  };

  ExpenseCategory copyWith({int? id, String? label}) =>
      ExpenseCategory(
          id: id ?? this.id,
          label: label ?? this.label
      );
}