part of 'edit_cubit.dart';

abstract class EditState {}

class EditInitial extends EditState {}

class EditLoading extends EditState {}

class EditSuccess extends EditState {
 
  final String message;
  EditSuccess( this.message);
}

class EditError extends EditState {
  final String message;
  EditError(this.message);
}