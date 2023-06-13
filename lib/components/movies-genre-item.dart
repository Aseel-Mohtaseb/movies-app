import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_project_g/modules/movie-genre-examples/movie-genre-examples-page.dart';


class MoviesGenreItem extends StatelessWidget {
  String genre;
  MoviesGenreItem(this.genre);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: 65,
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.pink.shade50,
            blurRadius: 20.0,
            // offset: Offset(1, 1)
          ),
        ],
      ),
      child: GestureDetector(
        child: Card(
          // shadowColor: Colors.pink,

          child: Text(genre, style: TextStyle(fontSize: 28),textAlign: TextAlign.center,),
        ),

        onTap: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => MovieGenreExamplesPage(genre),));
          },
      ),
    );
  }
}
