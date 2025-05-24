import 'package:news_app/model/categories_Model.dart';
import 'package:news_app/model/news_Headlines_Model.dart';
import 'package:news_app/repository/news_repository.dart';

class newsViewModel{

  static final _repo = newsRepository();

  static Future<newsHeadlinesModel> fetchNewsHeadlinesApi(String channelName) async{

    final response = await _repo.fetchNewsHeadlinesApi(channelName);
    return response;
  }

  static Future<categoriesNewsModel> fetchCategoriesNewsApi(String category) async{

    final response = await _repo.fetchCategoriesNewsApi(category);
    return response;
  }
}