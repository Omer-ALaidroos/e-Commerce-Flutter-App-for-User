import 'package:e_commerce_app/features/Product%20details%20screen/cubit/product_details_state.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/repo/product_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepo _productDetailsRepo;

  ProductDetailsCubit(this._productDetailsRepo)
      : super(ProductDetailsInitial());

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    final result = await _productDetailsRepo.getProductDetails(productId);
    result.fold(
      (failure) => emit(ProductDetailsError(failure)),
      (productDetails) => emit(ProductDetailsLoaded(productDetails)),
    );
  }
}