import '../repository/movie_repository.dart';
import '../models/movie_response.dart';
import 'package:rxdart/rxdart.dart';

class SearchMoviesBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovies(String movieName) async {
    MovieResponse response = await _repository.getSearchMovies(movieName);
    _subject.sink.add(response);
  }

  drainStream() {
    _subject.value = null;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final searchMoviesBloc = SearchMoviesBloc();
