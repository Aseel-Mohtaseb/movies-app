import 'package:movies_project_g/watch-list.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  static const int version = 1;
  static  Database? _database;
  static const String tableName = 'watchListTable';
  Future<Database> get database async {
    return _database ??= await initDB();
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    path += 'watch.db';
    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE $tableName (
            imdbID TEXT ,
            title TEXT,
            year TEXT,
            imdbRating TEXT,
            image TEXT,
            genre TEXT
            )
          ''');
      },

    );
  }

  Future<List<WatchList>> get getWatchList async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(tableName);
    List<WatchList> movies = [];
    for (var value in result) {
      // print(value);
      movies.add(WatchList.fromMap(value));
    }
    return movies;
  }

  Future insert(WatchList movie) async {
    final db = await database;
    return await db.insert(tableName, movie.toMap());
  }

  removeAll() async {
    final db = await database;
    db.delete(tableName);
  }

  removeMovie(String imdbID) async {
    final db = await database;
    db.delete(tableName, where: 'imdbID=?', whereArgs: [imdbID]);
  }

   Future<bool> isExist(String imdbID) async {
    final db = await database;
    List<Map<String, dynamic>> m =
    await db.query(tableName, where: 'imdbID=?' , whereArgs: [imdbID],limit: 1);
    return m.isNotEmpty;

  }

  Future<List<WatchList>> getMovieByGenre(String genre) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(tableName);
    List<WatchList> allMovies = [];
    List<WatchList> genMovies = [];

    for (var value in result) {
      allMovies.add(WatchList.fromMap(value));
    }
    for (WatchList movie in allMovies){
      List<String> genres = movie.genre.split(", ");
      print(genres);
      for (var g in genres){
        if(g == genre)
          genMovies.add(movie);
      }
    }
    return genMovies;
  }

  Future<List<WatchList>> getSearchedWatchList(String s) async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $tableName WHERE year=? OR imdbRating=?', [s, s]);
    List<WatchList> movies = [];

    for (var value in result) {
      movies.add(WatchList.fromMap(value));
    }

    //for title
    List<Map<String, dynamic>> result2 = await db.query(tableName);
    List<WatchList> allMovies = [];
    for (var value in result2) {
      allMovies.add(WatchList.fromMap(value));
    }
    for (WatchList movie in allMovies){
      List<String> title = movie.title.split(" ");
      for (var t in title){
        if(t == s)
          movies.add(movie);
      }
    }

    //for genre
    for (WatchList movie in allMovies){
      List<String> genres = movie.genre.split(", ");
      print(genres);
      for (var g in genres){
        if(g == s)
          movies.add(movie);
      }
    }

    return movies;
  }


}
