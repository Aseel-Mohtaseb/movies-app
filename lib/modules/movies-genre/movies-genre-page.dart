import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/components/movies-genre-item.dart';

class MoviesGenrePage extends StatelessWidget {
  const MoviesGenrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movies Genre",)),
      body: ListView(
        children: [
          MoviesGenreItem("Action"),
          MoviesGenreItem("Adventure"),
          MoviesGenreItem("Comedy"),
          MoviesGenreItem("Drama"),
          MoviesGenreItem("Horror"),
          MoviesGenreItem("Mystery"),
          MoviesGenreItem("Thriller"),
          MoviesGenreItem("Romance"),
          MoviesGenreItem("Fantasy"),
          MoviesGenreItem("Sci-Fi")
        ],
      ),

    );
  }
}


