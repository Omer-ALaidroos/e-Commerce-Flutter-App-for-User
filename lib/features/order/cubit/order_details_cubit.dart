import 'package:e_commerce_app/features/order/cubit/order_details_state.dart';
import 'package:e_commerce_app/core/services/stripe_payment_service.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/repo/cart_repo.dart';
import 'dart:developer';
import 'package:e_commerce_app/features/order/repo/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderRepo _orderRepo;
  final StripePaymentService _stripeService = sl<StripePaymentService>();
  final CartRepo _cartRepo = sl<CartRepo>();

  OrderDetailsCubit(this._orderRepo) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    emit(LoadingOrderDetails());
    final result = await _orderRepo.getOrderbyOrderId(orderId);
    result.fold(
      (error) => emit(ErrorOrderDetails(error)),
      (order) => emit(SuccessOrderDetails(order)),
    );
  }

  Future<void> pay(int orderId) async {
    emit(PaymentProcessing());
    final res = await _orderRepo.payOrder(orderId: orderId);
    await res.fold((error) async {
      emit(PaymentFailedForOrder(error));
    }, (checkoutResponse) async {
      try {
        emit(InitializingPaymentSheetForOrder());
        await _stripeService.initializePaymentSheet(
          clientSecret: checkoutResponse.clientSecret,
          merchantDisplayName: 'E-Commerce App',
        );

        emit(PresentingPaymentSheetForOrder());
        await _stripeService.presentPaymentSheet();

        emit(WaitingForPaymentConfirmationForOrder());
        final paymentResult = await _waitForPaymentCompletion(checkoutResponse.orderId);

        if (paymentResult) {
          emit(PaymentCompletedForOrder());
          await fetchOrderDetails(orderId);
        } else {
          emit(PaymentTimeoutForOrder());
        }
      } catch (e) {
        log('Payment error: $e');
        if (e.toString().toLowerCase().contains('cancel')) {
          emit(PaymentCancelledForOrder());
        } else {
          emit(PaymentFailedForOrder(e.toString()));
        }
      }
    });
  }

  Future<bool> _waitForPaymentCompletion(int orderId) async {
    const maxAttempts = 30;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final statusResult = await _cartRepo.getOrderStatus(orderId);
      if (statusResult.isRight()) {
        final status = statusResult.getOrElse(() => '');
        final normalized = status.trim().toLowerCase();
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