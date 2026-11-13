class CategoryTotal {
  final int categoryId;
  final String label;
  final double total;

  const CategoryTotal({
    required this.categoryId,
    required this.label,
    required this.total,
  });

  factory CategoryTotal.fromMap(Map<String, Object?> map) => CategoryTotal(
    categoryId: map['category_id'] as int,
    label: map['label'] as String,
    total: (map['total'] as double?) ?? 0.0,
  );
}