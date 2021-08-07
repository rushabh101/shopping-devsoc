import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_devsoc/bloc/search_bloc.dart';
import 'package:shopping_devsoc/pages/home.dart';

class SearchBuilder extends StatelessWidget {
  const SearchBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: Home(),
    );
  }
}
