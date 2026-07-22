
import 'dart:developer';

import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/Cart/models/cart_item_model.dart';
import 'package:e_commerce_app/features/Cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(InitialCartState());

  final CartRepo _cartRepo;

  fetchCarts() async {
    log("Fetching carts for userId before loading carts: ");
    emit(LoadingCarts());
    log("Fetching carts for userId after loading carts: ");
    final res = await _cartRepo.getUserCart();
    if (isClosed) return;
  log("Result of fetching carts for userId : $res");
    res.fold((error) {
      emit(ErrorGettingCarts(error));
    }, (cartItems) {
      emit(SuccessGettingCarts(cartItems));
    });
  }

  addingToCart({required int productId, required int quantity}) async {
    emit(AddingToCart());
    final res = await _cartRepo.addToCart(
        productId: productId,
        quantity: quantity);

    if (isClosed) return;
    res.fold((error) {
      emit(ErrorAddingToCart(error));
    }, (cartItem) {
      emit(SuccessAddingToCarts([cartItem]));
    });
  }

  removeCartItem(int cartItemId) async {
    final res = await _cartRepo.removeCartItem(cartItemId);
    if (isClosed) return;
    res.fold((error) {
      emit(ErrorGettingCarts(error)); 
    }, (successMessage) {
      fetchCarts(); 
    });
  }

  incrementQuantity(int cartItemId) async {
    final res = await _cartRepo.incrementQuantity(cartItemId);
    if (isClosed) return;
    res.fold((error) {
      emit(ErrorGettingCarts(error));
    }, (success) {
      fetchCarts();
    });
  }

  decrementQuantity(int cartItemId) async {
    final res = await _cartRepo.decrementQuantity(cartItemId);
    if (isClosed) return;
    res.fold((error) {
      emit(ErrorGettingCarts(error));
    }, (success) {
      fetchCarts();
    });
  }

  checkout({required int shippingAddressId, required int payment}) async {
    List<CartItemModel> currentItems = [];
    if (state is SuccessGettingCarts) {
      currentItems = (state as SuccessGettingCarts).cartItems;
    } else if (state is Checkout) {
      currentItems = (state as Checkout).cartItems;
    }
    emit(Checkout(currentItems));
    final res = await _cartRepo.checkout(
      shippingAddressId: shippingAddressId,
      payment: payment
    );
     
      
    if (isClosed) return;
    res.fold((error) {
      emit(ErrorCheckout(error));
    }, (successMessage) {
      emit(SuccessCheckout(successMessage));
    }); 
  }
}
