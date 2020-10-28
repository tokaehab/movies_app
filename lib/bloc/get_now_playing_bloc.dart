import '../models/movie_response.dart';
import '../repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovies() async {
    MovieResponse response = await _repository.getPlaying();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final nowPlayingBloc = NowPlayingBloc();
