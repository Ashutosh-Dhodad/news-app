

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/controller/news_detail_controller.dart';
import 'package:news_app/model/categories_Model.dart';
import 'package:news_app/view/category_screen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class category_detail_screen extends StatefulWidget {
  const category_detail_screen({super.key});

  @override
  State<category_detail_screen> createState() => details_screenState();
}

class details_screenState extends State<category_detail_screen> {

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<newsDetailProvider>(context);
    final  websiteUri = Uri.parse(newsProvider.URL);
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
   
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const category_screen()));
          },
          icon:const Icon(Icons.arrow_back_ios)),
      ),

      body: Column(
        children: [
          SizedBox(
            child:  FutureBuilder<categoriesNewsModel>(
                    
                    future: newsViewModel.fetchCategoriesNewsApi(category_screenState.btnCategories[category_screenState.indx].toString()),
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
                                                      
                                itemCount:1,
                                itemBuilder: (context, index){
                                //DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                                  return Consumer<newsDetailProvider?>(
                                    builder: (context, value, child) {
                                    log(snapshot.data!.articles![index].urlToImage.toString());
                                      return GestureDetector(
                                      
                                      child: SizedBox(
                                      child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                         Container(
                                              margin:const EdgeInsets.only(bottom: 20),
                                              height: height * 0.4,
                                              width:  width * .99,
                                             
                                              child: ClipRRect(
                                                
                                                child: CachedNetworkImage(
                                                  imageUrl:snapshot.data!.articles![newsProvider.selectedIndex].urlToImage.toString(),
                                              
                                                
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

                                           SizedBox(
                                               height: height * .7,
                                               
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:const EdgeInsets.only(left: 30),
                                                      width: width * 0.9,
                                                      child: Text(snapshot.data!.articles![newsProvider.selectedIndex].title.toString(),

                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(fontSize:20, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),

                                                    Container(
                                                      margin:const EdgeInsets.only(left: 30, right: 30, top: 10),
                                                      child: Text(snapshot.data!.articles![newsProvider.selectedIndex].content.toString(),
                                                      maxLines: 10,
                                                      style:const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                                                        color: Color.fromARGB(255, 137, 135, 135)
                                                      ),),
                                                      
                                                    ),
                                              
                                                    
                                                  ],
                                                ),
                                              ),
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
          )
        ],
      ),

      floatingActionButton: Container(
        margin:const EdgeInsets.only(bottom: 20),
        height: 40,
        width: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
           setState(() {
            
              launchUrl(
                websiteUri,
                mode: LaunchMode.externalApplication,
              );
           });
             
        
          },
        
          child: const Text("Tap to know more",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),),
          ),
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}