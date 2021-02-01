import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/item/random_item/item_event.dart';
import 'package:mpasabuy/bloc/item/random_item/item_state.dart';

import 'package:mpasabuy/service/item_service.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(InitialState());

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    var service = new ItemService();
    try {
      if (event is LoadAll) {
        // load all items
        yield LoadAllInprogress();
        final items = await service.fetchFeaturedItem();
        yield LoadAllSuccess(items: items);
      }
    } catch (_) {
      yield LoadAllFailed();
    }
  }
}
