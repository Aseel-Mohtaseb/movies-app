import 'package:flutter/material.dart';
import 'movie.dart';

class MovieItem extends StatelessWidget{
  final Movie movie;

  const MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: 120,
      child: Card(
        child: Row(
          children: [
            if(movie.image == 'N/A')
              Image.asset('assets/images/default-image.jpg', width: 100,)
            else
              Image.network(movie.image),
            Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(movie.year),
                      Text(movie.type),

                    ],
                  ),

                )
            ),
          ],
        ),
      ),
    );
  }

}

