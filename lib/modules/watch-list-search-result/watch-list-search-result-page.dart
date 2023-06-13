import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/components/watch-list-item.dart';
import 'package:movies_project_g/models/watch-list.dart';

import '../../shared/network/local/database-helper.dart';
import '../movie-details/movie-details-page.dart';

class WatchListSearchResultPage extends StatefulWidget {
  String movie;
  WatchListSearchResultPage(this.movie);
  // const WatchListSearchResultPage({Key? key}) : super(key: key);

  @override
  _WatchListSearchResultPageState createState() => _WatchListSearchResultPageState();
}

class _WatchListSearchResultPageState extends State<WatchListSearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch List'),
        ),
      body: FutureBuilder(
            future: DatabaseProvider.db.getSearchedWatchList(widget.movie),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<WatchList> watchList = snapshot.data as List<WatchList>;
                if (watchList.isNotEmpty) {
                  return ListView.builder(
                      itemCount: watchList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          key: Key(watchList[index].title),
                          child: WatchListItem(watchList: watchList[index]),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MovieDetailsPage(movieId: watchList[index].imdbID),)
                            );
                          },
                        );
                      },
                  );
                } else {
                  return Center(
                    child: Text('No ' + widget.movie + ' movies in your watch list',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, ))
                  );
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
    );
  }
}
