import 'package:movies_app/models/movie.dart';

class MovieResponse {
  final List<Movie> movies;
  final String error;
  MovieResponse(this.movies, this.error);
  MovieResponse.fromJson(Map<String, dynamic> json)
      : movies =
            (json['results'] as List).map((i) => Movie.fromJson(i)).toList(),
        error = '';
  MovieResponse.withError(String errorValue)
      : error = errorValue,
        movies = List();
}
