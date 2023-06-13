class WatchList {
  String title;
  String year;
  String imdbRating;
  String image;
  String imdbID;
  String genre;

  WatchList(
      {required this.title, required this.year, required this.imdbRating,required this.image,
        required this.imdbID,required this.genre});

  factory WatchList.fromMap(Map<String, dynamic> data){
    return WatchList(
      title : data['title'],
      year  : data['year'],
      imdbRating : data['imdbRating'],
      image : data['image'],
      imdbID : data['imdbID'],
      genre : data['genre'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imdbID': this.imdbID,
      'title': this.title,
      'year': this.year,
      'imdbRating': this.imdbRating,
      'image': this.image,
      'genre': this.genre
    };
  }

}