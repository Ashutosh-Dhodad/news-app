import 'package:flutter/material.dart';
import 'package:news_app/controller/news_detail_controller.dart';
import 'package:news_app/view/home_screen.dart';
import 'package:news_app/view/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(context) {
            return newsDetailProvider(selectedIndex: 0, name: 'general', URL: "");
          },
          )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'News App',
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return snapshot.data == true ? home_screen() : LoginPage();
          }
        },
      ),
    )
    );
  }
}
