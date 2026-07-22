import 'package:flutter/material.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final String message;
  final int productId;
  final bool isFavorite;

  FavoriteSuccess(this.message, {required this.productId, required this.isFavorite});
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}