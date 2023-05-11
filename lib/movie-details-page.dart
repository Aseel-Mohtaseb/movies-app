import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_project_g/database-helper.dart';
import 'package:movies_project_g/movie-details.dart';
import 'package:http/http.dart' as http;
import 'package:movies_project_g/watch-list.dart';

class MovieDetailsPage extends StatefulWidget {
  final String movieId;

  MovieDetailsPage({required this.movieId});

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetails> futureMovieDetails;
  late Future<String> fullPlot;
  bool displayFullPlot = false;
  bool showActors = false;
  late bool exists;

  Future<MovieDetails> fetchMovieDetails({required String movieId}) async {
    print(movieId);
    http.Response response = await http
        .get(Uri.parse("https://www.omdbapi.com/?i=$movieId&apikey=5f5d22fd"));

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception("Can't connect to server");
    } else {
      var jsonObject = jsonDecode(response.body);
      try {
        MovieDetails movieDetails = MovieDetails.fromJson(jsonObject);

        exists = await DatabaseProvider.db.isExist(movieDetails.imdbID);

        return movieDetails;
      } catch (e) {
        throw Exception("No Movie with '" + movieId + "'");
      }
    }
  }

  Future<String> fetchFullPlot({required String movieId}) async {
    http.Response plotResponse = await http.get(Uri.parse(
        "https://www.omdbapi.com/?i=$movieId&plot=full&apikey=5f5d22fd"));
    var fullPlot = jsonDecode(plotResponse.body)['Plot'];
    return fullPlot;
  }

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails(movieId: widget.movieId);
    fullPlot = fetchFullPlot(movieId: widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movie Details'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            FutureBuilder(
              future: futureMovieDetails,
              builder: (context, AsyncSnapshot<MovieDetails> snapshot) {
                if (snapshot.hasData) {
                  MovieDetails? movieDetails = snapshot.data;
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (movieDetails!.image == 'N/A')
                              Image.asset(
                                'assets/images/default-image.jpg',
                                width: 180,
                                height: 250,
                              )
                            else
                              Image.network(
                                movieDetails.image,
                                width: 180,
                                height: 250,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text(
                                movieDetails.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () async {
                                  print(exists);
                                  if (exists) {
                                    DatabaseProvider.db
                                        .removeMovie(movieDetails.imdbID);
                                    Fluttertoast.showToast(
                                        msg: 'Removed from watch later');
                                  } else {
                                    DatabaseProvider.db.insert(WatchList(
                                        title: movieDetails.title,
                                        year: movieDetails.year,
                                        imdbRating: movieDetails.imdbRating,
                                        image: movieDetails.image,
                                        imdbID: movieDetails.imdbID,
                                        genre: movieDetails.genre));

                                    Fluttertoast.showToast(
                                        msg: 'Added to watch later');
                                  }

                                  await DatabaseProvider.db
                                      .isExist(movieDetails.imdbID)
                                      .then((value) {
                                    print("e " + value.toString());
                                    setState(() {
                                      exists = value;
                                    });
                                  });
                                },
                                icon: Icon(
                                  exists ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.pink,
                                ),

                                // tooltip: "Add to watch list",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetails.genre + " | " + movieDetails.year,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text("Director: " + movieDetails.director),
                                  Text("  |  " + movieDetails.imdbRating),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ]),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                print('show plot');
                                showActors = false;
                                setState(() {

                                });
                              },
                              child: const Text("Plot"),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                print('show actors');
                                showActors = true;
                                displayFullPlot = false;
                                setState(() {

                                });

                              },
                              child: const Text("Actors"),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),

                        showActors
                            ? Row(
                              children: [
                                Text("${movieDetails.actors}"),
                              ],
                            )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    displayFullPlot = !displayFullPlot;
                                  });
                                },
                                child: Text(displayFullPlot
                                    ? movieDetails.plot
                                    : "${movieDetails.plot}\n\nclick to see the full plot"),
                              ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder(
                future: fullPlot,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    String? fullPlot = snapshot.data;
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            displayFullPlot = !displayFullPlot;
                          });
                        },
                        child: Text(displayFullPlot ? '\n' + fullPlot! : ""),
                      ),
                    );
                  } else {
                    // return Text("Error: " + snapshot.error.toString());
                    return Text("");
                  }
                }),
          ],
        ));
  }
}
