
import 'package:e_commerce_app/features/Cart/models/cart_item_model.dart';

abstract class CartState {}

class InitialCartState extends CartState {}

class LoadingCarts extends CartState {}

class SuccessGettingCarts extends CartState {
  final List<CartItemModel> cartItems;
  SuccessGettingCarts(this.cartItems);
}

class ErrorGettingCarts extends CartState {
  final String message;
  ErrorGettingCarts(this.message);
}

class AddingToCart extends CartState {}

class SuccessAddingToCarts extends CartState {
  final List<CartItemModel> cartItems;
  SuccessAddingToCarts(this.cartItems);
}

class ErrorAddingToCart extends CartState {
  final String message;
  ErrorAddingToCart(this.message);
}

class Checkout extends CartState {
  final List<CartItemModel> cartItems;
  Checkout(this.cartItems);
}
class SuccessCheckout extends CartState {
  final String message;
  SuccessCheckout(this.message);
}

class ErrorCheckout extends CartState {
  final String message;
  ErrorCheckout(this.message);
}
