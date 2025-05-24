import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/categories_Model.dart';
import 'package:news_app/model/news_Headlines_Model.dart';
class newsRepository{

  Future<newsHeadlinesModel> fetchNewsHeadlinesApi(String channelName) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=e2b4afc8b9594eb599c5041d8b8466c7";

    final response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return newsHeadlinesModel.fromJson(body);
    }

    throw Exception('error');

  }

  Future<categoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=e2b4afc8b9594eb599c5041d8b8466c7";

    final response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return categoriesNewsModel.fromJson(body);
    }

    throw Exception('error');

  }
}
