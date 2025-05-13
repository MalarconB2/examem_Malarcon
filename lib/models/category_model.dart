class CategoryModel {
  final int categoryId;
  final String categoryName;
  final String categoryState;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryState,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String,
      categoryState: json['category_state'] as String,
    );
  }
}
