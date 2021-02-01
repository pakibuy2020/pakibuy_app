import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpasabuy/bloc/item/item.dart';

@immutable
abstract class LatestItemState extends Equatable {
  const LatestItemState();

  @override
  List<Object> get props => [];
}

class InitialState extends LatestItemState {}

class LoadAllInprogress extends LatestItemState {}

class LoadAllFailed extends LatestItemState {}

class LoadAllSuccess extends LatestItemState {
  final List<Item> items;

  const LoadAllSuccess({this.items});

  @override
  List<Object> get props => [items];
}
