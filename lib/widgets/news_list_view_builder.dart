import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/widgets/newes_list_viwes.dart';


class NewsListViewBuilder extends StatelessWidget {
  final String category;

  const NewsListViewBuilder({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    context.read<ListVeiwCubit>().getNews(category: category);

    return BlocBuilder<ListVeiwCubit, ListVeiwState>(
      builder: (context, state) {
        if (state is ListVeiwLoding) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ListVeiwSaccess) {
          return NewesListViwes(
            articles: context.read<ListVeiwCubit>().articaList,
          );
        } else if (state is ListVeiwFailure) {
          return const SliverToBoxAdapter(
            child: Text('Oops! An error occurred, please try again later.'),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Text('Unexpected state'),
          );
        }
      },
    );
  }
}
