import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpasabuy/bloc/item/item.dart';

@immutable
abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class InitialState extends ItemState {}

class LoadAllInprogress extends ItemState {}

class LoadAllFailed extends ItemState {}

class LoadAllSuccess extends ItemState {
  final List<Item> items;

  const LoadAllSuccess({this.items});

  @override
  List<Object> get props => [items];
}
