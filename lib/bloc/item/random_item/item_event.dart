import 'package:meta/meta.dart';

@immutable
abstract class ItemEvent {}

class LoadAll extends ItemEvent {}

class LoadSuccess extends ItemEvent {}
