
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/news_detail_controller.dart';
import 'package:news_app/model/categories_Model.dart';
import 'package:news_app/view/category_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class category_screen extends StatefulWidget {
  const category_screen({super.key});

  @override
  State<category_screen> createState() => category_screenState();
}

class category_screenState extends State<category_screen> {
  

  newsViewModel newsModel = newsViewModel();
  final format = DateFormat('MMMM dd');
  static String categoryName = 'general';
  static int indx=0;
  //filterList? selectedValue;

  static List<String> btnCategories = [
    'general',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

   

  
  @override
  Widget build(BuildContext context) {
   
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const home_screen()));
          },
          icon:const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: btnCategories.length,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: () {
                      setState(() {
                        
                        categoryName = btnCategories[index];
                        indx=index;

                       
                        
                      });
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(right: width * .12),
                      child: Container(
                        decoration: BoxDecoration(
                        color:categoryName == btnCategories[index] ? Colors.blue : Colors.grey,
                        borderRadius:const BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(btnCategories[index].toString(),
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),)),
                        ),
                      ),
                    ),
                  );
                }
                ),
            ),

            const SizedBox(height: 20,),

            Expanded(
              child: FutureBuilder<categoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
              
                builder: (context, snapshot){
                  log(categoryName);
                  if(snapshot.connectionState == ConnectionState.waiting){
                    log(categoryName);
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }else{
                    return ListView.builder(
                    
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index){
                     
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return 
                           Consumer<newsDetailProvider>(
                            builder: (context, value, child) {
                            
                             return GestureDetector(
                                onTap: (){
                                  
                                        final String url=snapshot.data!.articles![index].url.toString();
                                        String name=snapshot.data!.articles![index].source!.name.toString();
                                         
                                      value.addItem(index, name, url);
                                
                                
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const category_detail_screen()));
                                        },
                               child: Container(
                                margin:const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration:const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12)], borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Row(
                                    children: [
                                       ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context, url) {
                                        return Container(
                                          child:const SpinKitCircle(
                                                  size: 50,
                                                  color: Colors.blue,
                                                        ),
                                        );
                                      },
                                    
                                      errorWidget: (context, url, error) {
                                        return const Icon(Icons.error_outline, color: Colors.red);
                                      },
                                      ),
                                  ),
                               
                                  const SizedBox(width: 10,),
                               
                                  Expanded(
                                    child: Container(
                                      height: height * .18,
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color:Colors.black54,
                                            fontWeight:FontWeight.w700
                                          ),
                                          maxLines: 3,
                                          ),
                               
                               
                                         const Spacer(),
                               
                               
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color:Colors.black54,
                                                fontWeight:FontWeight.w600
                                              ),
                                              maxLines: 3,
                                              ),
                               
                                              Text(format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight:FontWeight.w500
                                              ),  
                                             ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ) 
                                    )
                                    ],
                                  ),
                                
                                                         ),
                             );
                            }
                           );
                      }
                    );
                  }
                }
                ),
            ),
          ],
        ),
      ),
    );
  }
}