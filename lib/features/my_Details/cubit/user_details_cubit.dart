import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:e_commerce_app/features/my_Details/repo/user_details_repo.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UserDetailsRepo _userDetailsRepo;

  UserDetailsCubit(this._userDetailsRepo) : super(UserDetailsInitial());

  Future<void> fetchUserDetails() async {
    emit(UserDetailsLoading());
    try {
      final userDetails = await _userDetailsRepo.getUserDetails();
      emit(UserDetailsSuccess(userDetails));
    } catch (e) {
      emit(UserDetailsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}