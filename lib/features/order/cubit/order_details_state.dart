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