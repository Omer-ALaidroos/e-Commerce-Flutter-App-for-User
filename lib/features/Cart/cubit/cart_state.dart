
import 'package:e_commerce_app/features/Cart/models/cart_model.dart';

abstract class CartState {}

class InitialCartState extends CartState {}

class LoadingCarts extends CartState {}

class SuccessGettingCarts extends CartState {
  final CartModel cart;
  SuccessGettingCarts(this.cart);
}

class ErrorGettingCarts extends CartState {
  final String message;
  ErrorGettingCarts(this.message);
}

class AddingToCart extends CartState {}

class SuccessAddingToCarts extends CartState {
  final CartModel cart;
  SuccessAddingToCarts(this.cart);
}

class ErrorAddingToCart extends CartState {
  final String message;
  ErrorAddingToCart(this.message);
}
