import 'package:meta/meta.dart';

@immutable
abstract class AllItemEvent {}

class LoadAll extends AllItemEvent {}
