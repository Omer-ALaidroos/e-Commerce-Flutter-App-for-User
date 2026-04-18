
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/features/home/cubit/categories_state.dart';
import 'package:e_commerce_app/features/home/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._homeRepo) : super(CategoriesInitial());
  final HomeRepo _homeRepo;
  void fetchCategories() async {
    emit(CategoriesLoading());

    final Either<String, List<String>> res = await _homeRepo.getCategories();

    res.fold((error) {
      emit(CategoriesError(error));
    }, (right) {
      emit(CategoriesLoaded(right));
    });
  }
}
