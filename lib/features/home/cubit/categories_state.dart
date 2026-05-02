import 'package:e_commerce_app/features/home/models/category_model.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryModel> categories;

  CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesState {
  final String error;

  CategoriesError(this.error);
}
