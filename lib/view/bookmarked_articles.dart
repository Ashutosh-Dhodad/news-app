import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> bookmarkedUrls = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedUrls = prefs.getStringList('bookmarks') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles', style: GoogleFonts.poppins()),
      ),
      body: bookmarkedUrls.isEmpty
          ? Center(child: Text('No bookmarks yet.', style: GoogleFonts.poppins()))
          : ListView.builder(
              itemCount: bookmarkedUrls.length,
              itemBuilder: (context, index) {
                final url = bookmarkedUrls[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.bookmark, color: Colors.blue),
                    title: Text(url, style: GoogleFonts.poppins(fontSize: 14)),
                    onTap: () {
                      // You can implement navigation to detail if you store more info
                    },
                  ),
                );
              },
            ),
    );
  }
}