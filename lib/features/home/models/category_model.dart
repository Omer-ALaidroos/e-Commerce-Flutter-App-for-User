
class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
  return CategoryModel(
    id: json['id'] != null ? json['id'] as int : 0, // Default to 0 if null
    name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
  );
}

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
    };
  }
}