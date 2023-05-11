class MovieDetails {
  String title;
  String year;
  String imdbRating;
  String image;
  String imdbID;
  String genre;
  String writer;
  String director;
  String actors;
  String plot;

  MovieDetails(
      {required this.title, required this.year, required this.imdbRating,required this.image,
        required this.imdbID,required this.genre,required this.writer,required this.director,
        required this.actors,required this.plot});

  factory MovieDetails.fromJson(dynamic jsonObject){
    return MovieDetails(
        title: jsonObject['Title'],
        year: jsonObject['Year'],
        imdbRating: jsonObject['imdbRating'],
        image: jsonObject['Poster'],
        imdbID: jsonObject['imdbID'],
        genre: jsonObject['Genre'],
        writer: jsonObject['Writer'],
        director: jsonObject['Director'],
        actors: jsonObject['Actors'],
        plot: jsonObject['Plot']
    );
  }
}