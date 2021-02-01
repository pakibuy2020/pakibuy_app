import 'package:meta/meta.dart';

@immutable
abstract class CartEvent {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String email;
  final int sku;
  final String qty;

  const AddToCartEvent({this.email, this.sku, this.qty});
}

class RemoveItemFromCart extends CartEvent {
  final int cartId;
  const RemoveItemFromCart({this.cartId});
}

class CheckCartItem extends CartEvent {
  final String email;
  final int sku;

  const CheckCartItem({this.email, this.sku});
}

class UpdateQty extends CartEvent {
  final int cartItemId;
  final int qty;

  const UpdateQty({this.cartItemId, this.qty});
}

class LoadCartItem extends CartEvent {
  final int cartId;
  final int size;
  final int page;
  final String email;

  const LoadCartItem({this.email, this.cartId, this.size, this.page});
}
