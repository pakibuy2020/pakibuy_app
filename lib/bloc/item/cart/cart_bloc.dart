import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/item/cart/cart_event.dart';
import 'package:mpasabuy/bloc/item/cart/cart_state.dart';
import 'package:mpasabuy/service/cart_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  var service = new CartService();
  CartBloc() : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    yield CartLoading();
    // add to cart event
    if (event is AddToCartEvent) {
      var email = event.email;
      var qty = event.qty;
      var sku = event.sku;

      try {
        await service.addToCart(email, sku, qty);
        yield CartOperationSuccess();
      } catch (_) {
        yield CartOperationFailed();
      }
    } else if (event is CheckCartItem) {
      // check item details from cart
      var email = event.email;
      var sku = event.sku;
      try {
        var response = await service.checkItem(email, sku);
        yield CartCheckFound(id: response.id, qty: response.qty);
      } catch (_) {
        print('returning not found item');
        yield CartCheckNotFound();
      }
    } else if (event is RemoveItemFromCart) {
      // remove item from cart
      var cartId = event.cartId;
      try {
        await service.removeItem(cartId);
        yield CartOperationSuccess();
      } catch (_) {
        yield CartOperationFailed();
      }
    } else if (event is UpdateQty) {
      var cartItemId = event.cartItemId;
      await service.updateQty(cartItemId, event.qty);
      yield CartOperationSuccess();
    } else if (event is LoadCartItem) {
      var cartItems = await service.cartItems(
          event.email, event.size, event.page, event.cartId);
      yield CartItemsLoaded(list: cartItems);
    }
  }
}
