import 'package:e_commerce_app/features/Favorite%20screen/cubit/my_favorites_state.dart';
import 'package:e_commerce_app/features/Favorite%20screen/repo/favorite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavoritesCubit extends Cubit<MyFavoritesState> {
  final FavoriteRepo _favoriteRepo;
  MyFavoritesCubit(this._favoriteRepo) : super(MyFavoritesInitial());

  Future<void> fetchFavoriteProducts() async {
    emit(MyFavoritesLoading());
    var result = await _favoriteRepo.getFavoriteProducts();
    result.fold(
      (failure) {
        emit(MyFavoritesError(failure));
      },
      (products) {
        emit(MyFavoritesLoaded(products));
      },
    );
  }
}