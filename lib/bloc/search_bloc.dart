import 'package:bloc/bloc.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [int] as its state.
/// {@endtemplate}
class SearchCubit extends Cubit<String> {
  /// {@macro counter_cubit}
  SearchCubit() : super("");

  /// Add 1 to the current state.
  void search(String s) {
    return emit(s);
  }
}