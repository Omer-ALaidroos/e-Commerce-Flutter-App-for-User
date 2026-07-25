import 'package:e_commerce_app/features/order/models/order_model.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class LoadingOrderDetails extends OrderDetailsState {}

class SuccessOrderDetails extends OrderDetailsState {
  final OrderModel order;
  SuccessOrderDetails(this.order);
}

class ErrorOrderDetails extends OrderDetailsState {
  final String message;
  ErrorOrderDetails(this.message);
}

class PaymentProcessing extends OrderDetailsState {}

class InitializingPaymentSheetForOrder extends OrderDetailsState {}

class PresentingPaymentSheetForOrder extends OrderDetailsState {}

class WaitingForPaymentConfirmationForOrder extends OrderDetailsState {}

class PaymentCompletedForOrder extends OrderDetailsState {}

class PaymentCancelledForOrder extends OrderDetailsState {}

class PaymentFailedForOrder extends OrderDetailsState {
  final String message;
  PaymentFailedForOrder(this.message);
}

class PaymentTimeoutForOrder extends OrderDetailsState {}