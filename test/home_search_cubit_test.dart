import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/home/cubit/product_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/product_state.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:e_commerce_app/features/home/repo/home_repo.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRepo extends HomeRepo {
  FakeHomeRepo() : super(DioHelper());

  @override
  Future<Either<String, List<ProductModel>>> searchProducts(String name) async {
    if (name.toLowerCase() == 'shirt') {
      return Right([
        ProductModel(
          id: 1,
          name: 'Shirt',
          price: 12.0,
          PrimaryImageUrl: '',
        ),
      ]);
    }
    return Left('No products found');
  }
}

void main() {
  test('searchProducts emits loaded state for matching results', () async {
    final cubit = ProductCubit(FakeHomeRepo());
    final states = <ProductState>[];
    final subscription = cubit.stream.listen(states.add);

    cubit.searchProducts('shirt');

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(states.first, isA<ProductLoading>());
    expect(states.last, isA<ProductLoaded>());

    await subscription.cancel();
    await cubit.close();
  });
}
