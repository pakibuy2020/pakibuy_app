import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/item/all_item/all_event.dart';
import 'package:mpasabuy/bloc/item/all_item/all_state.dart';

class AllItemBloc extends Bloc<AllItemEvent, AllItemsState> {
  AllItemBloc() : super(InitialState());

  @override
  Stream<AllItemsState> mapEventToState(AllItemEvent event) async* {}
}
