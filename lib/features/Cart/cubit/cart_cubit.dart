
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/Cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepo) : super(InitialCartState());

  final CartRepo _cartRepo;

  fecthCarts() async {
    emit(LoadingCarts());

    final res = await _cartRepo.getUserCart();

    res.fold((error) {
      emit(ErrorGettingCarts(error));
    }, (cart) {
      emit(SuccessGettingCarts(cart));
    });
  }

  addingToCart({required ProductModel product, required int quantity}) async {
    emit(AddingToCart());
    DateTime dateTime = DateTime.now();
    final res = await _cartRepo.addToCart(
        product: product, quantity: quantity, date: dateTime.toString());

    res.fold((error) {
      emit(ErrorAddingToCart(error));
    }, (cart) {
      emit(SuccessAddingToCarts(cart));
    });
  }
}
