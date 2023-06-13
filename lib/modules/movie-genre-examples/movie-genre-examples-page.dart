import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/components/watch-list-item.dart';
import 'package:movies_project_g/models/watch-list.dart';
import '../../shared/network/local/database-helper.dart';
import '../movie-details/movie-details-page.dart';

class MovieGenreExamplesPage extends StatefulWidget {
  String genre;
  MovieGenreExamplesPage(this.genre);

  @override
  _MovieGenreExamplesPageState createState() => _MovieGenreExamplesPageState();
}

class _MovieGenreExamplesPageState extends State<MovieGenreExamplesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre + ' movies'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: DatabaseProvider.db.getMovieByGenre(widget.genre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<WatchList> watchList = snapshot.data as List<WatchList>;
                if (watchList.isNotEmpty) {
                  return Container(
                    height: 500,
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
                  return Center(
                    child: Text('No ' + widget.genre + ' movies in your watch list', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, ),)
                  );

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
