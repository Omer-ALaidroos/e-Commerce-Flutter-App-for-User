
import 'package:e_commerce_app/features/home/models/products_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  List<ProductModel> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
