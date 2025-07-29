import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/news_servic.dart';

part 'list_view_state.dart';

class ListVeiwCubit extends Cubit<ListVeiwState> {
  ListVeiwCubit(this.newsServic) : super(ListVeiwInitial());
  NewsServic newsServic;
  List<ArticleModel> articaList = [];
  void getNews({required String category}) async {
    emit(ListVeiwLoding());
    try {
      articaList = await newsServic.getNews(category: category);
      emit(ListVeiwSaccess());
    } on Exception catch (e) {
      emit(ListVeiwFailure());
    }
  }
}
