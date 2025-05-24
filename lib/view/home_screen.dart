import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/news_detail_controller.dart';

import 'package:news_app/model/news_Headlines_Model.dart';
import 'package:news_app/view/bookmarked_articles.dart';
import 'package:news_app/view/category_screen.dart';
import 'package:news_app/view/login_page.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_detail_screen.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

enum filterList  { thehindu, espncricinfo, thetimesofindia, cnn,  abcnews}
class _home_screenState extends State<home_screen> {

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Set<String> bookmarkedUrls = {};

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedUrls = prefs.getStringList('bookmarks')?.toSet() ?? {};
    });
  }

  Future<void> _toggleBookmark(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (bookmarkedUrls.contains(url)) {
        bookmarkedUrls.remove(url);
      } else {
        bookmarkedUrls.add(url);
      }
      prefs.setStringList('bookmarks', bookmarkedUrls.toList());
    });
  }

  //int selectedIndex=0;

  newsViewModel newsModel = newsViewModel();

  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';
  filterList? selectedValue;
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const category_screen()));
          },
          icon:  Image.asset("assets/images/category_icon.png",
          height: 30,
          width: 30
          ),
        ),
        centerTitle: true,
        title: Text("News Decks For You", 
        style: GoogleFonts.poppins(fontSize:22, fontWeight:FontWeight.w500)),

        actions: [
          PopupMenuButton<filterList>(
            initialValue: selectedValue,
            icon:const Icon(Icons.more_vert_outlined, color: Colors.black,),
            onSelected: (filterList item) {
              if(filterList.thehindu.name == item.name){
                name = 'the-hindu';
              }

               if(filterList.espncricinfo.name == item.name){
                name = 'espn-cric-info';
              }

               if(filterList.thetimesofindia.name == item.name){
                name = 'the-times-of-india';
              }

               if(filterList.cnn.name == item.name){
                name = 'cnn';
              }

               if(filterList.abcnews.name == item.name){
                name = 'abc-news';
              }

              setState(() {
                selectedValue = item;
              });

            },
            itemBuilder: (BuildContext context)
              => <PopupMenuEntry<filterList>>[
                const PopupMenuItem<filterList>(
                  value: filterList.thehindu,
                  child: Text("Hindu News")
                  ),

                  const PopupMenuItem<filterList>(
                  value: filterList.espncricinfo,
                  child: Text("ESPN Cric Info")
                  ),

                  const PopupMenuItem<filterList>(
                  value: filterList.thetimesofindia,
                  child: Text("All Times of India")
                  ),

                  const PopupMenuItem<filterList>(
                  value: filterList.cnn,
                  child: Text("CNN News")
                  ),

                  const PopupMenuItem<filterList>(
                  value: filterList.abcnews,
                  child: Text("ABC News")
                  )
          
              ]
          
            ),

            IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),


      body: 
       Column(
              children: [
            
                const SizedBox(height: 30,),
                
                SizedBox(
                  child: FutureBuilder<newsHeadlinesModel>(
                    future: newsViewModel.fetchNewsHeadlinesApi(name),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ),
                        );
                      }else{
                        return 
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              height: height * .8,
                              child: ListView.builder(
                                shrinkWrap: true,
                                                      
                                itemCount: snapshot.data!.articles!.length,
                                itemBuilder: (context, index){
                                String url = snapshot.data!.articles![index].url.toString();
                                DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                                  return Consumer<newsDetailProvider>(
                                    builder: (context, value, child) {
                                      return GestureDetector(
                                      onTap: (){
                                         String url= snapshot.data!.articles![index].url.toString();
                                       
                                        value.addItem(index, name, url);
                                        
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const home_details_screen()));
                                      },
                                      child: SizedBox(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          
                                         Container(
                                              margin:const EdgeInsets.only(bottom: 20),
                                              height: height * 0.6,
                                              width:  width * .9,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: height * .02,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) {
                                                    return Container(
                                                      child: spinkit2,
                                                    );
                                                  },
                                                
                                                  errorWidget: (context, url, error) {
                                                    return const Icon(Icons.error_outline, color: Colors.red);
                                                  },
                                                  ),
                                              ),
                                            
                                          ),


                                           Positioned(
                                              top: 3,
                                              right: 30,
                                              child: IconButton(
                                                icon: Icon(
                                                  bookmarkedUrls.contains(url)
                                                      ? Icons.bookmark
                                                      : Icons.bookmark_border,
                                                  color: bookmarkedUrls.contains(url)
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  size: 32,
                                                ),
                                                onPressed: () => _toggleBookmark(url),
                                              ),
                                            ),
                                              
                                          Positioned(
                                            bottom: 20,
                                            child: Card(
                                              elevation: 5,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                            
                                              child: Container(
                                                padding:const EdgeInsets.all(15),
                                                alignment: Alignment.bottomCenter,
                                                height: height * .22,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: width * 0.7,
                                                      child: Text(snapshot.data!.articles![index].title.toString(),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(fontSize:17, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                              
                                                    Spacer(),
                                              
                                                    Container(
                                                      width: width * 0.7,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(fontSize:13, fontWeight: FontWeight.w600),
                                                          ),
                                              
                                                          Text(
                                                          format.format(dateTime),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(fontSize:12, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                                                      ),
                                    );
                                    },
                                    
                                  );
                                }
                                                  
                                                      ),
                            ),
                          );
                      }
                    }
                    ),
                ),
            
              ],
            
      ),

      floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white,),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> BookmarkScreen()));
          },
          child: const Text("See Bookmarks",
          style: TextStyle(
            color: Colors.white
          ),),
          ),
      ),

      
        
    );
  }
}

  const spinkit2 = SpinKitFadingCircle(
     color: Colors.blue,
    size: 50,
  );