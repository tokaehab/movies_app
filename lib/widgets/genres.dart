import 'package:flutter/material.dart';
import 'package:movies_app/bloc/get_genre_bloc.dart';
import 'package:movies_app/models/genre.dart';
import 'package:movies_app/models/genre_responses.dart';
import 'package:movies_app/widgets/Loading.dart';
import 'genres_list.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState() {
    super.initState();
    genresBloc.getGenres();
  }

  Widget _buildGenresWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Text('No Genre'),
      );
    } else {
      return GenresList(genres: genres);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorWidget(snapshot.data.error);
          }
          return _buildGenresWidget(snapshot.data);
        } else if (snapshot.hasError)
          return ErrorWidget(snapshot.error);
        else
          return Loading();
      },
    );
  }
}
