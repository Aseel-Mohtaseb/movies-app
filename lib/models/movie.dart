class Movie {
  String title;
  String year;
  String type;
  String image;
  String imdbID;

  Movie({required this.title, required this.year, required this.type, required this.image, required this.imdbID});

  factory Movie.fromJson(dynamic jsonObject){
    return Movie(
        title: jsonObject['Title'],
        year: jsonObject['Year'],
        type: jsonObject['Type'],
        image: jsonObject['Poster'],
        imdbID: jsonObject['imdbID']
    );
  }

}