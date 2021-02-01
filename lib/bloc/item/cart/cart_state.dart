import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpasabuy/bloc/item/cartitem.dart';

@immutable
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartOperationSuccess extends CartState {}

class CartOperationFailed extends CartState {}

class CartCheckFound extends CartState {
  final int id;
  final int qty;

  const CartCheckFound({this.id, this.qty});
}

class CartCheckNotFound extends CartState {}

class CartItemsLoaded extends CartState {
  final List<CartItem> list;
  final bool hasReachedMax;

  const CartItemsLoaded({
    this.list,
    this.hasReachedMax,
  });
}
