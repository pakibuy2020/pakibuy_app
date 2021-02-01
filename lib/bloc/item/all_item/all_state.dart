import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AllItemsState extends Equatable {
  const AllItemsState();

  @override
  List<Object> get props => [];
}

class InitialState extends AllItemsState {}

class ItemsLoaded extends AllItemsState {}
