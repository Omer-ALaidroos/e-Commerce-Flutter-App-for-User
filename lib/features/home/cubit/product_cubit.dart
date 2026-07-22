import 'package:e_commerce_app/features/home/cubit/product_state.dart';
import 'package:e_commerce_app/features/home/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._homeRepo) : super(ProductInitial());

  final HomeRepo _homeRepo;

  void fetchProducts() async {
    emit(ProductLoading());

    final res = await _homeRepo.getProducts();

    res.fold((error) {
      emit(ProductError(error));
    }, (right) {
      emit(ProductLoaded(right));
    });
  }

  void fetchProductCategories(int catId) async {
    emit(ProductLoading());

    final res = await _homeRepo.getProductCategories(catId);

    res.fold((error) {
      emit(ProductError(error));
    }, (right) {
      emit(ProductLoaded(right));
    });
  }

  void searchProducts(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      emit(ProductError('Search term cannot be empty.'));
      return;
    }

    emit(ProductLoading());

    final res = await _homeRepo.searchProducts(trimmedName);

    res.fold((error) {
      emit(ProductError(error));
    }, (right) {
      emit(ProductLoaded(right));
    });
  }
}
