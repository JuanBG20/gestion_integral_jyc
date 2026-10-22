class ExpenseCategoryEntity {
  final int? id;
  final String name;

  ExpenseCategoryEntity({this.id, required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseCategoryEntity &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
