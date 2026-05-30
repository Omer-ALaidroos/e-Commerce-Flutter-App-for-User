part of 'user_details_cubit.dart';

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsSuccess extends UserDetailsState {
  final UserDetails userDetails;
  UserDetailsSuccess(this.userDetails);
}

class UserDetailsError extends UserDetailsState {
  final String message;
  UserDetailsError(this.message);
}