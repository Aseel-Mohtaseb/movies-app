import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:movies_project_g/movie-details-page.dart';
import 'movie-item.dart';
import 'movie.dart';

class Display extends StatefulWidget {

  final String movieName;

  const Display({required this.movieName});

  @override
  DisplayState createState() => DisplayState();
}

class DisplayState extends State<Display> {

  late Future<List<Movie>> futureMovies;

  Future<List<Movie>> fetchMovies({required String movieName}) async {
      http.Response response = await http.get(
          Uri.parse("https://www.omdbapi.com/?s=$movieName&apikey=5f5d22fd"));
      if (response.statusCode != 200) {
        print(response.statusCode);
        if (response.statusCode >= 500 && response.statusCode < 600) {
          throw Exception("backend is down");
        }
        else if (response.statusCode >= 12001 && response.statusCode < 12053 ) {
          throw Exception("internet connection is not available ");
        }
        else
          throw Exception("Can't connect to server");
      }
      else {
        var jsonData = json.decode(response.body);
        try {
          List jsonArray = jsonData['Search'];
          List<Movie> movies = jsonArray.map((e) => Movie.fromJson(e)).toList();
          return movies;
        }
        catch (e) {
          Fluttertoast.showToast(msg: "No movie with name '" + movieName + "'");
          throw Exception("No movie with name '" + movieName + "'");
        }
      }

  }

  @override
  void initState() {
    super.initState();
      futureMovies = fetchMovies(movieName: widget.movieName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
          future: futureMovies,
          builder: (context, AsyncSnapshot<List<Movie>> snapshot){
            if (snapshot.hasData){
              List<Movie>? movies = snapshot.data;
              return ListView.builder(
                  itemCount: movies?.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      key: Key(movies![index].title),
                      child: MovieItem(
                              movie: movies[index],
                            ),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)
                            => MovieDetailsPage(movieId: movies[index].imdbID),)
                        );
                      },
                    );
                  });
            }
            else if (snapshot.hasError){
              // return Text("Error: " + snapshot.error.toString());
              return Text(snapshot.error.toString());
            }
            else{
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()
              );
            }
          }
      )
    );
  }
}

