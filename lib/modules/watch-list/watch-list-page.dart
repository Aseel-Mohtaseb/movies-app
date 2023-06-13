import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/components/watch-list-item.dart';
import 'package:movies_project_g/models/watch-list.dart';

import '../../shared/network/local/database-helper.dart';
import '../movie-details/movie-details-page.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({Key? key}) : super(key: key);

  @override
  _WatchListPageState createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch List'),
      actions: [
        IconButton(
            onPressed: () {
              DatabaseProvider.db.removeAll();
              setState(() {
              });
            },
            icon: Icon(Icons.delete),
            tooltip: "Delete all ",)
      ],),
      body: Column(
        children: [
          FutureBuilder(
            future: DatabaseProvider.db.getWatchList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<WatchList> watchList = snapshot.data as List<WatchList>;
                if (watchList.isNotEmpty) {
                  return Container(
                    height: 600,
                    child: ListView.builder(
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
                    ),
                  );
                } else {
                  return const Text('No movies in your watch list');
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
