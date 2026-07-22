import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MyFavoritesState {}

class MyFavoritesInitial extends MyFavoritesState {}

class MyFavoritesLoading extends MyFavoritesState {}

class MyFavoritesLoaded extends MyFavoritesState {
  final List<ProductModel> products;
  MyFavoritesLoaded(this.products);
}

class MyFavoritesError extends MyFavoritesState {
  final String message;
  MyFavoritesError(this.message);
}