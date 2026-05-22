//write code herepart of 'order_cubit.dart';

abstract class OrderState {}class OrderInitial extends OrderState {}

class LoadingOrders extends OrderState {}

class SuccessOrders extends OrderState {
  final List<dynamic> orders;
  SuccessOrders(this.orders);
}

class ErrorOrders extends OrderState {
  final String message;
  ErrorOrders(this.message);
}


