import 'package:flutter/cupertino.dart';
import '../models/person_response.dart';
import '../repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject =
      BehaviorSubject<PersonResponse>();

  getPersons() async {
    PersonResponse response = await _repository.getPersons();
    _subject.sink.add(response);
  }

  @mustCallSuper
  void dispose() async {
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject => _subject;
}

final personBloc = PersonBloc();
