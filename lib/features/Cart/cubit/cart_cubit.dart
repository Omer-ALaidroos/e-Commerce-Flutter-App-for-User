
import 'dart:async';
import 'dart:developer';

import 'package:e_commerce_app/core/services/stripe_payment_service.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/Cart/models/cart_item_model.dart';
import 'package:e_commerce_app/features/Cart/repo/cart_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(InitialCartState());

  final CartRepo _cartRepo;
  final StripePaymentService _stripeService = sl<StripePaymentService>();

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

  /// Clear the local cart state immediately (useful for optimistic UI updates
  /// after a successful payment so the cart appears empty while the backend
  /// is being reconciled).
  void clearLocalCart() {
    if (isClosed) return;
    emit(SuccessGettingCarts([]));
  }

  Future<void> checkout({required int shippingAddressId, required int payment}) async {
    List<CartItemModel> currentItems = [];
    if (state is SuccessGettingCarts) {
      currentItems = (state as SuccessGettingCarts).cartItems;
    } else if (state is Checkout) {
      currentItems = (state as Checkout).cartItems;
    }
    emit(Checkout(currentItems));
    emit(CheckoutLoading());

    final res = await _cartRepo.checkout(
      shippingAddressId: shippingAddressId,
      payment: payment,
    );

    if (isClosed) return;

    await res.fold<Future<void>>(
      (error) async {
        emit(ErrorCheckout(error));
      },
      (checkoutResponse) async {
        emit(CheckoutSuccess('Checkout initialized'));
        emit(InitializingPaymentSheet());

        try {
          await _stripeService.initializePaymentSheet(
            clientSecret: checkoutResponse.clientSecret,
            merchantDisplayName: 'E-Commerce App',
          );

          emit(PresentingPaymentSheet());
          await _stripeService.presentPaymentSheet();

          emit(WaitingForPaymentConfirmation());
          final paymentResult = await _waitForPaymentCompletion(checkoutResponse.orderId);

          if (paymentResult) {
            emit(PaymentCompleted());
          } else {
            emit(PaymentTimeout());
          }
        } catch (e) {
          if (e.toString().contains('cancel')) {
            emit(PaymentCancelled());
          } else {
            emit(PaymentFailed(e.toString()));
          }
        }
      },
    );
  }

  Future<bool> _waitForPaymentCompletion(int orderId) async {
    const maxAttempts = 30;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final statusResult = await _cartRepo.getOrderStatus(orderId);
      if (statusResult.isRight()) {
        final status = statusResult.getOrElse(() => '');
        final normalized = status.trim().toLowerCase();
        // Log for debugging
        log('Order $orderId status check (#${attempt + 1}): "$status"');
        if (normalized == 'paid' || normalized.contains('paid')) {
          return true;
        }
      }
      if (attempt < maxAttempts - 1) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return false;
  }
}
