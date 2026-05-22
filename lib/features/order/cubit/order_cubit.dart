//write code herepart of 'order_cubit.dart';
import 'package:e_commerce_app/features/order/cubit/order_state.dart';
import 'package:e_commerce_app/features/order/repo/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._orderRepo) : super(OrderInitial());

  final OrderRepo _orderRepo;
  void fetchOrders() async {
    emit(LoadingOrders());

    final res = await _orderRepo.getOrderSummaries();

    res.fold((error) {
      emit(ErrorOrders(error));
    }, (right) {
      emit(SuccessOrders(right));
    });
  }   }