import 'package:dio/dio.dart';
import 'package:movies_app/models/cast_response.dart';
import 'package:movies_app/models/genre_responses.dart';
import 'package:movies_app/models/movie_detail_response.dart';
import 'package:movies_app/models/movie_response.dart';
import 'package:movies_app/models/person_response.dart';
import 'package:movies_app/models/video_response.dart';

class MovieRepository {
  final String apiKey = '4da68b03a9557052d296e5d4450895b4';
  static String mainUrl = 'https://api.themoviedb.org/3';
  final Dio _dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMovieUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenreUrl = '$mainUrl/genre/movie/list';
  var getPersonsUrl = '$mainUrl/trending/person/week';
  var movieUrl = '$mainUrl/movie';

  Future<MovieResponse> getMovies() async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1,
    };
    try {
      Response response =
          await _dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return MovieResponse.withError('$error');
    }
  }

  Future<MovieResponse> getPlaying() async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1,
    };
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return MovieResponse.withError('$error');
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1,
    };
    try {
      Response response = await _dio.get(getGenreUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return GenreResponse.withError('$error');
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      'api_key': apiKey,
    };
    try {
      Response response =
          await _dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return PersonResponse.withError('$error');
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1,
      'with_genres': id,
    };
    try {
      Response response = await _dio.get(getMovieUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return MovieResponse.withError('$error');
    }
  }

  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try {
      Response response =
          await _dio.get(movieUrl + '/$id', queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return MovieDetailResponse.withError('$error');
    }
  }

  Future<CastResponse> getCast(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };

    try {
      Response response = await _dio.get(movieUrl + '/$id' + '/credits',
          queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return CastResponse.withError('$error');
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };

    try {
      Response response = await _dio.get(movieUrl + '/$id' + '/similar',
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return MovieResponse.withError('$error');
    }
  }

  Future<VideoResponse> getVideo(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };

    try {
      Response response = await _dio.get(movieUrl + '/$id' + '/videos',
          queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Exception Occured: $error stackTrace: $stackTrace');
      return VideoResponse.withError('$error');
    }
  }
}
