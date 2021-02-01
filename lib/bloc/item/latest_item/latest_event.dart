import 'package:meta/meta.dart';

@immutable
abstract class LatestItemEvent {}

class LoadAllLatestItem extends LatestItemEvent {}

class LoadLatestItemSuccess extends LatestItemEvent {}
