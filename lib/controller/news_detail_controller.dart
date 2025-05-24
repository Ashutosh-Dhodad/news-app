import 'package:flutter/cupertino.dart';

class newsDetailProvider with ChangeNotifier{

  int selectedIndex;
  String name;
  String URL;

  newsDetailProvider({required this.selectedIndex, required this.name, required this.URL});

  void addItem(int value, String chanName, String siteUrl){
   selectedIndex=value;
   name=chanName;
   URL=siteUrl;
    notifyListeners();
  }
}