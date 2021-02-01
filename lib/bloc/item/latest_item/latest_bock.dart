import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/item/latest_item/latest_event.dart';
import 'package:mpasabuy/bloc/item/latest_item/latest_state.dart';

import 'package:mpasabuy/service/item_service.dart';

class LatestItemBloc extends Bloc<LatestItemEvent, LatestItemState> {
  LatestItemBloc() : super(InitialState());

  @override
  Stream<LatestItemState> mapEventToState(LatestItemEvent event) async* {
    var service = new ItemService();
    try {
      if (event is LoadAllLatestItem) {
        // load all items
        yield LoadAllInprogress();
        final items = await service.fetchLatestItem();
        yield LoadAllSuccess(items: items);
      }
    } catch (_) {
      yield LoadAllFailed();
    }
  }
}
