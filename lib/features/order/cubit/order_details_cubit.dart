import 'package:e_commerce_app/features/order/cubit/order_details_state.dart';
import 'package:e_commerce_app/features/order/repo/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderRepo _orderRepo;
  OrderDetailsCubit(this._orderRepo) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    emit(LoadingOrderDetails());
    final result = await _orderRepo.getOrderbyOrderId(orderId);
    result.fold(
      (error) => emit(ErrorOrderDetails(error)),
      (order) => emit(SuccessOrderDetails(order)),
    );
  }
}