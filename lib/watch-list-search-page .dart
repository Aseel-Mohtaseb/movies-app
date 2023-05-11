import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/watch-list-search-result-page.dart';
import 'package:movies_project_g/carousel-slider.dart';

class WatchListSearchPage extends StatefulWidget {
  const WatchListSearchPage({Key? key}) : super(key: key);

  @override
  _WatchListSearchPageState createState() => _WatchListSearchPageState();
}

class _WatchListSearchPageState extends State<WatchListSearchPage> {
  final searchController = TextEditingController();

  bool isSearchControllerNotEmpty() {
    return searchController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search in your watch list"),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: 245,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(),
                      hintText: 'Enter something to search',
                      suffixIcon: isSearchControllerNotEmpty()
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {});
                              },
                              icon: Icon(Icons.clear),
                            )
                          : null,
                      // labelText: 'Enter something to search',
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  String movie = searchController.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchListSearchResultPage(movie),
                      ));
                },
                icon: Icon(Icons.search),
                label: Text("search"),
              ),
            ],
          ),
          // Sliderr(),
        ],
      ),
    );
  }
}
