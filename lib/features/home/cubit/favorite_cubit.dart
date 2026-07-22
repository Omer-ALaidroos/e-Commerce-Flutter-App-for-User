import 'package:e_commerce_app/features/home/cubit/favorite_state.dart';
import 'package:e_commerce_app/features/Favorite%20screen/repo/favorite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo _favoriteRepo;
  FavoriteCubit(this._favoriteRepo) : super(FavoriteInitial());

  Future<void> addToFavorite(int productId) async {
    emit(FavoriteLoading());
    var result = await _favoriteRepo.addToFavorite(productId);
    result.fold(
      (failure) {
        emit(FavoriteError(failure));
      },
      (_) {
        emit(FavoriteSuccess("Added to favorites successfully.",
            productId: productId, isFavorite: true));
      },
    );
  }

  Future<void> removeFromFavorite(int productId) async {
    emit(FavoriteLoading());
    var result = await _favoriteRepo.removeFromFavorite(productId);
    result.fold(
      (failure) {
        emit(FavoriteError(failure));
      },
      (_) {
        emit(FavoriteSuccess("Removed from favorites successfully.",
            productId: productId, isFavorite: false));
      },
    );
  }

  Future<void> toggleFavorite(int productId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      await removeFromFavorite(productId);
    } else {
      await addToFavorite(productId);
    }
  }
}